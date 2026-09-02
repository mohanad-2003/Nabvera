import 'package:fitness_app/features/profile/presentation/providers/profile_controller.dart';
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
    required this.recommendationBasis,
  });

  final String id;
  final String title;
  final int durationMinutes;
  final int estimatedCalories;
  final String difficulty;
  final int exerciseCount;
  final RecommendationBasis recommendationBasis;
}

enum RecommendationBasis { personalized, fallback }

@riverpod
class HomeFeaturedWorkoutController extends _$HomeFeaturedWorkoutController {
  @override
  HomeFeaturedWorkout? build() {
    final profile = ref.watch(currentUserProfileProvider);
    Future.microtask(() => _load(profile: profile));
    return null;
  }

  Future<void> _load({required dynamic profile, bool easierOnly = false}) async {
    try {
      final repo = ref.read(workoutRepositoryProvider);
      final docs = await repo.fetchWorkouts();
      if (docs.isEmpty) return;
      final preferredLevel = easierOnly ? 'beginner' : (profile.activityLevel as String? ?? 'beginner');
      final preferredMinutes = profile.availableMinutes as int? ?? 30;
      final equipment = profile.availableEquipment as List<String>? ?? const <String>[];
      final preferredCategory = switch (profile.goal as String?) {
        'gain_muscle' => 'strength',
        'lose_weight' || 'endurance' => 'cardio',
        _ => null,
      };
      final exact = docs.where((doc) =>
          doc['difficulty'] == preferredLevel &&
          (preferredCategory == null || doc['category'] == preferredCategory) &&
          _fitsTime(doc, preferredMinutes) &&
          _matchesEquipment(doc, equipment) &&
          doc['_id'] != state?.id).toList();
      final compatible = docs.where((doc) =>
          _fitsTime(doc, preferredMinutes) &&
          _matchesEquipment(doc, equipment) &&
          doc['_id'] != state?.id).toList();
      final doc = exact.isNotEmpty ? exact.first : compatible.isNotEmpty ? compatible.first : docs.first;
      state = _toFeatured(doc, exact.isNotEmpty ? RecommendationBasis.personalized : RecommendationBasis.fallback);
    } catch (_) {
      // Left null — see WorkoutListByLevel for the same pattern.
    }
  }

  Future<void> chooseEasierWorkout() async {
    await _load(profile: ref.read(currentUserProfileProvider), easierOnly: true);
  }

  static bool _fitsTime(Map<String, dynamic> workout, int availableMinutes) =>
      (workout['durationMinutes'] as num? ?? 0) <= availableMinutes;

  static bool _matchesEquipment(Map<String, dynamic> workout, List<String> availableEquipment) {
    if (availableEquipment.isEmpty) return true;
    final available = availableEquipment.toSet();
    final exercises = workout['exercises'] as List? ?? const [];
    return exercises.every((entry) {
      if (entry is! Map) return true;
      final exercise = entry['exercise'];
      if (exercise is! Map) return true;
      final required = exercise['equipment'] as String? ?? 'none';
      return required == 'none' || available.contains(required);
    });
  }

  static HomeFeaturedWorkout _toFeatured(Map<String, dynamic> doc, RecommendationBasis basis) =>
      HomeFeaturedWorkout(
        id: (doc['_id'] as String?) ?? '',
        title: (doc['title'] as String?) ?? '',
        durationMinutes: (doc['durationMinutes'] as num?)?.toInt() ?? 0,
        estimatedCalories: (doc['estimatedCalories'] as num?)?.toInt() ?? 0,
        difficulty: (doc['difficulty'] as String?) ?? 'beginner',
        exerciseCount: (doc['exercises'] as List?)?.length ?? 0,
        recommendationBasis: basis,
      );
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
