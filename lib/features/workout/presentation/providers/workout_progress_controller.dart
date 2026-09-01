import 'package:fitness_app/features/workout/data/workout_repository.dart';
import 'package:fitness_app/features/workout/domain/workout_models.dart';
import 'package:intl/intl.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'workout_progress_controller.g.dart';

enum ProgressTab { logs, charts }

@riverpod
class WorkoutProgressTab extends _$WorkoutProgressTab {
  @override
  ProgressTab build() => ProgressTab.logs;

  void select(ProgressTab tab) => state = tab;
}

/// Loads `/api/workout-logs` — the user's completed-workout history.
@riverpod
class ActivityLog extends _$ActivityLog {
  @override
  List<ActivityLogItem> build() {
    Future.microtask(_load);
    return const [];
  }

  Future<void> _load() async {
    try {
      final logs = await ref.read(workoutRepositoryProvider).fetchWorkoutLogs();
      state = [
        for (final log in logs)
          ActivityLogItem(
            image: 'assets/active_upper.png',
            name: (log['title'] as String?) ?? '',
            calories: '${log['caloriesBurned'] ?? 0} Kcal',
            date: _formatDate(log['completedAt'] as String?),
            duration: '${log['durationMinutes'] ?? 0} Mins',
          ),
      ];
    } catch (_) {
      // Left empty — see WorkoutListByLevel for the same pattern.
    }
  }

  static String _formatDate(String? iso) {
    if (iso == null) return '';
    final date = DateTime.tryParse(iso);
    if (date == null) return '';
    return DateFormat('MMMM d').format(date);
  }
}

/// One day's aggregated training activity — minutes trained, calories
/// burned, and number of completed sessions — for the weekly chart.
class DayActivity {
  const DayActivity({this.minutes = 0, this.calories = 0, this.sessions = 0});

  final int minutes;
  final int calories;
  final int sessions;
}

/// This week's per-day activity built from `/api/workout-logs`, for the
/// Charts tab's bar chart and summary row. Index 0 = Monday.
@riverpod
class WeeklyChart extends _$WeeklyChart {
  @override
  List<DayActivity> build() {
    Future.microtask(_load);
    return List.generate(7, (_) => const DayActivity());
  }

  Future<void> _load() async {
    try {
      final logs = await ref.read(workoutRepositoryProvider).fetchWorkoutLogs();
      final now = DateTime.now();
      final startOfWeek = DateTime(
        now.year,
        now.month,
        now.day,
      ).subtract(Duration(days: now.weekday - 1));

      final minutes = List.filled(7, 0);
      final calories = List.filled(7, 0);
      final sessions = List.filled(7, 0);
      for (final log in logs) {
        final completedAt = DateTime.tryParse(
          log['completedAt'] as String? ?? '',
        );
        if (completedAt == null) continue;
        final dayIndex = completedAt.difference(startOfWeek).inDays;
        if (dayIndex < 0 || dayIndex > 6) continue;
        minutes[dayIndex] += (log['durationMinutes'] as num?)?.toInt() ?? 0;
        calories[dayIndex] += (log['caloriesBurned'] as num?)?.toInt() ?? 0;
        sessions[dayIndex] += 1;
      }
      state = [
        for (var i = 0; i < 7; i++)
          DayActivity(
            minutes: minutes[i],
            calories: calories[i],
            sessions: sessions[i],
          ),
      ];
    } catch (_) {
      // Left at zeros — see WorkoutListByLevel for the same pattern.
    }
  }
}
