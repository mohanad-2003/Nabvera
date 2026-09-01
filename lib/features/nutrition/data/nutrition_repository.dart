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

  Future<Map<String, dynamic>> createMealPlan(Map<String, dynamic> payload) async {
    final response = await _client.post('/meal-plans', body: payload);
    final body = _client.decode(response);
    return body['data'] as Map<String, dynamic>;
  }
}

@Riverpod(keepAlive: true)
NutritionRepository nutritionRepository(Ref ref) {
  return NutritionRepository(ref.watch(apiClientProvider));
}
