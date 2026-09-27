import 'package:nabvera/features/nutrition/data/nutrition_repository.dart';
import 'package:nabvera/features/search/presentation/providers/search_controller.dart';
import 'package:nabvera/features/workout/data/workout_repository.dart';
import 'package:nabvera/features/workout/domain/difficulty_rating.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

class FakeWorkoutRepository implements WorkoutRepository {
  List<Map<String, dynamic>> workouts = [];

  @override
  Future<List<Map<String, dynamic>>> fetchWorkouts({
    String? difficulty,
    String? category,
    bool? featured,
    bool? popular,
  }) async => workouts;

  @override
  Future<Map<String, dynamic>> fetchWorkoutById(String id) async =>
      throw UnimplementedError();
  @override
  Future<List<Map<String, dynamic>>> fetchExercises() async => [];
  @override
  Future<List<Map<String, dynamic>>> fetchRoutines() async => [];
  @override
  Future<Map<String, dynamic>> createRoutine(
    Map<String, dynamic> payload,
  ) async => throw UnimplementedError();
  @override
  Future<void> deleteRoutine(String id) async => throw UnimplementedError();
  @override
  Future<List<Map<String, dynamic>>> fetchWorkoutLogs() async => [];
  @override
  Future<Map<String, dynamic>> createWorkoutLog({
    required String title,
    required int durationMinutes,
    required int caloriesBurned,
    String? workoutId,
    DifficultyRating? difficultyRating,
    int? actualDurationMinutes,
    List<Map<String, dynamic>>? exerciseSets,
  }) async => throw UnimplementedError();
  @override
  Future<List<Map<String, dynamic>>> fetchExerciseHistory(
    String exerciseId,
  ) async => [];
  @override
  Future<Map<String, dynamic>> updateWorkoutLogRating({
    required String logId,
    required DifficultyRating rating,
  }) async => throw UnimplementedError();
  @override
  Future<Map<String, dynamic>> fetchRecommendedWorkout({
    bool easier = false,
    String? excludeId,
  }) async => throw UnimplementedError();
  @override
  Future<Map<String, dynamic>> fetchRecoveryMap() async =>
      throw UnimplementedError();
}

class FakeNutritionRepository implements NutritionRepository {
  List<Map<String, dynamic>> recipes = [];

  @override
  Future<List<Map<String, dynamic>>> fetchRecipes({String? category}) async =>
      recipes;

  @override
  Future<Map<String, dynamic>> fetchRecipeById(String id) async =>
      throw UnimplementedError();
  @override
  Future<Map<String, dynamic>> fetchToday() async => throw UnimplementedError();
  @override
  Future<Map<String, dynamic>> logWater(int amountMl) async =>
      throw UnimplementedError();
  @override
  Future<Map<String, dynamic>> logMeal({
    required String recipeId,
    required String mealType,
    String? mealPlanItemId,
  }) async => throw UnimplementedError();
  @override
  Future<Map<String, dynamic>> unlogMeal(String logId) async =>
      throw UnimplementedError();
  @override
  Future<Map<String, dynamic>> fetchNutritionPreferences() async =>
      throw UnimplementedError();
  @override
  Future<Map<String, dynamic>> updateNutritionPreferences(
    Map<String, dynamic> payload,
  ) async => throw UnimplementedError();
  @override
  Future<Map<String, dynamic>> fetchCalorieSuggestion() async =>
      throw UnimplementedError();
  @override
  Future<Map<String, dynamic>?> fetchCurrentMealPlan() async => null;
  @override
  Future<List<Map<String, dynamic>>> fetchMealPlanHistory() async => [];
  @override
  Future<Map<String, dynamic>> generateMealPlan([
    Map<String, dynamic> overrides = const {},
  ]) async => throw UnimplementedError();
  @override
  Future<Map<String, dynamic>> regenerateMealPlanDay(
    String planId,
    int dayIndex,
  ) async => throw UnimplementedError();
  @override
  Future<Map<String, dynamic>> replaceMealPlanMeal(
    String planId, {
    required int dayIndex,
    required String mealType,
    required String itemId,
    String? recipeId,
  }) async => throw UnimplementedError();
  @override
  Future<void> checkShoppingListItem(
    String planId, {
    required String itemId,
    required bool checked,
  }) async {}
}

