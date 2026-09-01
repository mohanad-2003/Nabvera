import 'package:fitness_app/features/workout/data/workout_repository.dart';
import 'package:fitness_app/features/workout/domain/workout_models.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'popular_exercises_controller.g.dart';

@riverpod
class PopularExercises extends _$PopularExercises {
  @override
  List<PopularExerciseItem> build() {
    Future.microtask(_load);
    return const [];
  }

  Future<void> _load() async {
    try {
      final docs = await ref.read(workoutRepositoryProvider).fetchExercises();
      state = [
        for (final doc in docs)
          PopularExerciseItem(
            image: (doc['imageUrl'] as String?) ?? 'assets/workout.png',
            name: (doc['name'] as String?) ?? '',
            time: '${doc['defaultSets'] ?? 3} sets',
            calories:
                '${((doc['caloriesPerMinute'] as num?) ?? 5) * 10} Kcal',
            difficulty: _difficultyLabel(doc['difficulty'] as String?),
            videoUrl: doc['videoUrl'] as String?,
          ),
      ];
    } catch (_) {
      // Left empty on failure — see WorkoutListByLevel for the same pattern.
    }
  }

  static String _difficultyLabel(String? value) => switch (value) {
    'intermediate' => 'Medium',
    'advanced' => 'Hard',
    _ => 'Easy',
  };
}
