import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nabvera/features/nutrition/data/nutrition_repository.dart';
import 'package:nabvera/features/nutrition/presentation/providers/nutrition_controller.dart';

import 'nutrition_test_fakes.dart';

void main() {
  group('recipes load status', () {
    test('starts as loading, becomes loaded once the list arrives', () async {
      final fake = FakeNutritionRepository()..recipes = [recipeJson('a')];
      final container = ProviderContainer(
        overrides: [nutritionRepositoryProvider.overrideWithValue(fake)],
      );
      addTearDown(container.dispose);
      container.listen(nutritionRecipesStatusProvider, (_, _) {});

      expect(
        container.read(nutritionRecipesStatusProvider),
        NutritionLoadStatus.loading,
      );

      container.read(nutritionRecipesSourceProvider);
      await pumpEventQueue();

      expect(
        container.read(nutritionRecipesStatusProvider),
        NutritionLoadStatus.loaded,
      );
    });

    test(
      'a failed first load is "failed" (not an empty "loaded" list) and can be retried',
      () async {
        final fake =
            FakeNutritionRepository()
              ..recipes = [recipeJson('a')]
              ..throwOnNextFetch = true;
        final container = ProviderContainer(
          overrides: [nutritionRepositoryProvider.overrideWithValue(fake)],
        );
        addTearDown(container.dispose);
        container.listen(nutritionRecipesStatusProvider, (_, _) {});
        container.listen(nutritionRecipesSourceProvider, (_, _) {});

        await pumpEventQueue();
        expect(
          container.read(nutritionRecipesStatusProvider),
          NutritionLoadStatus.failed,
        );
        expect(container.read(nutritionRecipesSourceProvider), isEmpty);

        await container.read(nutritionRecipesSourceProvider.notifier).refresh();
        expect(
          container.read(nutritionRecipesStatusProvider),
          NutritionLoadStatus.loaded,
        );
        expect(container.read(nutritionRecipesSourceProvider), hasLength(1));
      },
    );

    test(
      'a failed refresh keeps the last good recipes and does not go back to loading',
      () async {
        final fake =
            FakeNutritionRepository()
              ..recipes = [recipeJson('a'), recipeJson('b')];
        final container = ProviderContainer(
          overrides: [nutritionRepositoryProvider.overrideWithValue(fake)],
        );
        addTearDown(container.dispose);
        container.listen(nutritionRecipesStatusProvider, (_, _) {});
        container.listen(nutritionRecipesSourceProvider, (_, _) {});
        await pumpEventQueue();

        fake.throwOnNextFetch = true;
        await expectLater(
          container.read(nutritionRecipesSourceProvider.notifier).refresh(),
          throwsA(isA<Exception>()),
        );

        expect(container.read(nutritionRecipesSourceProvider), hasLength(2));
        expect(
          container.read(nutritionRecipesStatusProvider),
          NutritionLoadStatus.failed,
        );
      },
    );

    test(
      'a genuinely empty list is "loaded" with no recipes — distinct from failed',
      () async {
        final fake = FakeNutritionRepository();
        final container = ProviderContainer(
          overrides: [nutritionRepositoryProvider.overrideWithValue(fake)],
        );
        addTearDown(container.dispose);
        container.listen(nutritionRecipesStatusProvider, (_, _) {});
        container.listen(nutritionRecipesSourceProvider, (_, _) {});
        await pumpEventQueue();

        expect(
          container.read(nutritionRecipesStatusProvider),
          NutritionLoadStatus.loaded,
        );
        expect(container.read(nutritionRecipesSourceProvider), isEmpty);
      },
    );

    test('overlapping refreshes share one request', () async {
      final gate = Completer<void>();
      final fake =
          FakeNutritionRepository()
            ..recipes = [recipeJson('a')]
            ..fetchGate = gate.future;
      final container = ProviderContainer(
        overrides: [nutritionRepositoryProvider.overrideWithValue(fake)],
      );
      addTearDown(container.dispose);
      container.listen(nutritionRecipesSourceProvider, (_, _) {});

      final notifier = container.read(nutritionRecipesSourceProvider.notifier);
      final first = notifier.refresh();
      final second = notifier.refresh();
      await pumpEventQueue();
      expect(fake.fetchRecipesCallCount, 1);

      gate.complete();
      await Future.wait([first, second]);
      expect(fake.fetchRecipesCallCount, 1);

      // Once finished, a new refresh is a new request.
      fake.fetchGate = null;
      await notifier.refresh();
      expect(fake.fetchRecipesCallCount, 2);
    });
  });

  group('today summary load state', () {
    test('a first-load failure is flagged, not shown as zeros', () async {
      final fake = FakeNutritionRepository()..todayError = true;
      final container = ProviderContainer(
        overrides: [nutritionRepositoryProvider.overrideWithValue(fake)],
      );
      addTearDown(container.dispose);
      container.listen(dailyNutritionSummaryControllerProvider, (_, _) {});

      expect(
        container.read(dailyNutritionSummaryControllerProvider).isLoading,
        isTrue,
      );
      await pumpEventQueue();

      final summary = container.read(dailyNutritionSummaryControllerProvider);
      expect(summary.isLoading, isFalse);
      expect(summary.loadFailed, isTrue);
      expect(summary.hasPersonalGoal, isFalse);
    });

    test(
      'retrying after a failure loads the real data and clears the flag',
      () async {
        final fake = FakeNutritionRepository()..todayError = true;
        final container = ProviderContainer(
          overrides: [nutritionRepositoryProvider.overrideWithValue(fake)],
        );
        addTearDown(container.dispose);
        container.listen(dailyNutritionSummaryControllerProvider, (_, _) {});
        await pumpEventQueue();

        fake
          ..todayError = false
          ..today = {
            'calorieGoal': 2000,
            'caloriesConsumed': 500,
            'goalSource': 'preferences',
          };
        await container
            .read(dailyNutritionSummaryControllerProvider.notifier)
            .refresh();

        final summary = container.read(dailyNutritionSummaryControllerProvider);
        expect(summary.loadFailed, isFalse);
        expect(summary.consumedCalories, 500);
        expect(summary.goalCalories, 2000);
      },
    );

    test(
      'a failed refresh over real data keeps that data and does not flag a failure',
      () async {
        final fake =
            FakeNutritionRepository()
              ..today = {'calorieGoal': 1800, 'caloriesConsumed': 900};
        final container = ProviderContainer(
          overrides: [nutritionRepositoryProvider.overrideWithValue(fake)],
        );
        addTearDown(container.dispose);
        container.listen(dailyNutritionSummaryControllerProvider, (_, _) {});
        await pumpEventQueue();

        fake.todayError = true;
        await container
            .read(dailyNutritionSummaryControllerProvider.notifier)
            .refresh();

        final summary = container.read(dailyNutritionSummaryControllerProvider);
        expect(summary.loadFailed, isFalse);
        expect(summary.consumedCalories, 900);
        expect(summary.goalCalories, 1800);
      },
    );

    test(
      'logging water updates the summary from the saved document, with one save request',
      () async {
        final fake =
            FakeNutritionRepository()
              ..today = {
                'calorieGoal': 2000,
                'waterConsumedMl': 500,
                'waterGoalMl': 2000,
              }
              ..waterAfterLog = {
                'calorieGoal': 2000,
                'waterConsumedMl': 750,
                'waterGoalMl': 2000,
              };
        final container = ProviderContainer(
          overrides: [nutritionRepositoryProvider.overrideWithValue(fake)],
        );
        addTearDown(container.dispose);
        container.listen(dailyNutritionSummaryControllerProvider, (_, _) {});
        await pumpEventQueue();

        await container
            .read(dailyNutritionSummaryControllerProvider.notifier)
            .logWater(250);

        expect(fake.logWaterCalls, [250]);
        final summary = container.read(dailyNutritionSummaryControllerProvider);
        expect(summary.waterConsumedMl, 750);
      },
    );
  });
}