void main() {
  test(
    'a fresh page (empty query) never reports hasSearched — no "no results" message before any search ran',
    () {
      final container = ProviderContainer(
        overrides: [
          workoutRepositoryProvider.overrideWithValue(FakeWorkoutRepository()),
          nutritionRepositoryProvider.overrideWithValue(
            FakeNutritionRepository(),
          ),
        ],
      );
      addTearDown(container.dispose);

      final results = container.read(searchAllResultsProvider);
      expect(results.hasSearched, isFalse);
      expect(results.isLoading, isFalse);
      expect(results.items, isEmpty);
    },
  );

  test(
    'typing a query that matches nothing sets hasSearched=true with empty items — this is what the UI uses to show "no results"',
    () async {
      final fakeWorkouts = FakeWorkoutRepository()
        ..workouts = [
          {'_id': 'w1', 'title': 'Leg Day'},
        ];
      final container = ProviderContainer(
        overrides: [
          workoutRepositoryProvider.overrideWithValue(fakeWorkouts),
          nutritionRepositoryProvider.overrideWithValue(
            FakeNutritionRepository(),
          ),
        ],
      );
      addTearDown(container.dispose);
      // autoDispose would otherwise tear the provider (and its pending
      // debounce Timer) down between the update() below and the read()
      // after it, since nothing else is watching it in this test.
      container.listen(searchAllResultsProvider, (_, _) {});

      container
          .read(searchQueryControllerProvider.notifier)
          .update('nonexistent-query-xyz');
      // Provider rebuild happens synchronously; the debounced _search fires
      // after 400ms.
      await Future.delayed(const Duration(milliseconds: 500));

      final results = container.read(searchAllResultsProvider);
      expect(results.hasSearched, isTrue);
      expect(results.isLoading, isFalse);
      expect(results.items, isEmpty);
    },
  );

  test(
    'a query matching only the Arabic titleAr (not the English title) still returns the item',
    () async {
      final fakeWorkouts = FakeWorkoutRepository()
        ..workouts = [
          {'_id': 'w1', 'title': 'Cardio Blast', 'titleAr': 'كارديو مكثف'},
        ];
      final container = ProviderContainer(
        overrides: [
          workoutRepositoryProvider.overrideWithValue(fakeWorkouts),
          nutritionRepositoryProvider.overrideWithValue(
            FakeNutritionRepository(),
          ),
        ],
      );
      addTearDown(container.dispose);
      container.listen(searchAllResultsProvider, (_, _) {});

      container.read(searchQueryControllerProvider.notifier).update('كارديو');
      await Future.delayed(const Duration(milliseconds: 500));

      final results = container.read(searchAllResultsProvider);
      expect(results.items, hasLength(1));
      expect(results.items.first.id, 'w1');
    },
  );

  test(
    'a query matching a workout\'s category (not its title) still returns the item — the "Breakfast" suggestion chip needs this since real recipe titles rarely contain the word itself',
    () async {
      final fakeRecipes = FakeNutritionRepository()
        ..recipes = [
          {'_id': 'r1', 'title': 'Spinach & Tomato Omelette', 'category': 'breakfast'},
        ];
      final container = ProviderContainer(
        overrides: [
          workoutRepositoryProvider.overrideWithValue(FakeWorkoutRepository()),
          nutritionRepositoryProvider.overrideWithValue(fakeRecipes),
        ],
      );
      addTearDown(container.dispose);
      container.listen(searchAllResultsProvider, (_, _) {});

      container.read(searchQueryControllerProvider.notifier).update('breakfast');
      await Future.delayed(const Duration(milliseconds: 500));

      final results = container.read(searchAllResultsProvider);
      expect(results.items, hasLength(1));
      expect(results.items.first.id, 'r1');
    },
  );

  test(
    'a matching query returns results carrying the real backend id (so a tap can open the real item)',
    () async {
      final fakeWorkouts = FakeWorkoutRepository()
        ..workouts = [
          {'_id': 'w1', 'title': 'Leg Day', 'durationMinutes': 30, 'estimatedCalories': 200},
        ];
      final container = ProviderContainer(
        overrides: [
          workoutRepositoryProvider.overrideWithValue(fakeWorkouts),
          nutritionRepositoryProvider.overrideWithValue(
            FakeNutritionRepository(),
          ),
        ],
      );
      addTearDown(container.dispose);
      container.listen(searchAllResultsProvider, (_, _) {});

      container.read(searchQueryControllerProvider.notifier).update('leg');
      await Future.delayed(const Duration(milliseconds: 500));

      final results = container.read(searchAllResultsProvider);
      expect(results.hasSearched, isTrue);
      expect(results.items, hasLength(1));
      expect(results.items.first.id, 'w1');
      expect(results.items.first.name, 'Leg Day');
    },
  );
}
