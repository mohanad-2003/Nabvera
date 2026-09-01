import 'package:fitness_app/features/workout/data/workout_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'home_dashboard_controller.g.dart';

/// Today's featured workout for the hero card — falls back gracefully to
/// null (the page keeps its static copy) when no workout is marked
/// `isFeatured` yet.
class HomeFeaturedWorkout {
  const HomeFeaturedWorkout({
    required this.id,
    required this.title,
    required this.durationMinutes,
    required this.estimatedCalories,
    required this.difficulty,
    required this.exerciseCount,
  });

  final String id;
  final String title;
  final int durationMinutes;
  final int estimatedCalories;
  final String difficulty;
  final int exerciseCount;
}

@riverpod
class HomeFeaturedWorkoutController extends _$HomeFeaturedWorkoutController {
  @override
  HomeFeaturedWorkout? build() {
    Future.microtask(_load);
    return null;
  }

  Future<void> _load() async {
    try {
      final repo = ref.read(workoutRepositoryProvider);
      var docs = await repo.fetchWorkouts(featured: true);
      if (docs.isEmpty) docs = await repo.fetchWorkouts();
      if (docs.isEmpty) return;
      final doc = docs.first;
      state = HomeFeaturedWorkout(
        id: (doc['_id'] as String?) ?? '',
        title: (doc['title'] as String?) ?? '',
        durationMinutes: (doc['durationMinutes'] as num?)?.toInt() ?? 0,
        estimatedCalories: (doc['estimatedCalories'] as num?)?.toInt() ?? 0,
        difficulty: (doc['difficulty'] as String?) ?? 'beginner',
        exerciseCount: (doc['exercises'] as List?)?.length ?? 0,
      );
    } catch (_) {
      // Left null — see WorkoutListByLevel for the same pattern.
    }
  }
}

/// This week's per-day trained minutes, built from `/api/workout-logs`, for
/// the weekly progress bar chart. Index 0 = Monday.
@riverpod
class WeeklyActivityController extends _$WeeklyActivityController {
  @override
  List<int> build() {
    Future.microtask(_load);
    return const [0, 0, 0, 0, 0, 0, 0];
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

      final minutesByDay = List.filled(7, 0);
      for (final log in logs) {
        final completedAt = DateTime.tryParse(
          log['completedAt'] as String? ?? '',
        );
        if (completedAt == null) continue;
        final dayIndex = completedAt.difference(startOfWeek).inDays;
        if (dayIndex < 0 || dayIndex > 6) continue;
        minutesByDay[dayIndex] +=
            (log['durationMinutes'] as num?)?.toInt() ?? 0;
      }
      state = minutesByDay;
    } catch (_) {
      // Left at zeros — see WorkoutListByLevel for the same pattern.
    }
  }

  /// Today's total trained minutes — index of "now" within this week.
  int get todayMinutes {
    final todayIndex = DateTime.now().weekday - 1;
    return state[todayIndex];
  }
}
