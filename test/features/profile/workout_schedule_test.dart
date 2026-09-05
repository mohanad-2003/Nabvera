import 'package:flutter/material.dart';
import 'package:nabvera/features/profile/domain/workout_schedule.dart';
import 'package:nabvera/features/workout/domain/workout_models.dart' show Weekday;
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('weekday <-> backend day-code conversion', () {
    test('every Weekday round-trips through its API code', () {
      for (final day in Weekday.values) {
        expect(weekdayFromApi(weekdayToApi(day)), day);
      }
    });

    test('workoutDaysFromApi ignores unknown/malformed entries', () {
      final days = workoutDaysFromApi(['mon', 'not_a_day', 'fri', 123]);
      expect(days, {Weekday.monday, Weekday.friday});
    });

    test('workoutDaysFromApi returns {} for non-list input', () {
      expect(workoutDaysFromApi(null), isEmpty);
      expect(workoutDaysFromApi('mon'), isEmpty);
    });

    test('workoutDaysToApi preserves Monday-first order regardless of Set iteration order', () {
      final days = {Weekday.friday, Weekday.monday, Weekday.wednesday};
      expect(workoutDaysToApi(days), ['mon', 'wed', 'fri']);
    });
  });

  group('parseTimeOfDay / formatTimeOfDay', () {
    test('round-trips every valid boundary time', () {
      for (final time in [
        const TimeOfDay(hour: 0, minute: 0),
        const TimeOfDay(hour: 23, minute: 59),
        const TimeOfDay(hour: 9, minute: 5),
      ]) {
        expect(parseTimeOfDay(formatTimeOfDay(time)), time);
      }
    });

    test('formatTimeOfDay zero-pads hour and minute', () {
      expect(formatTimeOfDay(const TimeOfDay(hour: 6, minute: 5)), '06:05');
    });

    test('parseTimeOfDay rejects malformed/out-of-range/missing values', () {
      expect(parseTimeOfDay(null), isNull);
      expect(parseTimeOfDay(''), isNull);
      expect(parseTimeOfDay('24:00'), isNull);
      expect(parseTimeOfDay('12:60'), isNull);
      expect(parseTimeOfDay('7:30'), isNull); // not zero-padded
      expect(parseTimeOfDay('not a time'), isNull);
    });
  });

  group('isWithinQuietHours', () {
    test('a same-day window (start before end) works like a normal range', () {
      const start = TimeOfDay(hour: 13, minute: 0);
      const end = TimeOfDay(hour: 15, minute: 0);
      expect(
        isWithinQuietHours(time: const TimeOfDay(hour: 14, minute: 0), start: start, end: end),
        true,
      );
      expect(
        isWithinQuietHours(time: const TimeOfDay(hour: 12, minute: 59), start: start, end: end),
        false,
      );
      expect(
        isWithinQuietHours(time: const TimeOfDay(hour: 15, minute: 0), start: start, end: end),
        false, // end is exclusive
      );
    });

    test('a window crossing midnight (22:00 -> 06:00) covers late night and early morning', () {
      const start = TimeOfDay(hour: 22, minute: 0);
      const end = TimeOfDay(hour: 6, minute: 0);
      expect(
        isWithinQuietHours(time: const TimeOfDay(hour: 23, minute: 30), start: start, end: end),
        true,
      );
      expect(
        isWithinQuietHours(time: const TimeOfDay(hour: 3, minute: 0), start: start, end: end),
        true,
      );
      expect(
        isWithinQuietHours(time: const TimeOfDay(hour: 6, minute: 0), start: start, end: end),
        false, // end is exclusive
      );
      expect(
        isWithinQuietHours(time: const TimeOfDay(hour: 12, minute: 0), start: start, end: end),
        false,
      );
    });

    test('a midnight-crossing window boundary at the start is included', () {
      expect(
        isWithinQuietHours(
          time: const TimeOfDay(hour: 22, minute: 0),
          start: const TimeOfDay(hour: 22, minute: 0),
          end: const TimeOfDay(hour: 6, minute: 0),
        ),
        true,
      );
    });

    test('identical start and end is treated as quiet all day', () {
      const same = TimeOfDay(hour: 8, minute: 0);
      expect(
        isWithinQuietHours(time: const TimeOfDay(hour: 0, minute: 0), start: same, end: same),
        true,
      );
      expect(
        isWithinQuietHours(time: const TimeOfDay(hour: 23, minute: 59), start: same, end: same),
        true,
      );
    });
  });

  group('computeWeekPlan', () {
    test('a selected day with no logged minutes shows as a workout day', () {
      final now = DateTime(2026, 1, 5); // a Monday
      final plan = computeWeekPlan(
        workoutDays: {Weekday.monday},
        now: now,
        minutesByDay: [0, 0, 0, 0, 0, 0, 0],
      );
      final monday = plan.firstWhere((d) => d.day == Weekday.monday);
      expect(monday.isToday, true);
      expect(monday.status, DayPlanStatus.workoutDay);
    });

    test('an unselected day is a rest day', () {
      final plan = computeWeekPlan(
        workoutDays: {Weekday.monday},
        now: DateTime(2026, 1, 5),
        minutesByDay: [0, 0, 0, 0, 0, 0, 0],
      );
      final tuesday = plan.firstWhere((d) => d.day == Weekday.tuesday);
      expect(tuesday.status, DayPlanStatus.restDay);
    });

    test('a day with logged minutes shows as completed even if it was a rest day', () {
      final plan = computeWeekPlan(
        workoutDays: {Weekday.monday},
        now: DateTime(2026, 1, 6), // Tuesday
        minutesByDay: [0, 30, 0, 0, 0, 0, 0], // Tuesday trained
      );
      final tuesday = plan.firstWhere((d) => d.day == Weekday.tuesday);
      expect(tuesday.status, DayPlanStatus.completed);
    });

    test('todayPlanStatus reads off the day flagged isToday', () {
      final plan = computeWeekPlan(
        workoutDays: {Weekday.wednesday},
        now: DateTime(2026, 1, 7), // Wednesday
        minutesByDay: [0, 0, 0, 0, 0, 0, 0],
      );
      expect(todayPlanStatus(plan), DayPlanStatus.workoutDay);
    });

    test('produces exactly 7 days, Monday through Sunday', () {
      final plan = computeWeekPlan(
        workoutDays: const {},
        now: DateTime(2026, 1, 5),
        minutesByDay: [0, 0, 0, 0, 0, 0, 0],
      );
      expect(plan.map((d) => d.day).toList(), Weekday.values);
    });
  });

  group('computeUpcomingReminderOccurrences', () {
    final reminderTime = const TimeOfDay(hour: 18, minute: 0);

    test('schedules the selected weekday(s) within the lookahead window', () {
      final now = DateTime(2026, 1, 5, 8, 0); // Monday morning
      final occurrences = computeUpcomingReminderOccurrences(
        workoutDays: {Weekday.monday, Weekday.wednesday},
        reminderTime: reminderTime,
        now: now,
        hasWorkoutToday: false,
      );
      expect(occurrences.map((o) => o.day).toList(), [
        Weekday.monday,
        Weekday.wednesday,
      ]);
    });

    test('skips today if the user already logged a workout today', () {
      final now = DateTime(2026, 1, 5, 8, 0); // Monday
      final occurrences = computeUpcomingReminderOccurrences(
        workoutDays: {Weekday.monday},
        reminderTime: reminderTime,
        now: now,
        hasWorkoutToday: true,
        daysAhead: 7,
      );
      // The only selected day is Monday, which recurs next Monday (offset 7,
      // excluded by the 7-day window) — so nothing is scheduled at all.
      expect(occurrences, isEmpty);
    });

    test('skips today if the reminder time has already passed', () {
      final now = DateTime(2026, 1, 5, 20, 0); // Monday, after 18:00
      final occurrences = computeUpcomingReminderOccurrences(
        workoutDays: {Weekday.monday, Weekday.tuesday},
        reminderTime: reminderTime,
        now: now,
        hasWorkoutToday: false,
      );
      expect(occurrences.map((o) => o.day).toList(), [Weekday.tuesday]);
    });

    test('still schedules today if the reminder time has not passed yet', () {
      final now = DateTime(2026, 1, 5, 8, 0); // Monday morning, before 18:00
      final occurrences = computeUpcomingReminderOccurrences(
        workoutDays: {Weekday.monday},
        reminderTime: reminderTime,
        now: now,
        hasWorkoutToday: false,
      );
      expect(occurrences.length, 1);
      expect(occurrences.first.dateTime, DateTime(2026, 1, 5, 18, 0));
    });

    test('schedules nothing when no days are selected', () {
      final occurrences = computeUpcomingReminderOccurrences(
        workoutDays: const {},
        reminderTime: reminderTime,
        now: DateTime(2026, 1, 5, 8, 0),
        hasWorkoutToday: false,
      );
      expect(occurrences, isEmpty);
    });

    test('schedules nothing at all when the reminder time itself falls inside quiet hours', () {
      final occurrences = computeUpcomingReminderOccurrences(
        workoutDays: {Weekday.monday, Weekday.tuesday, Weekday.wednesday},
        reminderTime: const TimeOfDay(hour: 23, minute: 0),
        now: DateTime(2026, 1, 5, 8, 0),
        hasWorkoutToday: false,
        quietHoursEnabled: true,
        quietHoursStart: const TimeOfDay(hour: 22, minute: 0),
        quietHoursEnd: const TimeOfDay(hour: 6, minute: 0),
      );
      expect(occurrences, isEmpty);
    });

    test('still schedules when quiet hours are enabled but the reminder time is outside them', () {
      final occurrences = computeUpcomingReminderOccurrences(
        workoutDays: {Weekday.monday},
        reminderTime: reminderTime, // 18:00, outside 22:00-06:00
        now: DateTime(2026, 1, 5, 8, 0),
        hasWorkoutToday: false,
        quietHoursEnabled: true,
        quietHoursStart: const TimeOfDay(hour: 22, minute: 0),
        quietHoursEnd: const TimeOfDay(hour: 6, minute: 0),
      );
      expect(occurrences.length, 1);
    });

    test('changing the schedule changes which occurrences would be (re)scheduled', () {
      final now = DateTime(2026, 1, 5, 8, 0); // Monday
      final before = computeUpcomingReminderOccurrences(
        workoutDays: {Weekday.monday},
        reminderTime: reminderTime,
        now: now,
        hasWorkoutToday: false,
      );
      final after = computeUpcomingReminderOccurrences(
        workoutDays: {Weekday.tuesday, Weekday.thursday},
        reminderTime: reminderTime,
        now: now,
        hasWorkoutToday: false,
      );
      expect(before.map((o) => o.day).toList(), [Weekday.monday]);
      expect(after.map((o) => o.day).toList(), [Weekday.tuesday, Weekday.thursday]);
      // The scheduler cancels every one of the 7 stable per-weekday ids on
      // every reschedule (see `WorkoutReminderScheduler.rescheduleAll`), so
      // "changing the schedule" is exactly "compute a new occurrence list
      // and hand it to the same cancel-then-schedule routine" — this just
      // confirms the pure computation actually reflects the change.
      expect(before, isNot(equals(after)));
    });

    test('never returns more than one occurrence per weekday even with a long lookahead', () {
      final occurrences = computeUpcomingReminderOccurrences(
        workoutDays: {Weekday.monday},
        reminderTime: reminderTime,
        now: DateTime(2026, 1, 5, 8, 0),
        hasWorkoutToday: false,
        daysAhead: 14,
      );
      expect(occurrences.length, 1);
    });
  });
}
