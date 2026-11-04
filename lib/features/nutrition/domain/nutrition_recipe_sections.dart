import 'nutrition_models.dart';

/// How the Nutrition page lays out its recipes: one compact "recipe of the
/// day", the suggested picks, and the explore list — with no recipe shown
/// twice. A view-only split: the shared recipe source
/// (`nutritionRecipesSourceProvider`) is never modified, so other screens
/// reading it are unaffected.
class NutritionRecipeSections {
  const NutritionRecipeSections({
    this.today,
    this.suggested = const [],
    this.explore = const [],
  });

  final MealItem? today;
  final List<MealItem> suggested;
  final List<MealItem> explore;

  bool get isEmpty => today == null && suggested.isEmpty && explore.isEmpty;
}

/// Builds [NutritionRecipeSections] from the two provider lists. The first
/// recommended recipe is "recipe of the day"; every later recipe whose id was
/// already used above it is dropped. Recipes without an id can't be matched
/// (nor opened), so they are kept as they are.
NutritionRecipeSections splitNutritionRecipes({
  required List<MealItem> recommended,
  required List<MealItem> recipes,
}) {
  final seen = <String>{};

  bool take(MealItem item) => item.id.isEmpty || seen.add(item.id);

  MealItem? today;
  final suggested = <MealItem>[];
  for (final item in recommended) {
    if (!take(item)) continue;
    if (today == null) {
      today = item;
    } else {
      suggested.add(item);
    }
  }

  final explore = <MealItem>[
    for (final item in recipes)
      if (take(item)) item,
  ];

  return NutritionRecipeSections(
    today: today,
    suggested: suggested,
    explore: explore,
  );
}
