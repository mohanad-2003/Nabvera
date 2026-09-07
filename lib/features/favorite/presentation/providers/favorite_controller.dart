import 'package:nabvera/features/favorite/domain/favorite_models.dart';
import 'package:nabvera/features/nutrition/data/nutrition_repository.dart';
import 'package:nabvera/features/profile/data/user_repository.dart';
import 'package:nabvera/features/profile/presentation/providers/profile_controller.dart';
import 'package:nabvera/features/workout/data/workout_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'favorite_controller.g.dart';

enum FavoriteFilter { all, video, article }

@riverpod
class FavoriteFilterController extends _$FavoriteFilterController {
  @override
  FavoriteFilter build() => FavoriteFilter.all;

  void select(FavoriteFilter filter) => state = filter;
}

/// Loads the user's real favorites — `favoriteWorkoutIds` fetched from
/// `/api/workouts/:id` (shown as "video" cards) and `favoriteRecipeIds`
/// from `/api/recipes/:id` ("article" cards). There's no batch-by-ids
/// endpoint, so this fetches each favorite individually; fine at the
/// small scale a favorites list actually reaches.
@riverpod
class FilteredFavorites extends _$FilteredFavorites {
  @override
  List<FavoriteItem> build() {
    final filter = ref.watch(favoriteFilterControllerProvider);
    ref.watch(currentUserProfileProvider);
    Future.microtask(_load);
    return _applyFilter(_cache, filter);
  }

  List<FavoriteItem> _cache = const [];

  Future<void> _load() async {
    final profile = ref.read(currentUserProfileProvider);
    final workoutRepo = ref.read(workoutRepositoryProvider);
    final recipeRepo = ref.read(nutritionRepositoryProvider);

    final items = <FavoriteItem>[];
    for (final id in profile.favoriteWorkoutIds) {
      try {
        items.add(
          FavoriteItem.fromWorkoutJson(await workoutRepo.fetchWorkoutById(id)),
        );
      } catch (_) {
        // Skip a favorite that no longer resolves (deleted workout, etc.).
      }
    }
    for (final id in profile.favoriteRecipeIds) {
      try {
        items.add(
          FavoriteItem.fromRecipeJson(await recipeRepo.fetchRecipeById(id)),
        );
      } catch (_) {
        // Skip a favorite that no longer resolves.
      }
    }
    // This provider is autoDispose — the Favorites page can be popped
    // (tearing this down) while the loop above is still awaiting a
    // fetch. Writing to `state` after that throws UnmountedRefException;
    // `ref.mounted` after the async work is the documented guard.
    if (!ref.mounted) return;
    _cache = items;
    state = _applyFilter(items, ref.read(favoriteFilterControllerProvider));
  }

  List<FavoriteItem> _applyFilter(
    List<FavoriteItem> items,
    FavoriteFilter filter,
  ) {
    return switch (filter) {
      FavoriteFilter.all => items,
      FavoriteFilter.video =>
        items.where((i) => i.type == FavoriteType.video).toList(),
      FavoriteFilter.article =>
        items.where((i) => i.type == FavoriteType.article).toList(),
    };
  }

  /// Unfavorites an item and removes it from the list immediately.
  Future<void> remove(FavoriteItem item) async {
    _cache = _cache.where((i) => i.id != item.id).toList();
    state = _applyFilter(_cache, ref.read(favoriteFilterControllerProvider));
    final repo = ref.read(userRepositoryProvider);
    try {
      if (item.type == FavoriteType.video) {
        await repo.toggleFavoriteWorkout(item.id);
      } else {
        await repo.toggleFavoriteRecipe(item.id);
      }
      if (!ref.mounted) return;
      ref.invalidate(currentUserProfileProvider);
    } catch (_) {
      // Left removed locally — a stale favorite id is harmless, and the
      // next full profile refresh reconciles it either way.
    }
  }
}
