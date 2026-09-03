import 'package:fitness_app/core/localization/generated/app_localizations.dart';
import 'package:fitness_app/core/routing/app_routes.dart';
import 'package:fitness_app/core/theme/app_theme_extension.dart';
import 'package:fitness_app/core/widgets/premium_scaffold.dart';
import 'package:fitness_app/core/widgets/primary_button.dart';
import 'package:fitness_app/features/nutrition/presentation/providers/meal_plan_wizard_controller.dart';
import 'package:fitness_app/features/nutrition/presentation/widgets/option_selector.dart';
import 'package:fitness_app/features/onboarding/presentation/widgets/wizard_scaffold.dart';
import 'package:fitness_app/features/workout/presentation/widgets/workout_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class MealPlanGoalsPage extends ConsumerWidget {
  const MealPlanGoalsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final prefs = ref.watch(mealPlanWizardControllerProvider);
    final controller = ref.read(mealPlanWizardControllerProvider.notifier);
    final theme = Theme.of(context);
    final ext = theme.extension<AppThemeExtension>()!;
    final l10n = AppLocalizations.of(context);

    return PremiumScaffold(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            WorkoutHeader(title: l10n.nutritionTabMealPlans),
            const SizedBox(height: 18),
            WizardStepIndicator(step: 2, totalSteps: 4),
            const SizedBox(height: 30),
            _SectionTitle(l10n.mealPlanCaloricGoal),
            const SizedBox(height: 12),
            Text(
              l10n.mealPlanCaloricGoalQuestion,
              style: TextStyle(color: ext.textPrimary),
            ),
            const SizedBox(height: 16),
            OptionSelector(
              options: MealPlanWizardController.caloricGoalOptions,
              selected: prefs.caloricGoal,
              onSelected: controller.selectCaloricGoal,
              itemWidthFraction: 1,
            ),
            const SizedBox(height: 32),
            _SectionTitle(l10n.mealPlanCookingTime),
            const SizedBox(height: 12),
            Text(
              l10n.mealPlanCookingTimeQuestion,
              style: TextStyle(color: ext.textPrimary),
            ),
            const SizedBox(height: 16),
            OptionSelector(
              options: MealPlanWizardController.cookingTimeOptions,
              selected: prefs.cookingTime,
              onSelected: controller.selectCookingTime,
            ),
            const SizedBox(height: 32),
            _SectionTitle(l10n.mealPlanServings),
            const SizedBox(height: 12),
            Text(
              l10n.mealPlanServingsQuestion,
              style: TextStyle(color: ext.textPrimary),
            ),
            const SizedBox(height: 16),
            OptionSelector(
              options: MealPlanWizardController.servingOptions,
              selected: prefs.servings,
              onSelected: controller.selectServings,
            ),
            const SizedBox(height: 32),
            PrimaryButton(
              label: l10n.mealPlanCreate,
              icon: Icons.auto_awesome_rounded,
              onPressed: () => context.push(AppRoutes.mealPlanGenerating),
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle(this.text);
  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: Theme.of(context).textTheme.titleLarge?.copyWith(
        color: Theme.of(context).colorScheme.primary,
        fontWeight: FontWeight.w900,
      ),
    );
  }
}
