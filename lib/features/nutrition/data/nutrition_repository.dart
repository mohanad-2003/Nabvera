import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/network/api_client.dart';

part 'nutrition_repository.g.dart';

/// Talks to `/api/recipes`, `/api/meal-plans`, and `/api/nutrition` (see the
/// matching files under `backend/src/routes`). Returns raw decoded JSON —
/// each feature provider maps it into its own display model.
class NutritionRepository {
  NutritionRepository(this._client);

  final ApiClient _client;

  Future<List<Map<String, dynamic>>> fetchRecipes({String? category}) async {
    final query = category == null ? '' : '?category=$category';
    final response = await _client.get('/recipes$query');
    final body = _client.decode(response);
    return (body['data'] as List).cast<Map<String, dynamic>>();
  }

  Future<Map<String, dynamic>> fetchRecipeById(String id) async {
    final response = await _client.get('/recipes/$id');
    final body = _client.decode(response);
    return body['data'] as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> fetchToday() async {
    final response = await _client.get('/nutrition/today');
    final body = _client.decode(response);
    return body['data'] as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> logWater(int amountMl) async {
    final response = await _client.post(
      '/nutrition/water',
      body: {'amountMl': amountMl},
    );
    final body = _client.decode(response);
    return body['data'] as Map<String, dynamic>;
  }

  /// Logs a real, already-existing recipe as eaten ("Mark as eaten").
  /// Never sends nutrition values — the backend always re-reads them from
  /// `Recipe.nutrition` server-side (see
  /// `backend/src/controllers/dailyNutritionController.js`). Pass
  /// [mealPlanItemId] when logging a specific meal-plan slot to get
  /// ownership validation and duplicate-log protection; omit it for a
  /// plain Meal Ideas recipe with no plan association.
  Future<Map<String, dynamic>> logMeal({
    required String recipeId,
    required String mealType,
    String? mealPlanItemId,
  }) async {
    final response = await _client.post(
      '/nutrition/meals',
      body: {
        'recipeId': recipeId,
        'mealType': mealType,
        if (mealPlanItemId != null) 'mealPlanItemId': mealPlanItemId,
      },
    );
    final body = _client.decode(response);
    return body['data'] as Map<String, dynamic>;
  }

  /// Undoes an accidental "mark as eaten".
  Future<Map<String, dynamic>> unlogMeal(String logId) async {
    final response = await _client.delete('/nutrition/meals/$logId');
    final body = _client.decode(response);
    return body['data'] as Map<String, dynamic>;
  }

  // --- Nutrition preferences (Phase 6) ----------------------------------

  Future<Map<String, dynamic>> fetchNutritionPreferences() async {
    final response = await _client.get('/users/me/nutrition-preferences');
    final body = _client.decode(response);
    return body['data'] as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> updateNutritionPreferences(Map<String, dynamic> payload) async {
    final response = await _client.patch('/users/me/nutrition-preferences', body: payload);
    final body = _client.decode(response);
    return body['data'] as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> fetchCalorieSuggestion() async {
    final response = await _client.get('/nutrition/calorie-targets/suggestion');
    final body = _client.decode(response);
    return body['data'] as Map<String, dynamic>;
  }

  // --- AI meal plans (Phase 6) -------------------------------------------

  Future<Map<String, dynamic>?> fetchCurrentMealPlan() async {
    final response = await _client.get('/nutrition/meal-plans/current');
    if (response.statusCode == 404) return null;
    final body = _client.decode(response);
    return body['data'] as Map<String, dynamic>;
  }

  Future<List<Map<String, dynamic>>> fetchMealPlanHistory() async {
    final response = await _client.get('/nutrition/meal-plans/history');
    final body = _client.decode(response);
    return (body['data'] as List).cast<Map<String, dynamic>>();
  }

  // Both of these call an AI provider (or its rule-based fallback) server
  // side, which can take noticeably longer than a plain CRUD call — the
  // default ApiClient timeout is comfortably enough for everything else,
  // but too tight here.
  static const _aiTimeout = Duration(seconds: 45);

  Future<Map<String, dynamic>> generateMealPlan([Map<String, dynamic> overrides = const {}]) async {
    final response = await _client.post(
      '/nutrition/meal-plans/generate',
      body: overrides,
      timeout: _aiTimeout,
    );
    final body = _client.decode(response);
    return body['data'] as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> regenerateMealPlanDay(String planId, int dayIndex) async {
    final response = await _client.post(
      '/nutrition/meal-plans/$planId/regenerate-day',
      body: {'dayIndex': dayIndex},
      timeout: _aiTimeout,
    );
    final body = _client.decode(response);
    return body['data'] as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> replaceMealPlanMeal(
    String planId, {
    required int dayIndex,
    required String mealType,
    required String itemId,
    String? recipeId,
  }) async {
    final response = await _client.post(
      '/nutrition/meal-plans/$planId/replace-meal',
      body: {
        'dayIndex': dayIndex,
        'mealType': mealType,
        'itemId': itemId,
        if (recipeId != null) 'recipeId': recipeId,
      },
    );
    final body = _client.decode(response);
    return body['data'] as Map<String, dynamic>;
  }

  Future<void> checkShoppingListItem(String planId, {required String itemId, required bool checked}) async {
    await _client.post(
      '/nutrition/meal-plans/$planId/shopping-list/check-item',
      body: {'itemId': itemId, 'checked': checked},
    );
  }
}

@Riverpod(keepAlive: true)
NutritionRepository nutritionRepository(Ref ref) {
  return NutritionRepository(ref.watch(apiClientProvider));
}
