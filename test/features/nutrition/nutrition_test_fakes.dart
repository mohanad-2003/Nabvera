import 'package:nabvera/features/nutrition/data/nutrition_repository.dart';

/// Hand-written test double for [NutritionRepository] shared by the Nutrition
/// page tests — nothing here touches the network or a real account.
class FakeNutritionRepository implements NutritionRepository {
  List<Map<String, dynamic>> recipes = [];
  Map<String, dynamic> today = {};
  Map<String, dynamic>? waterAfterLog;

  int fetchRecipesCallCount = 0;
  bool throwOnNextFetch = false;
  bool alwaysThrowFetch = false;
  bool todayError = false;

  /// When set, fetchRecipes waits on it before answering.
  Future<void>? fetchGate;

  final List<int> logWaterCalls = [];
  final List<String> fetchedRecipeIds = [];
  bool recipeByIdFails = false;

  @override
  Future<List<Map<String, dynamic>>> fetchRecipes({String? category}) async {
    fetchRecipesCallCount++;
    final gate = fetchGate;
    if (gate != null) await gate;
    if (alwaysThrowFetch || throwOnNextFetch) {
      throwOnNextFetch = false;
      throw Exception('network error');
    }
    return [...recipes];
  }

  @override
  Future<Map<String, dynamic>> fetchToday() async {
    if (todayError) throw Exception('network error');
    return today;
  }

  @override
  Future<Map<String, dynamic>> logWater(int amountMl) async {
    logWaterCalls.add(amountMl);
    return waterAfterLog ?? today;
  }

  @override
  Future<Map<String, dynamic>> fetchRecipeById(String id) async {
    fetchedRecipeIds.add(id);
    if (recipeByIdFails) throw Exception('not found');
    return recipes.firstWhere((r) => r['_id'] == id);
  }

  @override
  Future<Map<String, dynamic>> logMeal({
    required String recipeId,
    required String mealType,
    String? mealPlanItemId,
  }) async => {};
  @override
  Future<Map<String, dynamic>> unlogMeal(String logId) async => {};
  @override
  Future<Map<String, dynamic>> fetchNutritionPreferences() async => {};
  @override
  Future<Map<String, dynamic>> updateNutritionPreferences(
    Map<String, dynamic> payload,
  ) async => {};
  @override
  Future<Map<String, dynamic>> fetchCalorieSuggestion() async => {};
  @override
  Future<Map<String, dynamic>?> fetchCurrentMealPlan() async => null;
  @override
  Future<List<Map<String, dynamic>>> fetchMealPlanHistory() async => [];
  @override
  Future<Map<String, dynamic>> generateMealPlan([
    Map<String, dynamic> overrides = const {},
  ]) async => {};
  @override
  Future<Map<String, dynamic>> regenerateMealPlanDay(
    String planId,
    int dayIndex,
  ) async => {};
  @override
  Future<Map<String, dynamic>> replaceMealPlanMeal(
    String planId, {
    required int dayIndex,
    required String mealType,
    required String itemId,
    String? recipeId,
  }) async => {};
  @override
  Future<void> checkShoppingListItem(
    String planId, {
    required String itemId,
    required bool checked,
  }) async {}
}

/// A `/api/recipes`-shaped document with a bundled image, so widget tests
/// never hit the network.
Map<String, dynamic> recipeJson(
  String id, {
  String? title,
  String? titleAr,
  num rating = 4,
  num? protein = 25,
  int? minutes = 20,
  int? calories = 350,
}) => {
  '_id': id,
  'title': title ?? 'Recipe $id',
  'titleAr': titleAr ?? '',
  'imageUrl': 'assets/workout.png',
  'rating': rating,
  'prepTimeMinutes': minutes,
  'nutrition': {'calories': calories, if (protein != null) 'proteinG': protein},
};
