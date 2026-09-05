import 'package:nabvera/core/localization/generated/app_localizations.dart';
import 'package:nabvera/core/routing/app_routes.dart';
import 'package:nabvera/core/theme/app_theme_extension.dart';
import 'package:nabvera/core/widgets/premium_scaffold.dart';
import 'package:nabvera/features/nutrition/presentation/providers/meal_plan_wizard_controller.dart';
import 'package:nabvera/features/onboarding/presentation/widgets/wizard_scaffold.dart';
import 'package:nabvera/features/workout/presentation/widgets/workout_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class MealPlanGeneratingPage extends ConsumerStatefulWidget {
  const MealPlanGeneratingPage({super.key});

  @override
  ConsumerState<MealPlanGeneratingPage> createState() =>
      _MealPlanGeneratingPageState();
}

class _MealPlanGeneratingPageState
    extends ConsumerState<MealPlanGeneratingPage> {
  @override
  void initState() {
    super.initState();
    // Submits the plan while the animation plays, so the two-second wait
    // the wizard already shows the user is put to real use instead of
    // being a pure fake delay.
    Future.wait([
      ref.read(mealPlanWizardControllerProvider.notifier).submit(),
      Future.delayed(const Duration(seconds: 2)),
    ]).then((_) {
      if (mounted) context.go(AppRoutes.mealPlanBreakfast);
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final ext = theme.extension<AppThemeExtension>()!;
    final l10n = AppLocalizations.of(context);

    return PremiumScaffold(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          WorkoutHeader(title: l10n.nutritionTabMealPlans),
          const SizedBox(height: 18),
          const WizardStepIndicator(step: 3, totalSteps: 4),
          Expanded(
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    width: 168,
                    height: 168,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        SizedBox(
                          width: 168,
                          height: 168,
                          child: CircularProgressIndicator(
                            strokeWidth: 6,
                            strokeCap: StrokeCap.round,
                            backgroundColor: ext.glassBorder,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              ext.accentGlow,
                            ),
                          ),
                        ),
                        Container(
                          width: 112,
                          height: 112,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: ext.accentGradient,
                            boxShadow: [
                              BoxShadow(
                                color: ext.accentGlow.withValues(alpha: 0.3),
                                blurRadius: 28,
                                offset: const Offset(0, 14),
                              ),
                            ],
                          ),
                          child: Icon(
                            Icons.restaurant_menu_rounded,
                            size: 44,
                            color: ext.onAccent,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 26),
                  Text(
                    l10n.mealPlanGeneratingTitle,
                    style: theme.textTheme.titleLarge?.copyWith(
                      color: ext.textPrimary,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
