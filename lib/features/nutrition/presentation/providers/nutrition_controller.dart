import 'package:nabvera/features/nutrition/data/nutrition_repository.dart';
import 'package:nabvera/features/nutrition/domain/nutrition_models.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

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
      state = DailyNutritionSummary.fromEntry(entry);
    } catch (_) {
      // Left at the default placeholder — see WorkoutListByLevel for the
      // same pattern.
    }
  }

  /// Used by Home's `refreshHomeProviders` — the "next step" card reads
  /// today's water/calorie progress from this controller too.
  Future<void> refresh() => _load();

  /// Logs an actual amount of water via `POST /nutrition/water` and
  /// updates every screen watching this controller immediately (Home's
  /// next-step card, the Nutrition summary card) — no restart, no
  /// separate refetch. Errors propagate to the caller so the water-log
  /// sheet can show a real failure message instead of silently doing
  /// nothing.
  Future<void> logWater(int amountMl) async {
    final entry = await ref.read(nutritionRepositoryProvider).logWater(amountMl);
    state = DailyNutritionSummary.fromEntry(entry);
  }
}
