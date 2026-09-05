/// Pure, backend-shape-agnostic scheduling logic — day selection, quiet
/// hours, the weekly plan, and which reminder occurrences to schedule next.
/// Kept free of any plugin/network calls so every rule here is directly
/// unit-testable (see `test/features/profile/workout_schedule_test.dart`).
/// Only [workout_reminder_scheduler.dart] (core/notifications) touches the
/// actual `flutter_local_notifications` plugin with these results.
library;

import 'package:flutter/material.dart';
import 'package:nabvera/features/workout/domain/workout_models.dart' show Weekday;

/// `Weekday` (this app's existing routine-scheduling enum, Monday-first) as
/// the single source of truth for "which day" everywhere schedule-related —
/// reused here rather than inventing a second enum, and converted to/from
/// the backend's plain day-code strings (`User.workoutDays`, same codes
/// `create_routine_controller.dart` already sends for a Routine's days).
const Map<Weekday, String> weekdayApiCodes = {
  Weekday.monday: 'mon',
  Weekday.tuesday: 'tue',
  Weekday.wednesday: 'wed',
  Weekday.thursday: 'thu',
  Weekday.friday: 'fri',
  Weekday.saturday: 'sat',
  Weekday.sunday: 'sun',
};

String weekdayToApi(Weekday day) => weekdayApiCodes[day]!;

Weekday? weekdayFromApi(String? code) {
  for (final entry in weekdayApiCodes.entries) {
    if (entry.value == code) return entry.key;
  }
  return null;
}

Set<Weekday> workoutDaysFromApi(Object? value) {
  if (value is! List) return const {};
  final days = <Weekday>{};
  for (final entry in value) {
    if (entry is! String) continue;
    final day = weekdayFromApi(entry);
    if (day != null) days.add(day);
  }
  return days;
}

List<String> workoutDaysToApi(Set<Weekday> days) =>
    Weekday.values.where(days.contains).map(weekdayToApi).toList();

/// `DateTime.weekday` (1 = Monday .. 7 = Sunday) for a [Weekday] — the
/// bridge between this enum and real dates.
int weekdayToDateTimeWeekday(Weekday day) => Weekday.values.indexOf(day) + 1;

Weekday weekdayFromDateTimeWeekday(int dateTimeWeekday) =>
    Weekday.values[(dateTimeWeekday - 1).clamp(0, 6)];

/// Parses a `"HH:mm"` 24-hour string (the safe, timezone-free wire format
/// for [User.workoutReminderTime]/`quietHoursStart`/`quietHoursEnd|) into a
/// [TimeOfDay]. Returns `null` for anything malformed rather than guessing
/// — an invalid/missing time means "no reminder configured", never a
/// silently wrong time.
final _timePattern = RegExp(r'^([01]\d|2[0-3]):([0-5]\d)$');

TimeOfDay? parseTimeOfDay(String? value) {
  if (value == null) return null;
  final match = _timePattern.firstMatch(value);
  if (match == null) return null;
  return TimeOfDay(hour: int.parse(match.group(1)!), minute: int.parse(match.group(2)!));
}

/// The inverse of [parseTimeOfDay] — always zero-padded 24-hour `"HH:mm"`,
/// matching what the backend validates (see `userController.updateProfile`).
String formatTimeOfDay(TimeOfDay time) =>
    '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';

int _minutesOfDay(TimeOfDay time) => time.hour * 60 + time.minute;

/// Whether [time] falls inside the quiet-hours window `[start, end)`,
/// correctly handling a window that crosses midnight (e.g. 22:00–06:00) —
/// the one case a naive `start <= time && time < end` comparison gets
/// wrong.
bool isWithinQuietHours({
  required TimeOfDay time,
  required TimeOfDay start,
  required TimeOfDay end,
}) {
  final t = _minutesOfDay(time);
  final s = _minutesOfDay(start);
  final e = _minutesOfDay(end);
  if (s == e) {
    // A zero-length window (same start/end) is treated as "quiet all day"
    // rather than "never quiet" — the more conservative reading of a user
    // picking identical start/end times.
    return true;
  }
  if (s < e) {
    return t >= s && t < e;
  }
  // Crosses midnight, e.g. 22:00 -> 06:00: quiet from `start` through
  // midnight, then from midnight through `end`.
  return t >= s || t < e;
}

/// One day's status on the "This Week" schedule card.
enum DayPlanStatus {
  /// A selected workout day the user hasn't logged a workout for (yet, if
  /// it's today; or at all, if it's a past day this week).
  workoutDay,

  /// Not a selected workout day — a deliberate rest day, not a missed one.
  restDay,

