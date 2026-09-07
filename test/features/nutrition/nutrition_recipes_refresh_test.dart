import 'package:nabvera/features/nutrition/data/nutrition_repository.dart';
import 'package:nabvera/features/nutrition/presentation/providers/nutrition_controller.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

/// A hand-written test double — same pattern as
/// `meal_logging_controller_test.dart`'s `FakeNutritionRepository`.
class FakeNutritionRepository implements NutritionRepository {
  List<Map<String, dynamic>> recipes = [];
  int fetchRecipesCallCount = 0;
  bool throwOnNextFetch = false;

  @override
  Future<List<Map<String, dynamic>>> fetchRecipes({String? category}) async {
    fetchRecipesCallCount++;
    if (throwOnNextFetch) {
      throwOnNextFetch = false;
      throw Exception('network error');
    }
    return recipes;
  }

  @override
  Future<Map<String, dynamic>> fetchToday() async => {};
  @override
  Future<Map<String, dynamic>> logMeal({required String recipeId, required String mealType, String? mealPlanItemId}) async => {};
  @override
  Future<Map<String, dynamic>> unlogMeal(String logId) async => {};
  @override
  Future<Map<String, dynamic>> logWater(int amountMl) async => {};
  @override
  Future<Map<String, dynamic>> fetchRecipeById(String id) async => {};
  @override
  Future<Map<String, dynamic>> fetchNutritionPreferences() async => {};
  @override
  Future<Map<String, dynamic>> updateNutritionPreferences(Map<String, dynamic> payload) async => {};
  @override
  Future<Map<String, dynamic>> fetchCalorieSuggestion() async => {};
  @override
  Future<Map<String, dynamic>?> fetchCurrentMealPlan() async => null;
  @override
  Future<List<Map<String, dynamic>>> fetchMealPlanHistory() async => [];
  @override
  Future<Map<String, dynamic>> generateMealPlan([Map<String, dynamic> overrides = const {}]) async => {};
  @override
  Future<Map<String, dynamic>> regenerateMealPlanDay(String planId, int dayIndex) async => {};
  @override
  Future<Map<String, dynamic>> replaceMealPlanMeal(String planId, {required int dayIndex, required String mealType, required String itemId, String? recipeId}) async => {};
  @override
  Future<void> checkShoppingListItem(String planId, {required String itemId, required bool checked}) async {}
}

Map<String, dynamic> _recipe(String id, {num rating = 4}) => {
  '_id': id,
  'name': 'Recipe $id',
  'rating': rating,
};

void main() {
  test('refresh() re-fetches and updates both Recommended and Recipes for you', () async {
    final fake = FakeNutritionRepository();
    fake.recipes = [_recipe('a'), _recipe('b'), _recipe('c')];
    final container = ProviderContainer(overrides: [nutritionRepositoryProvider.overrideWithValue(fake)]);
    addTearDown(container.dispose);

    // Settle the initial (empty) build first.
    container.read(nutritionRecipesSourceProvider.notifier);
    await pumpEventQueue();

    await container.read(nutritionRecipesSourceProvider.notifier).refresh();
    expect(fake.fetchRecipesCallCount, greaterThanOrEqualTo(1));

    // Sorted by rating desc: top 2 go to "Recommended", the rest to "Recipes".
    expect(container.read(nutritionRecommendedProvider), hasLength(2));
    expect(container.read(nutritionRecipesProvider), hasLength(1));
    expect(container.read(nutritionRecommendedProvider).map((e) => e.id), ['a', 'b']);
    await pumpEventQueue();
  });

  test('a failed refresh() throws but leaves the last successful lists showing (no fake/empty data)', () async {
    final fake = FakeNutritionRepository();
    fake.recipes = [_recipe('a'), _recipe('b')];
    final container = ProviderContainer(overrides: [nutritionRepositoryProvider.overrideWithValue(fake)]);
    addTearDown(container.dispose);

    await container.read(nutritionRecipesSourceProvider.notifier).refresh();
    expect(container.read(nutritionRecommendedProvider), hasLength(2));

    fake.throwOnNextFetch = true;
    await expectLater(
      container.read(nutritionRecipesSourceProvider.notifier).refresh(),
      throwsA(isA<Exception>()),
    );

    // Still showing the previously-loaded recipes, not an empty list.
    expect(container.read(nutritionRecommendedProvider), hasLength(2));
    expect(container.read(nutritionRecipesProvider), isEmpty);
    await pumpEventQueue();
  });
}
