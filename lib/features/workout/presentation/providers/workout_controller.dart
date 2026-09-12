import 'workout_request_providers.dart';
import 'package:nabvera/features/profile/data/user_repository.dart';
import 'package:nabvera/features/profile/presentation/providers/profile_controller.dart';
import 'package:nabvera/features/workout/domain/workout_models.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'workout_controller.g.dart';

@riverpod
class WorkoutTab extends _$WorkoutTab {
  @override
  WorkoutLevel build() => WorkoutLevel.beginner;

  void select(WorkoutLevel level) => state = level;
}

/// The selected category chip on the Workout tab's list (raw backend
/// `Workout.category` value, or `null` for "All") — kept separate from
/// [WorkoutTab] since the two filters are independent (level always
/// applies; category narrows further).
@riverpod
class WorkoutCategoryFilter extends _$WorkoutCategoryFilter {
  @override
  String? build() => null;

  void select(String? category) => state = category;
}

/// Loads `/api/workouts?difficulty=<level>&category=<category>` for the
/// selected tab + category chip. Starts empty and fills in once the fetch
/// resolves — matches the pattern used by `CurrentUserProfile` so the page
/// never needs an `AsyncValue` branch.
@riverpod
class WorkoutListByLevel extends _$WorkoutListByLevel {
  @override
  List<WorkoutListItem> build(WorkoutLevel level) {
    // Watched (not read) so picking a different category chip rebuilds
    // this provider and re-fetches — see WorkoutCategoryFilter.
    final category = ref.watch(workoutCategoryFilterProvider);
    Future.microtask(() => _load(category));
    return const [];
  }

  Future<void> _load(String? category) async {
    try {
      final favoriteIds =
          ref.read(currentUserProfileProvider).favoriteWorkoutIds.toSet();
      final docs = await ref.read(
        workoutRequestProvider((level: level, category: category)).future,
      );
      if (!ref.mounted) return;
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