  /// A workout was logged this day, regardless of whether it was a
  /// scheduled day — showing up counts, even on an "off" day.
  completed,
}

class DayPlan {
  const DayPlan({
    required this.day,
    required this.isToday,
    required this.status,
  });

  final Weekday day;
  final bool isToday;
  final DayPlanStatus status;
}

/// Builds the Monday–Sunday plan for the current week from the user's
/// selected [workoutDays] and this week's per-day trained minutes
/// ([minutesByDay], index 0 = Monday — the same shape already produced by
/// `WeeklyActivityController`, reused here rather than fetching logs a
/// second time).
List<DayPlan> computeWeekPlan({
  required Set<Weekday> workoutDays,
  required DateTime now,
  required List<int> minutesByDay,
}) {
  final todayIndex = now.weekday - 1;
  return [
    for (var i = 0; i < 7; i++)
      DayPlan(
        day: weekdayFromDateTimeWeekday(i + 1),
        isToday: i == todayIndex,
        status:
            (i < minutesByDay.length && minutesByDay[i] > 0)
                ? DayPlanStatus.completed
                : workoutDays.contains(weekdayFromDateTimeWeekday(i + 1))
                ? DayPlanStatus.workoutDay
                : DayPlanStatus.restDay,
      ),
  ];
}

/// Today's status specifically — the single line the Home schedule card
/// leads with ("Workout day" / "Rest day" / "Completed").
DayPlanStatus todayPlanStatus(List<DayPlan> weekPlan) {
  for (final day in weekPlan) {
    if (day.isToday) return day.status;
  }
  return DayPlanStatus.restDay;
}

/// One reminder to schedule: a concrete local date/time plus the
/// `Weekday` it belongs to (used as a stable notification id so
/// rescheduling only ever touches these 7 slots — see
/// `workout_reminder_scheduler.dart`).
class ReminderOccurrence {
  const ReminderOccurrence({required this.day, required this.dateTime});
  final Weekday day;
  final DateTime dateTime;
}

/// Computes which reminder occurrences should be (re)scheduled right now,
/// looking [daysAhead] days into the future (today included) — pure, no
/// plugin/clock access beyond the passed-in [now].
///
/// A day is skipped when:
/// - its weekday isn't in [workoutDays];
/// - it's today and [hasWorkoutToday] is true (already trained — no need
///   to nag);
/// - it's today and the reminder time has already passed;
/// - [reminderTime] itself falls inside quiet hours (checked once — quiet
///   hours describe a fixed time of day, not a per-date condition).
///
/// Returns at most one occurrence per weekday (never more than 7), each
/// keyed by its [Weekday] so the caller can use a stable notification id.
List<ReminderOccurrence> computeUpcomingReminderOccurrences({
  required Set<Weekday> workoutDays,
  required TimeOfDay reminderTime,
  required DateTime now,
  required bool hasWorkoutToday,
  bool quietHoursEnabled = false,
  TimeOfDay? quietHoursStart,
  TimeOfDay? quietHoursEnd,
  int daysAhead = 7,
}) {
  if (workoutDays.isEmpty) return const [];
  if (quietHoursEnabled &&
      quietHoursStart != null &&
      quietHoursEnd != null &&
      isWithinQuietHours(
        time: reminderTime,
        start: quietHoursStart,
        end: quietHoursEnd,
      )) {
    return const [];
  }

  final today = DateTime(now.year, now.month, now.day);
  final occurrences = <ReminderOccurrence>[];
  final scheduledDays = <Weekday>{};
  for (var offset = 0; offset < daysAhead; offset++) {
    final date = today.add(Duration(days: offset));
    final day = weekdayFromDateTimeWeekday(date.weekday);
    if (!workoutDays.contains(day)) continue;
    // At most one occurrence per weekday — the soonest one — regardless of
    // how far [daysAhead] looks; a longer lookahead would otherwise hit
    // the same weekday twice (e.g. today and again 7 days from now). Only
    // marked "consumed" once an occurrence for it is actually scheduled
    // below — skipping today (already trained / time passed) must still
    // let next week's same weekday through, not block it.
    if (scheduledDays.contains(day)) continue;

    final candidate = DateTime(
      date.year,
      date.month,
      date.day,
      reminderTime.hour,
      reminderTime.minute,
    );
    if (offset == 0) {
      if (hasWorkoutToday) continue;
      if (!candidate.isAfter(now)) continue;
    }
    scheduledDays.add(day);
    occurrences.add(ReminderOccurrence(day: day, dateTime: candidate));
  }
  return occurrences;
}
