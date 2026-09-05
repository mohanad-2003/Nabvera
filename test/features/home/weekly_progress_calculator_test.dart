import 'package:nabvera/features/home/domain/weekly_progress_calculator.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  // Wednesday — puts both "start of week" and "start of last week"
  // comfortably inside the covered date range for every test below.
  final now = DateTime(2026, 1, 7, 12);
  // Monday of the current week.
  final mondayThisWeek = DateTime(2026, 1, 5);
  final mondayLastWeek = DateTime(2026, 1, 5).subtract(const Duration(days: 7));

  group('computeWeeklyProgressFromEntries — empty input', () {
    test('returns the empty-shaped stats with hasAnyLogs=false', () {
      final stats = computeWeeklyProgressFromEntries([], now: now);
      expect(stats.hasAnyLogs, isFalse);
      expect(stats.totalMinutesThisWeek, 0);
      expect(stats.totalMinutesLastWeek, 0);
      expect(stats.workoutsThisWeek, 0);
      expect(stats.longestStreakDays, 0);
      expect(stats.minutesByDay, [0, 0, 0, 0, 0, 0, 0]);
      expect(stats.percentChangeVsLastWeek, isNull);
    });
  });

  group('computeWeeklyProgressFromEntries — this week only', () {
    test('sums minutes per day and totals correctly', () {
      final entries = [
        WorkoutLogEntry(completedAt: mondayThisWeek, minutes: 20),
        WorkoutLogEntry(
          completedAt: mondayThisWeek.add(const Duration(days: 2)),
          minutes: 30,
        ),
      ];
      final stats = computeWeeklyProgressFromEntries(entries, now: now);
      expect(stats.hasAnyLogs, isTrue);
      expect(stats.minutesByDay[0], 20); // Monday
      expect(stats.minutesByDay[2], 30); // Wednesday
      expect(stats.totalMinutesThisWeek, 50);
      expect(stats.workoutsThisWeek, 2);
    });

    test('a log outside the 7-day window (before last week) is ignored', () {
      final entries = [
        WorkoutLogEntry(
          completedAt: mondayThisWeek.subtract(const Duration(days: 30)),
          minutes: 999,
        ),
      ];
      final stats = computeWeeklyProgressFromEntries(entries, now: now);
      expect(stats.totalMinutesThisWeek, 0);
      expect(stats.totalMinutesLastWeek, 0);
      // Still counts toward "has this user ever logged anything".
      expect(stats.hasAnyLogs, isTrue);
    });
  });

  group('computeWeeklyProgressFromEntries — longest streak', () {
    test('finds consecutive workout days within the week', () {
      final entries = [
        WorkoutLogEntry(completedAt: mondayThisWeek, minutes: 10), // Mon
        WorkoutLogEntry(
          completedAt: mondayThisWeek.add(const Duration(days: 1)),
          minutes: 10,
        ), // Tue
        WorkoutLogEntry(
          completedAt: mondayThisWeek.add(const Duration(days: 2)),
          minutes: 10,
        ), // Wed
        // Thu/Fri rest
        WorkoutLogEntry(
          completedAt: mondayThisWeek.add(const Duration(days: 5)),
          minutes: 10,
        ), // Sat
      ];
      final stats = computeWeeklyProgressFromEntries(entries, now: now);
      expect(stats.longestStreakDays, 3);
      expect(stats.workoutsThisWeek, 4);
    });

    test('a zero-minute log does not count as a worked-out day', () {
      final entries = [
        WorkoutLogEntry(completedAt: mondayThisWeek, minutes: 0),
      ];
      final stats = computeWeeklyProgressFromEntries(entries, now: now);
      expect(stats.longestStreakDays, 0);
      expect(stats.workoutsThisWeek, 0);
    });
  });

  group('computeWeeklyProgressFromEntries — week-over-week comparison', () {
    test('computes a delta and percent change when last week has data', () {
      final entries = [
        WorkoutLogEntry(completedAt: mondayThisWeek, minutes: 60),
        WorkoutLogEntry(completedAt: mondayLastWeek, minutes: 40),
      ];
      final stats = computeWeeklyProgressFromEntries(entries, now: now);
      expect(stats.totalMinutesThisWeek, 60);
      expect(stats.totalMinutesLastWeek, 40);
      expect(stats.minutesDelta, 20);
      expect(stats.percentChangeVsLastWeek, closeTo(50.0, 0.001));
    });

    test('percentChangeVsLastWeek is null with no last-week baseline', () {
      final entries = [
        WorkoutLogEntry(completedAt: mondayThisWeek, minutes: 60),
      ];
      final stats = computeWeeklyProgressFromEntries(entries, now: now);
      expect(stats.totalMinutesLastWeek, 0);
      expect(stats.percentChangeVsLastWeek, isNull);
      // The raw delta is still meaningful even without a percent.
      expect(stats.minutesDelta, 60);
    });
  });

  group('WorkoutLogEntry.fromJson — backward compatibility', () {
    test('prefers actualDurationMinutes when present', () {
      final entry = WorkoutLogEntry.fromJson({
        'completedAt': '2026-01-05T10:00:00.000Z',
        'durationMinutes': 45,
        'actualDurationMinutes': 30,
      });
      expect(entry!.minutes, 30);
    });

    test('falls back to durationMinutes for older logs', () {
      final entry = WorkoutLogEntry.fromJson({
        'completedAt': '2026-01-05T10:00:00.000Z',
        'durationMinutes': 45,
      });
      expect(entry!.minutes, 45);
    });

    test('returns null when completedAt is missing/unparseable', () {
      expect(WorkoutLogEntry.fromJson({'durationMinutes': 20}), isNull);
      expect(
        WorkoutLogEntry.fromJson({
          'completedAt': 'not-a-date',
          'durationMinutes': 20,
        }),
        isNull,
      );
    });
  });
}
