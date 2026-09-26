import 'package:nabvera/features/workout/data/workout_repository.dart';
import 'package:nabvera/features/workout/domain/workout_models.dart';
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
          () {
            final sets = (doc['defaultSets'] as num?)?.toInt() ?? 3;
            final caloriesValue =
                (((doc['caloriesPerMinute'] as num?) ?? 5) * 10).toInt();
            return PopularExerciseItem(
              image: (doc['imageUrl'] as String?) ?? 'assets/workout.png',
              name: (doc['name'] as String?) ?? '',
              nameAr: (doc['nameAr'] as String?) ?? '',
              description: (doc['description'] as String?) ?? '',
              descriptionAr: (doc['descriptionAr'] as String?) ?? '',
              time: '$sets sets',
              calories: '$caloriesValue Kcal',
              difficulty: (doc['difficulty'] as String?) ?? 'beginner',
              videoUrl: doc['videoUrl'] as String?,
              sets: sets,
              caloriesValue: caloriesValue,
            );
          }(),
      ];
    } catch (_) {
      // Left empty on failure — see WorkoutListByLevel for the same pattern.
    }
  }
}
