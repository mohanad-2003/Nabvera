import 'dart:typed_data';

import 'package:nabvera/features/favorite/presentation/providers/favorite_controller.dart';
import 'package:nabvera/features/nutrition/data/nutrition_repository.dart';
import 'package:nabvera/features/profile/data/user_repository.dart';
import 'package:nabvera/features/profile/domain/profile_models.dart';
import 'package:nabvera/features/profile/presentation/providers/profile_controller.dart';
import 'package:nabvera/features/workout/data/workout_repository.dart';
import 'package:nabvera/features/workout/domain/difficulty_rating.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

class FakeWorkoutRepository implements WorkoutRepository {
  Map<String, Map<String, dynamic>> workoutsById = {};

  @override
  Future<Map<String, dynamic>> fetchWorkoutById(String id) async {
    final doc = workoutsById[id];
    if (doc == null) throw Exception('not found');
    return doc;
  }

  @override
  Future<List<Map<String, dynamic>>> fetchWorkouts({
    String? difficulty,
    String? category,
    bool? featured,
    bool? popular,
  }) async => [];
  @override
  Future<List<Map<String, dynamic>>> fetchExercises() async => [];
  @override
  Future<List<Map<String, dynamic>>> fetchRoutines() async => [];
  @override
  Future<Map<String, dynamic>> createRoutine(
    Map<String, dynamic> payload,
  ) async => throw UnimplementedError();
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
  @override
  Future<void> deleteRoutine(String id) async {}
}

class FakeNutritionRepository implements NutritionRepository {
  Map<String, Map<String, dynamic>> recipesById = {};

  @override
  Future<Map<String, dynamic>> fetchRecipeById(String id) async {
    final doc = recipesById[id];
    if (doc == null) throw Exception('not found');
    return doc;
  }

  @override
  Future<List<Map<String, dynamic>>> fetchRecipes({String? category}) async =>
      [];
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

class FakeUserRepository implements UserRepository {
  UserProfile profile = UserProfile.empty;
  int toggleWorkoutCallCount = 0;

  @override
  Future<UserProfile> fetchMe() async => profile;

  @override
  Future<List<String>> toggleFavoriteWorkout(String workoutId) async {
    toggleWorkoutCallCount++;
    return [];
  }

  @override
  Future<UserProfile> updateProfile(Map<String, dynamic> patch) async =>
      profile;
  @override
  Future<String> uploadAvatar({
    required Uint8List bytes,
    required String filename,
    String? contentType,
  }) async => throw UnimplementedError();
  @override
  Future<UserProfile> setBiometricEnabled(bool enabled) async =>
      throw UnimplementedError();
  @override
  Future<List<String>> toggleFavoriteRecipe(String recipeId) async => [];
  @override
  Future<void> setActiveWorkoutSession({
    required String workoutId,
    required String title,
    required String titleAr,
    required String image,
    required int completedSets,
    required int totalSets,
  }) async {}
  @override
  Future<void> clearActiveWorkoutSession() async {}
  @override
  Future<void> registerFcmToken(String token) async {}
  @override
  Future<void> unregisterFcmToken(String token) async {}
  @override
  Future<void> deleteAccount() async => throw UnimplementedError();
  @override
  Future<Map<String, dynamic>> exportData() async => throw UnimplementedError();
}

UserProfile _profileWithFavorites({
  List<String> workoutIds = const [],
  List<String> recipeIds = const [],
}) {
  return UserProfile(
    id: 'user-1',
    name: '',
    email: 'user@example.com',
    birthday: '—',
    weightKg: '—',
    ageYears: '—',
    heightM: '—',
    fitnessLevel: 'Beginner',
    completedWorkouts: 0,
    caloriesBurned: 0,
    trainingDays: 0,
    currentStreak: 0,
    favoriteWorkoutIds: workoutIds,
    favoriteRecipeIds: recipeIds,
  );
}

void main() {
  test(
    "loads the user's real favorite workouts/recipes by id — not mock/static data",
    () async {
      final fakeWorkouts =
          FakeWorkoutRepository()
            ..workoutsById['w1'] = {'_id': 'w1', 'title': 'Leg Day'};
      final fakeRecipes =
          FakeNutritionRepository()
            ..recipesById['r1'] = {'_id': 'r1', 'title': 'Oats Bowl'};
      final fakeUsers =
          FakeUserRepository()
            ..profile = _profileWithFavorites(
              workoutIds: ['w1'],
              recipeIds: ['r1'],
            );
      final container = ProviderContainer(
        overrides: [
          workoutRepositoryProvider.overrideWithValue(fakeWorkouts),
          nutritionRepositoryProvider.overrideWithValue(fakeRecipes),
          userRepositoryProvider.overrideWithValue(fakeUsers),
        ],
      );
      addTearDown(container.dispose);
      container.listen(filteredFavoritesProvider, (_, _) {});

      await container.read(currentUserProfileProvider.notifier).refresh();
      await pumpEventQueue();

      final items = container.read(filteredFavoritesProvider);
      expect(items, hasLength(2));
      expect(items.map((i) => i.title), containsAll(['Leg Day', 'Oats Bowl']));
    },
  );

  test(
    'a favorite that no longer resolves (deleted item) is silently skipped, not shown as broken/fake data',
    () async {
      final fakeWorkouts =
          FakeWorkoutRepository(); // 'gone' resolves to nothing
      final fakeUsers =
          FakeUserRepository()
            ..profile = _profileWithFavorites(workoutIds: ['gone']);
      final container = ProviderContainer(
        overrides: [
          workoutRepositoryProvider.overrideWithValue(fakeWorkouts),
          nutritionRepositoryProvider.overrideWithValue(
            FakeNutritionRepository(),
          ),
          userRepositoryProvider.overrideWithValue(fakeUsers),
        ],
      );
      addTearDown(container.dispose);
      container.listen(filteredFavoritesProvider, (_, _) {});

      await container.read(currentUserProfileProvider.notifier).refresh();
      await pumpEventQueue();

      expect(container.read(filteredFavoritesProvider), isEmpty);
    },
  );

  test(
    'remove() calls the real toggle-favorite API, not just local state',
    () async {
      final fakeWorkouts =
          FakeWorkoutRepository()
            ..workoutsById['w1'] = {'_id': 'w1', 'title': 'Leg Day'};
      final fakeUsers =
          FakeUserRepository()
            ..profile = _profileWithFavorites(workoutIds: ['w1']);
      final container = ProviderContainer(
        overrides: [
          workoutRepositoryProvider.overrideWithValue(fakeWorkouts),
          nutritionRepositoryProvider.overrideWithValue(
            FakeNutritionRepository(),
          ),
          userRepositoryProvider.overrideWithValue(fakeUsers),
        ],
      );
      addTearDown(container.dispose);
      container.listen(filteredFavoritesProvider, (_, _) {});
      await container.read(currentUserProfileProvider.notifier).refresh();
      await pumpEventQueue();

      final item = container.read(filteredFavoritesProvider).first;
      await container.read(filteredFavoritesProvider.notifier).remove(item);

      expect(fakeUsers.toggleWorkoutCallCount, 1);
      expect(container.read(filteredFavoritesProvider), isEmpty);
    },
  );
}
