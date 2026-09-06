import 'package:nabvera/core/localization/generated/app_localizations.dart';
import 'package:nabvera/core/theme/app_theme_extension.dart';
import 'package:nabvera/core/widgets/premium_scaffold.dart';
import 'package:nabvera/features/nutrition/presentation/providers/meal_plan_controller.dart';
import 'package:nabvera/features/workout/presentation/widgets/workout_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Aggregated shopping list for the current meal plan, with per-item
/// checkboxes (see `POST /nutrition/meal-plans/:id/shopping-list/check-item`).
class MealPlanShoppingListPage extends ConsumerWidget {
  const MealPlanShoppingListPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final ext = Theme.of(context).extension<AppThemeExtension>()!;
    final asyncPlan = ref.watch(mealPlanControllerProvider);

    return PremiumScaffold(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          WorkoutHeader(title: l10n.mealPlanShoppingListTitle),
          const SizedBox(height: 12),
          Expanded(
            child: asyncPlan.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, _) => Center(child: Text('$error', style: TextStyle(color: ext.textMuted))),
              data: (plan) {
                if (plan == null || plan.shoppingList.isEmpty) {
                  return Center(
                    child: Text(l10n.mealPlanShoppingListEmpty, style: TextStyle(color: ext.textMuted)),
                  );
                }
                return ListView.separated(
                  itemCount: plan.shoppingList.length,
                  separatorBuilder: (_, _) => Divider(height: 1, color: ext.glassBorder),
                  itemBuilder: (context, index) {
                    final item = plan.shoppingList[index];
                    return CheckboxListTile(
                      value: item.checked,
                      onChanged: (checked) => ref
                          .read(mealPlanControllerProvider.notifier)
                          .toggleShoppingListItem(item.id, checked ?? false),
                      title: Text(
                        item.ingredientName,
                        style: TextStyle(
                          color: ext.textPrimary,
                          decoration: item.checked ? TextDecoration.lineThrough : null,
                        ),
                      ),
                      subtitle: item.amount.isEmpty ? null : Text(item.amount, style: TextStyle(color: ext.textMuted)),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
