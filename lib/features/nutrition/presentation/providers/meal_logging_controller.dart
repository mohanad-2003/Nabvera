import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../data/nutrition_repository.dart';
import 'nutrition_controller.dart';

part 'meal_logging_controller.g.dart';

/// Tracks which meal-plan items have already been "marked as eaten"
/// today, keyed by `mealPlanItemId` -> the resulting log's id (needed for
/// undo). Seeded from today's real `/api/nutrition/today` document on
/// first load — not just this session's taps — so a card correctly shows
/// "Logged" again after leaving and returning to the screen, or after a
/// hot restart.
@riverpod
class MealLoggingController extends _$MealLoggingController {
  @override
  Future<Map<String, String>> build() async {
    final entry = await ref.read(nutritionRepositoryProvider).fetchToday();
    final loggedMeals = (entry['loggedMeals'] as List? ?? const []).cast<Map<String, dynamic>>();
    return {
      for (final meal in loggedMeals)
        if (meal['mealPlanItemId'] != null) meal['mealPlanItemId'] as String: meal['_id'] as String,
    };
  }

  /// Logs [recipeId] as eaten for [mealType]. Pass [mealPlanItemId] when
  /// this came from a specific meal-plan slot, so it shows as "Logged" on
  /// that exact card and can't be double-logged. Also refreshes
  /// [dailyNutritionSummaryControllerProvider] so the summary card updates
  /// immediately — no restart, no separate refetch.
  Future<void> markEaten({required String recipeId, required String mealType, String? mealPlanItemId}) async {
    final entry = await ref.read(nutritionRepositoryProvider).logMeal(
      recipeId: recipeId,
      mealType: mealType,
      mealPlanItemId: mealPlanItemId,
    );

    if (mealPlanItemId != null) {
      final loggedMeals = (entry['loggedMeals'] as List? ?? const []).cast<Map<String, dynamic>>();
      final justLogged = loggedMeals.lastWhere(
        (m) => m['mealPlanItemId'] == mealPlanItemId,
        orElse: () => const {},
      );
      final logId = justLogged['_id'] as String?;
      if (logId != null) {
        state = AsyncData(<String, String>{...?state.value, mealPlanItemId: logId});
      }
    }

    ref.read(dailyNutritionSummaryControllerProvider.notifier).refresh();
  }

  /// Undoes a "mark as eaten" — [mealPlanItemId] is optional and only
  /// needed to also clear this controller's own logged-state map (a plain
  /// Meal Ideas log, with no plan item, has nothing to clear here).
  Future<void> undo(String logId, {String? mealPlanItemId}) async {
    await ref.read(nutritionRepositoryProvider).unlogMeal(logId);

    if (mealPlanItemId != null) {
      final current = <String, String>{...?state.value};
      current.remove(mealPlanItemId);
      state = AsyncData(current);
    }

    ref.read(dailyNutritionSummaryControllerProvider.notifier).refresh();
  }
}
