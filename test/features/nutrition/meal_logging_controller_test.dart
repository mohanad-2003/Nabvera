import 'package:nabvera/features/nutrition/data/nutrition_repository.dart';
import 'package:nabvera/features/nutrition/presentation/providers/meal_logging_controller.dart';
import 'package:nabvera/features/nutrition/presentation/providers/nutrition_controller.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

/// A hand-written test double — isolates the controller's logic from the
/// real HTTP repository, same pattern as the health feature's fakes.
class FakeNutritionRepository implements NutritionRepository {
  final List<Map<String, dynamic>> _loggedMeals = [];
  int fetchTodayCallCount = 0;
  Map<String, dynamic>? lastLogMealCall;
  String? lastUnlogMealCall;
  int _nextLogId = 1;

  @override
  Future<Map<String, dynamic>> fetchToday() async {
    fetchTodayCallCount++;
    return {'loggedMeals': _loggedMeals};
  }

  @override
  Future<Map<String, dynamic>> logMeal({required String recipeId, required String mealType, String? mealPlanItemId}) async {
    lastLogMealCall = {'recipeId': recipeId, 'mealType': mealType, 'mealPlanItemId': mealPlanItemId};
    final logId = 'log-${_nextLogId++}';
    _loggedMeals.add({'_id': logId, 'recipe': recipeId, 'mealType': mealType, 'mealPlanItemId': mealPlanItemId});
    return {'loggedMeals': _loggedMeals};
  }

  @override
  Future<Map<String, dynamic>> unlogMeal(String logId) async {
    lastUnlogMealCall = logId;
    _loggedMeals.removeWhere((m) => m['_id'] == logId);
    return {'loggedMeals': _loggedMeals};
  }

  @override
  Future<Map<String, dynamic>> logWater(int amountMl) async => {};

  @override
  Future<List<Map<String, dynamic>>> fetchRecipes({String? category}) async => [];
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

void main() {
  test('build(): seeds the logged-item map from today\'s real loggedMeals (mealPlanItemId entries only)', () async {
    final fake = FakeNutritionRepository();
    fake._loggedMeals.addAll([
      {'_id': 'log-1', 'mealPlanItemId': 'item-1'},
      {'_id': 'log-2', 'mealPlanItemId': null}, // a plain Meal Ideas log — not a plan slot
    ]);
    final container = ProviderContainer(overrides: [nutritionRepositoryProvider.overrideWithValue(fake)]);
    addTearDown(container.dispose);

    final map = await container.read(mealLoggingControllerProvider.future);
    expect(map, {'item-1': 'log-1'});
    await pumpEventQueue();
  });

  test('markEaten: calls the repository with the right params and records the new logId for that meal plan item', () async {
    final fake = FakeNutritionRepository();
    final container = ProviderContainer(overrides: [nutritionRepositoryProvider.overrideWithValue(fake)]);
    addTearDown(container.dispose);

    await container.read(mealLoggingControllerProvider.future); // let build() settle first
    await container.read(mealLoggingControllerProvider.notifier).markEaten(
      recipeId: 'r1',
      mealType: 'lunch',
      mealPlanItemId: 'item-1',
    );

    expect(fake.lastLogMealCall, {'recipeId': 'r1', 'mealType': 'lunch', 'mealPlanItemId': 'item-1'});
    final map = container.read(mealLoggingControllerProvider).value!;
    expect(map['item-1'], 'log-1');
    await pumpEventQueue();
  });

  test('markEaten: also refreshes the daily nutrition summary so the summary card updates without a restart', () async {
    final fake = FakeNutritionRepository();
    final container = ProviderContainer(overrides: [nutritionRepositoryProvider.overrideWithValue(fake)]);
    addTearDown(container.dispose);

    await container.read(mealLoggingControllerProvider.future);
    await container.read(dailyNutritionSummaryControllerProvider.notifier).refresh();
    final callsBefore = fake.fetchTodayCallCount;

    await container.read(mealLoggingControllerProvider.notifier).markEaten(recipeId: 'r1', mealType: 'snack');

    // DailyNutritionSummaryController.refresh() also calls fetchToday() —
    // a second call proves markEaten triggered it, not just its own load.
    expect(fake.fetchTodayCallCount, greaterThan(callsBefore));
    await pumpEventQueue();
  });

  test('markEaten: a plain Meal Ideas log (no mealPlanItemId) never adds an entry to the plan-item map', () async {
    final fake = FakeNutritionRepository();
    final container = ProviderContainer(overrides: [nutritionRepositoryProvider.overrideWithValue(fake)]);
    addTearDown(container.dispose);

    await container.read(mealLoggingControllerProvider.future);
    await container.read(mealLoggingControllerProvider.notifier).markEaten(recipeId: 'r1', mealType: 'snack');

    final map = container.read(mealLoggingControllerProvider).value!;
    expect(map, isEmpty);
    await pumpEventQueue();
  });

  test('undo: removes the item from the map and calls the repository with the right logId', () async {
    final fake = FakeNutritionRepository();
    fake._loggedMeals.add({'_id': 'log-1', 'mealPlanItemId': 'item-1'});
    final container = ProviderContainer(overrides: [nutritionRepositoryProvider.overrideWithValue(fake)]);
    addTearDown(container.dispose);

    await container.read(mealLoggingControllerProvider.future);
    await container.read(mealLoggingControllerProvider.notifier).undo('log-1', mealPlanItemId: 'item-1');

    expect(fake.lastUnlogMealCall, 'log-1');
    final map = container.read(mealLoggingControllerProvider).value!;
    expect(map.containsKey('item-1'), isFalse);
    await pumpEventQueue();
  });
}
