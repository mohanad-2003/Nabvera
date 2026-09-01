import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../profile/data/user_repository.dart';
import '../../../profile/presentation/providers/profile_controller.dart';
import '../../data/nutrition_repository.dart';
import '../../domain/nutrition_models.dart';

part 'meal_idea_controller.g.dart';

@riverpod
class MealIdeaCategoryController extends _$MealIdeaCategoryController {
  @override
  MealCategory build() => MealCategory.breakfast;

  void select(MealCategory category) => state = category;
}

/// Loads `/api/recipes?category=<category>`: the highest-rated recipe
/// becomes the section's hero ("top"), the next two are "recommended", and
/// the rest fill "recipes". Falls back to [MealDetail.empty] for `top` when
/// a category has no recipes yet.
@riverpod
class MealIdeaSectionController extends _$MealIdeaSectionController {
  @override
  MealIdeaSection build(MealCategory category) {
    Future.microtask(_load);
    return const MealIdeaSection(
      top: MealDetail.empty,
      recommended: [],
      recipes: [],
    );
  }

  Future<void> _load() async {
    try {
      final docs = await ref
          .read(nutritionRepositoryProvider)
          .fetchRecipes(category: category.name);
      docs.sort(
        (a, b) => ((b['rating'] as num?) ?? 0).compareTo((a['rating'] as num?) ?? 0),
      );
      if (docs.isEmpty) return;
      state = MealIdeaSection(
        top: MealDetail.fromJson(docs.first),
        recommended: docs.skip(1).take(2).map(MealDetail.fromJson).toList(),
        recipes: docs.skip(3).map(MealDetail.fromJson).toList(),
      );
    } catch (_) {
      // Left at the empty placeholder — see WorkoutListByLevel for the
      // same pattern.
    }
  }
}

/// Favorited recipe ids, seeded from the user's real profile
/// (`favoriteRecipeIds`) and kept in sync with
/// `POST /users/me/favorites/recipes/:id` on every toggle.
@riverpod
class MealIdeaFavorites extends _$MealIdeaFavorites {
  @override
  Set<String> build() {
    return ref.watch(currentUserProfileProvider).favoriteRecipeIds.toSet();
  }

  bool isFavorite(String? key) => key != null && state.contains(key);

  Future<void> toggle(String? key) async {
    if (key == null) return;
    final wasFavorite = state.contains(key);
    state = wasFavorite ? ({...state}..remove(key)) : {...state, key};
    try {
      await ref.read(userRepositoryProvider).toggleFavoriteRecipe(key);
    } catch (_) {
      // Revert on failure.
      state = wasFavorite ? {...state, key} : ({...state}..remove(key));
    }
  }
}
