import 'package:nabvera/core/localization/generated/app_localizations.dart';
import 'package:nabvera/core/theme/app_theme_extension.dart';
import 'package:nabvera/core/widgets/premium_scaffold.dart';
import 'package:nabvera/features/nutrition/presentation/providers/meal_plan_controller.dart';
import 'package:nabvera/features/workout/presentation/widgets/workout_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

/// The user's past (inactive) meal plans — read-only, matches
/// `GET /nutrition/meal-plans/history`.
class MealPlanHistoryPage extends ConsumerWidget {
  const MealPlanHistoryPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final ext = Theme.of(context).extension<AppThemeExtension>()!;
    final asyncHistory = ref.watch(mealPlanHistoryProvider);

    return PremiumScaffold(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          WorkoutHeader(title: l10n.mealPlanViewHistory),
          const SizedBox(height: 12),
          Expanded(
            child: asyncHistory.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, _) => Center(child: Text('$error', style: TextStyle(color: ext.textMuted))),
              data: (plans) {
                if (plans.isEmpty) {
                  return Center(child: Text(l10n.mealPlanHistoryEmpty, style: TextStyle(color: ext.textMuted)));
                }
                return ListView.separated(
                  itemCount: plans.length,
                  separatorBuilder: (_, _) => Divider(height: 1, color: ext.glassBorder),
                  itemBuilder: (context, index) {
                    final plan = plans[index];
                    return ListTile(
                      title: Text(
                        DateFormat.yMMMd().format(plan.weekStartDate),
                        style: TextStyle(color: ext.textPrimary),
                      ),
                      subtitle: Text(
                        '${plan.calorieTarget} kcal · ${plan.proteinTargetGrams}g',
                        style: TextStyle(color: ext.textMuted),
                      ),
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
