import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../data/nutrition_repository.dart';
import '../../domain/nutrition_models.dart';

part 'nutrition_controller.g.dart';

enum NutritionTab { mealPlans, mealIdeas }

@riverpod
class NutritionTabController extends _$NutritionTabController {
  @override
  NutritionTab build() => NutritionTab.mealPlans;

  void select(NutritionTab tab) => state = tab;
}

/// Loads `/api/recipes` once and splits it: the two highest-rated recipes
/// become "Recommended", the rest fill "Recipes for you".
@riverpod
class NutritionRecommended extends _$NutritionRecommended {
  @override
  List<MealItem> build() {
    ref.watch(_recipesProvider);
    return ref
        .watch(_recipesProvider)
        .maybeWhen(
          data: (recipes) => recipes.take(2).map(MealItem.fromJson).toList(),
          orElse: () => const [],
        );
  }
}

@riverpod
class NutritionRecipes extends _$NutritionRecipes {
  @override
  List<MealItem> build() {
    return ref
        .watch(_recipesProvider)
        .maybeWhen(
          data: (recipes) => recipes.skip(2).map(MealItem.fromJson).toList(),
          orElse: () => const [],
        );
  }
}

@riverpod
Future<List<Map<String, dynamic>>> _recipes(Ref ref) {
  final recipes = ref.watch(nutritionRepositoryProvider).fetchRecipes();
  return recipes.then(
    (list) =>
        list..sort(
          (a, b) => ((b['rating'] as num?) ?? 0).compareTo(
            (a['rating'] as num?) ?? 0,
          ),
        ),
  );
}

/// Loads the real `/api/nutrition/today` document and converts it into
/// display fractions/strings.
@riverpod
class DailyNutritionSummaryController
    extends _$DailyNutritionSummaryController {
  @override
  DailyNutritionSummary build() {
    Future.microtask(_load);
    return const DailyNutritionSummary(
      consumedCalories: 0,
      goalCalories: 2000,
      proteinFraction: 0,
      carbsFraction: 0,
      fatFraction: 0,
      waterIntake: '0 / 8 cups',
    );
  }

  Future<void> _load() async {
    try {
      final entry = await ref.read(nutritionRepositoryProvider).fetchToday();
      final calorieGoal = (entry['calorieGoal'] as num?) ?? 2000;
      final proteinGoal = (entry['proteinGoalG'] as num?) ?? 1;
      final carbsGoal = (entry['carbsGoalG'] as num?) ?? 1;
      final fatGoal = (entry['fatGoalG'] as num?) ?? 1;
      final waterGoalMl = (entry['waterGoalMl'] as num?) ?? 2000;
      final waterConsumedMl = (entry['waterConsumedMl'] as num?) ?? 0;
      // ~250ml per "cup", matching the UI's original "X / 8 cups" copy.
      const mlPerCup = 250;

      state = DailyNutritionSummary(
        consumedCalories: ((entry['caloriesConsumed'] as num?) ?? 0).round(),
        goalCalories: calorieGoal.round(),
        proteinFraction:
            (((entry['proteinConsumedG'] as num?) ?? 0) / proteinGoal)
                .clamp(0, 1)
                .toDouble(),
        carbsFraction:
            (((entry['carbsConsumedG'] as num?) ?? 0) / carbsGoal)
                .clamp(0, 1)
                .toDouble(),
        fatFraction:
            (((entry['fatConsumedG'] as num?) ?? 0) / fatGoal)
                .clamp(0, 1)
                .toDouble(),
        waterIntake:
            '${(waterConsumedMl / mlPerCup).round()} / ${(waterGoalMl / mlPerCup).round()} cups',
      );
    } catch (_) {
      // Left at the default placeholder — see WorkoutListByLevel for the
      // same pattern.
    }
  }

  /// Used by Home's `refreshHomeProviders` — the "next step" card reads
  /// today's water/calorie progress from this controller too.
  Future<void> refresh() => _load();
}
