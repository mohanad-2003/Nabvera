import 'package:fitness_app/features/workout/data/workout_repository.dart';
import 'package:fitness_app/features/workout/domain/workout_models.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'your_routine_controller.g.dart';

/// Flattens every exercise across all of the user's `/api/routines` into one
/// list for the "Your Routine" grid. `isFavorite` has no backend equivalent
/// for individual exercises — it stays a local-only UI toggle.
@riverpod
class YourRoutineController extends _$YourRoutineController {
  @override
  List<RoutineItem> build() {
    Future.microtask(_load);
    return const [];
  }

  Future<void> _load() async {
    try {
      final routines = await ref.read(workoutRepositoryProvider).fetchRoutines();
      state = [
        for (final routine in routines)
          for (final entry in (routine['exercises'] as List? ?? const []))
            if (entry['exercise'] is Map<String, dynamic>)
              _toRoutineItem(entry as Map<String, dynamic>),
      ];
    } catch (_) {
      // Left empty on failure — see WorkoutListByLevel for the same pattern.
    }
  }

  RoutineItem _toRoutineItem(Map<String, dynamic> entry) {
    final exercise = entry['exercise'] as Map<String, dynamic>;
    return RoutineItem(
      image: (exercise['imageUrl'] as String?) ?? 'assets/workout.png',
      title: (exercise['name'] as String?) ?? '',
      time: '${entry['sets'] ?? exercise['defaultSets'] ?? 3} sets',
      rep: '${entry['reps'] ?? exercise['defaultReps'] ?? 12} reps',
      muscleGroup: muscleGroupFromApi(exercise['muscleGroup'] as String?),
      videoUrl: exercise['videoUrl'] as String?,
    );
  }

  void toggleFavorite(int index) {
    state = [
      for (var i = 0; i < state.length; i++)
        if (i == index)
          state[i].copyWith(isFavorite: !state[i].isFavorite)
        else
          state[i],
    ];
  }
}
