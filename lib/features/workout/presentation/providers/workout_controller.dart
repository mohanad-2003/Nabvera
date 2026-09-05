import 'package:nabvera/features/profile/data/user_repository.dart';
import 'package:nabvera/features/profile/presentation/providers/profile_controller.dart';
import 'package:nabvera/features/workout/data/workout_repository.dart';
import 'package:nabvera/features/workout/domain/workout_models.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'workout_controller.g.dart';

@riverpod
class WorkoutTab extends _$WorkoutTab {
  @override
  WorkoutLevel build() => WorkoutLevel.beginner;

  void select(WorkoutLevel level) => state = level;
}

/// Loads `/api/workouts?difficulty=<level>` for the selected tab. Starts
/// empty and fills in once the fetch resolves — matches the pattern used by
/// `CurrentUserProfile` so the page never needs an `AsyncValue` branch.
@riverpod
class WorkoutListByLevel extends _$WorkoutListByLevel {
  @override
  List<WorkoutListItem> build(WorkoutLevel level) {
    Future.microtask(_load);
    return const [];
  }

  Future<void> _load() async {
    try {
      final favoriteIds =
          ref.read(currentUserProfileProvider).favoriteWorkoutIds.toSet();
      final docs = await ref
          .read(workoutRepositoryProvider)
          .fetchWorkouts(difficulty: level.name);
      state = [
        for (final doc in docs)
          WorkoutListItem.fromJson(
            doc,
            isFavorite: favoriteIds.contains(doc['_id']),
          ),
      ];
    } catch (_) {
      // Left empty — the page renders its normal (empty-list) layout
      // rather than crashing when the backend is unreachable.
    }
  }

  Future<void> toggleFavorite(int index) async {
    final item = state[index];
    if (item.id.isEmpty) return;
    state = [
      for (var i = 0; i < state.length; i++)
        if (i == index) item.copyWith(isFavorite: !item.isFavorite) else state[i],
    ];
    try {
      await ref.read(userRepositoryProvider).toggleFavoriteWorkout(item.id);
      ref.invalidate(currentUserProfileProvider);
    } catch (_) {
      // Revert on failure.
      state = [
        for (var i = 0; i < state.length; i++)
          if (i == index) item else state[i],
      ];
    }
  }
}
