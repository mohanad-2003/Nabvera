/// Pure, backend-shape-agnostic weekly progress math — kept free of
/// Riverpod/network concerns so it can be unit-tested directly (see
/// `test/features/home/weekly_progress_calculator_test.dart`).
library;

/// One workout log's date and duration, already reduced from whatever the
/// raw backend JSON looked like. [minutes] prefers `actualDurationMinutes`
/// (the real, measured session length) and falls back to `durationMinutes`
/// for older logs that predate that field — see [WorkoutLogEntry.fromJson].
class WorkoutLogEntry {
  const WorkoutLogEntry({required this.completedAt, required this.minutes});

  final DateTime completedAt;
  final int minutes;

  /// Builds one entry from a raw `/api/workout-logs` document. Returns
  /// `null` for a log with no parseable `completedAt` — such a log can't be
  /// placed in any week, so it's dropped rather than guessed at.
  static WorkoutLogEntry? fromJson(Map<String, dynamic> json) {
    final completedAt = DateTime.tryParse(
      json['completedAt'] as String? ?? '',
    );
    if (completedAt == null) return null;
    final actual = (json['actualDurationMinutes'] as num?)?.toInt();
    final planned = (json['durationMinutes'] as num?)?.toInt();
    final minutes = actual ?? planned ?? 0;
    return WorkoutLogEntry(completedAt: completedAt, minutes: minutes);
  }
}

/// Everything the weekly-progress card needs, computed once from a flat
/// list of logs. Both `minutesByDay` lists are index 0 = Monday, matching
/// the existing `WeeklyActivityController` convention.
class WeeklyProgressStats {
  const WeeklyProgressStats({
    required this.minutesByDay,
    required this.totalMinutesThisWeek,
    required this.totalMinutesLastWeek,
    required this.workoutsThisWeek,
    required this.longestStreakDays,
    required this.hasAnyLogs,
  });

  final List<int> minutesByDay;
  final int totalMinutesThisWeek;
  final int totalMinutesLastWeek;
  final int workoutsThisWeek;

  /// Longest run of consecutive days *within this week* that had a
  /// workout — not a lifetime streak, just this week's chart.
  final int longestStreakDays;

  /// Whether the user has ever logged a workout at all (any week, not just
  /// this one) — distinguishes "genuinely zero this week" from "brand new
  /// account with nothing to compare against", so the UI can show a real
  /// empty state instead of a misleading "0% vs last week".
  final bool hasAnyLogs;

  static const empty = WeeklyProgressStats(
    minutesByDay: [0, 0, 0, 0, 0, 0, 0],
    totalMinutesThisWeek: 0,
    totalMinutesLastWeek: 0,
    workoutsThisWeek: 0,
    longestStreakDays: 0,
    hasAnyLogs: false,
  );

  /// Difference in minutes vs. last week (positive = more this week).
  int get minutesDelta => totalMinutesThisWeek - totalMinutesLastWeek;

  /// Percent change vs. last week, or `null` when there's no meaningful
  /// baseline to compare against (last week had zero minutes) — a percent
  /// change from zero is either infinite or nonsensical, so the UI should
  /// fall back to an absolute-minutes phrasing instead of showing a number
  /// here.
  double? get percentChangeVsLastWeek {
    if (totalMinutesLastWeek <= 0) return null;
    return ((totalMinutesThisWeek - totalMinutesLastWeek) /
            totalMinutesLastWeek) *
        100;
  }
}

DateTime _startOfWeekFor(DateTime now) {
  final today = DateTime(now.year, now.month, now.day);
  return today.subtract(Duration(days: today.weekday - 1));
}

/// Reduces a flat list of raw workout-log JSON documents into
/// [WeeklyProgressStats] for the week containing [now] (defaults to
/// [DateTime.now]).
WeeklyProgressStats computeWeeklyProgress(
  List<Map<String, dynamic>> rawLogs, {
  DateTime? now,
}) {
  final entries = rawLogs
      .map(WorkoutLogEntry.fromJson)
      .whereType<WorkoutLogEntry>()
      .toList();
  return computeWeeklyProgressFromEntries(entries, now: now);
}

/// Same as [computeWeeklyProgress] but takes already-parsed entries —
/// what the unit tests exercise directly, since building raw JSON maps
/// for every case only obscures what's being tested.
WeeklyProgressStats computeWeeklyProgressFromEntries(
  List<WorkoutLogEntry> entries, {
  DateTime? now,
}) {
  final today = now ?? DateTime.now();
  final startOfThisWeek = _startOfWeekFor(today);
  final startOfLastWeek = startOfThisWeek.subtract(const Duration(days: 7));

  final minutesByDay = List.filled(7, 0);
  var totalThisWeek = 0;
  var totalLastWeek = 0;
  final workedOutDay = List.filled(7, false);

  for (final entry in entries) {
    final dayIndexThisWeek = entry.completedAt
        .difference(startOfThisWeek)
        .inDays;
    if (dayIndexThisWeek >= 0 && dayIndexThisWeek < 7) {
      minutesByDay[dayIndexThisWeek] += entry.minutes;
      totalThisWeek += entry.minutes;
      if (entry.minutes > 0) workedOutDay[dayIndexThisWeek] = true;
      continue;
    }
    final dayIndexLastWeek = entry.completedAt
        .difference(startOfLastWeek)
        .inDays;
    if (dayIndexLastWeek >= 0 && dayIndexLastWeek < 7) {
      totalLastWeek += entry.minutes;
    }
  }

  var longestStreak = 0;
  var currentStreak = 0;
  for (final workedOut in workedOutDay) {
    if (workedOut) {
      currentStreak++;
      if (currentStreak > longestStreak) longestStreak = currentStreak;
    } else {
      currentStreak = 0;
    }
  }

  return WeeklyProgressStats(
    minutesByDay: minutesByDay,
    totalMinutesThisWeek: totalThisWeek,
    totalMinutesLastWeek: totalLastWeek,
    workoutsThisWeek: workedOutDay.where((w) => w).length,
    longestStreakDays: longestStreak,
    hasAnyLogs: entries.isNotEmpty,
  );
}
