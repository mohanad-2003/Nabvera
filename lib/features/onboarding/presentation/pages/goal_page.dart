import 'package:nabvera/core/localization/generated/app_localizations.dart';
import 'package:nabvera/core/routing/app_routes.dart';
import 'package:nabvera/core/widgets/primary_button.dart';
import 'package:nabvera/features/onboarding/presentation/providers/onboarding_profile_controller.dart';
import 'package:nabvera/features/onboarding/presentation/widgets/wizard_option_card.dart';
import 'package:nabvera/features/onboarding/presentation/widgets/wizard_scaffold.dart';
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

String _goalHint(AppLocalizations l10n, FitnessGoal goal) => switch (goal) {
  FitnessGoal.loseWeight => l10n.goalLoseWeightHint,
  FitnessGoal.gainWeight => l10n.goalGainWeightHint,
  FitnessGoal.muscleMassGain => l10n.goalMuscleMassGainHint,
  FitnessGoal.shapeBody => l10n.goalShapeBodyHint,
  FitnessGoal.others => l10n.goalOthersHint,
};

IconData _goalIcon(FitnessGoal goal) => switch (goal) {
  FitnessGoal.loseWeight => Icons.trending_down_rounded,
  FitnessGoal.gainWeight => Icons.trending_up_rounded,
  FitnessGoal.muscleMassGain => Icons.fitness_center_rounded,
  FitnessGoal.shapeBody => Icons.accessibility_new_rounded,
  FitnessGoal.others => Icons.more_horiz_rounded,
};

class GoalPage extends ConsumerWidget {
  const GoalPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedGoal = ref.watch(onboardingProfileControllerProvider).goal;
    final controller = ref.read(onboardingProfileControllerProvider.notifier);
    final l10n = AppLocalizations.of(context);
    final canContinue = selectedGoal != null;

    return WizardScaffold(
      step: 5,
      totalSteps: 8,
      title: l10n.onboardingGoalTitle,
      description: l10n.onboardingGoalBody,
      footerMessage: canContinue ? null : l10n.onboardingGoalRequired,
      body: WizardOptionList(
        children: [
          for (final goal in FitnessGoal.values)
            WizardOptionCard(
              icon: _goalIcon(goal),
              label: _goalLabel(l10n, goal),
              hint: _goalHint(l10n, goal),
              isSelected: selectedGoal == goal,
              onTap: () => controller.selectGoal(goal),
            ),
        ],
      ),
      button: PrimaryButton(
        label: l10n.actionContinue,
        onPressed:
            canContinue ? () => context.push(AppRoutes.setupPhysical) : null,
      ),
    );
  }
}
