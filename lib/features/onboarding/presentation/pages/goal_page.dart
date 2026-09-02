import 'package:fitness_app/core/localization/generated/app_localizations.dart';
import 'package:fitness_app/core/routing/app_routes.dart';
import 'package:fitness_app/core/theme/app_theme_extension.dart';
import 'package:fitness_app/core/widgets/primary_button.dart';
import 'package:fitness_app/core/widgets/selectable_option_card.dart';
import 'package:fitness_app/features/onboarding/presentation/providers/onboarding_profile_controller.dart';
import 'package:fitness_app/features/onboarding/presentation/widgets/wizard_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

String _goalLabel(AppLocalizations l10n, FitnessGoal goal) => switch (goal) {
  FitnessGoal.loseWeight => l10n.goalLoseWeight,
  FitnessGoal.gainWeight => l10n.goalGainWeight,
  FitnessGoal.muscleMassGain => l10n.goalMuscleMassGain,
  FitnessGoal.shapeBody => l10n.goalShapeBody,
  FitnessGoal.others => l10n.goalOthers,
};

class GoalPage extends ConsumerWidget {
  const GoalPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedGoal = ref.watch(onboardingProfileControllerProvider).goal;
    final controller = ref.read(onboardingProfileControllerProvider.notifier);
    final ext = Theme.of(context).extension<AppThemeExtension>()!;
    final l10n = AppLocalizations.of(context);

    return WizardScaffold(
      step: 5,
      totalSteps: 8,
      title: l10n.onboardingGoalTitle,
      description: l10n.onboardingGoalBody,
      body: Container(
        margin: const EdgeInsets.symmetric(horizontal: 24),
        padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
        decoration: BoxDecoration(
          color: ext.glassFill,
          borderRadius: BorderRadius.circular(25),
          border: Border.all(color: ext.glassBorder),
        ),
        child: Column(
          children: [
            for (final goal in FitnessGoal.values) ...[
              SelectableOptionCard(
                label: _goalLabel(l10n, goal),
                isSelected: selectedGoal == goal,
                showCheckmark: true,
                onTap: () => controller.selectGoal(goal),
              ),
              const SizedBox(height: 20),
            ],
          ],
        ),
      ),
      button: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: PrimaryButton(
          label: l10n.actionContinue,
          onPressed: () => context.push(AppRoutes.setupPhysical),
        ),
      ),
    );
  }
}
