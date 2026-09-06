import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/analytics/analytics_service.dart';
import '../../data/nutrition_repository.dart';
import '../../domain/meal_plan_models.dart';

part 'meal_plan_controller.g.dart';

/// The current user's active weekly meal plan — `null` means no plan has
/// been generated yet (the empty state). An [AsyncNotifier] so
/// generating/regenerating/replacing all show a real, honest loading state
/// rather than a fixed-duration fake progress animation (see the Phase 6
/// brief's explicit requirement on the generating screen).
@riverpod
class MealPlanController extends _$MealPlanController {
  @override
  Future<MealPlan?> build() async {
    final json =
        await ref.read(nutritionRepositoryProvider).fetchCurrentMealPlan();
    return json == null ? null : MealPlan.fromJson(json);
  }

  /// [overrides] are one-off generation inputs (goal/targets/cooking
  /// time/servings/budget) — not persisted to nutritionPreferences, see
  /// the backend's `POST /nutrition/meal-plans/generate` doc comment.
  Future<void> generate([Map<String, dynamic> overrides = const {}]) async {
    final analytics = ref.read(analyticsServiceProvider);
    analytics.logEvent(AnalyticsEvent.mealPlanGenerationRequested);

    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      try {
        final json = await ref
            .read(nutritionRepositoryProvider)
            .generateMealPlan(overrides);
        final plan = MealPlan.fromJson(json);
        analytics.logEvent(AnalyticsEvent.mealPlanGenerated, {
          'source': plan.generationSource,
        });
        return plan;
      } catch (error) {
        analytics.logEvent(AnalyticsEvent.mealPlanGenerationFailed);
        rethrow;
      }
    });
  }

  Future<void> regenerateDay(int dayIndex) async {
    final plan = state.value;
    if (plan == null) return;
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final json = await ref
          .read(nutritionRepositoryProvider)
          .regenerateMealPlanDay(plan.id, dayIndex);
      return MealPlan.fromJson(json);
    });
  }

  Future<void> replaceMeal({
    required int dayIndex,
    required String mealType,
    required String itemId,
    String? recipeId,
  }) async {
    final plan = state.value;
    if (plan == null) return;
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final json = await ref
          .read(nutritionRepositoryProvider)
          .replaceMealPlanMeal(
            plan.id,
            dayIndex: dayIndex,
            mealType: mealType,
            itemId: itemId,
            recipeId: recipeId,
          );
      ref.read(analyticsServiceProvider).logEvent(AnalyticsEvent.mealReplaced, {
        'dayIndex': dayIndex,
        'mealType': mealType,
      });
      return MealPlan.fromJson(json);
    });
  }

  /// Optimistic — the checkbox flips immediately; a failure quietly
  /// reverts on the next full reload rather than blocking the tap with an
  /// error dialog for something this low-stakes.
  Future<void> toggleShoppingListItem(String itemId, bool checked) async {
    final plan = state.value;
    if (plan == null) return;

    final updatedList = [
      for (final item in plan.shoppingList)
        item.id == itemId ? item.copyWith(checked: checked) : item,
    ];
    state = AsyncData(plan.copyWith(shoppingList: updatedList));

    try {
      await ref
          .read(nutritionRepositoryProvider)
          .checkShoppingListItem(plan.id, itemId: itemId, checked: checked);
      ref.read(analyticsServiceProvider).logEvent(
        AnalyticsEvent.shoppingListItemChecked,
        {'checked': checked},
      );
    } catch (_) {
      ref.invalidateSelf();
    }
  }
}

/// The user's past (inactive) meal plans, most recent first.
@riverpod
Future<List<MealPlan>> mealPlanHistory(Ref ref) async {
  final list =
      await ref.read(nutritionRepositoryProvider).fetchMealPlanHistory();
  return list.map(MealPlan.fromJson).toList();
}
