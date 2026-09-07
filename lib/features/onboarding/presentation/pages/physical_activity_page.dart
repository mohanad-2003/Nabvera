import 'package:nabvera/core/localization/generated/app_localizations.dart';
import 'package:nabvera/core/routing/app_routes.dart';
import 'package:nabvera/core/widgets/primary_button.dart';
import 'package:nabvera/features/onboarding/presentation/providers/onboarding_profile_controller.dart';
import 'package:nabvera/features/onboarding/presentation/widgets/wizard_option_card.dart';
import 'package:nabvera/features/onboarding/presentation/widgets/wizard_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

String _levelLabel(AppLocalizations l10n, ActivityLevel level) =>
    switch (level) {
      ActivityLevel.beginner => l10n.workoutLevelBeginner,
      ActivityLevel.intermediate => l10n.workoutLevelIntermediate,
      ActivityLevel.advanced => l10n.workoutLevelAdvanced,
    };

String _levelHint(AppLocalizations l10n, ActivityLevel level) =>
    switch (level) {
      ActivityLevel.beginner => l10n.workoutLevelBeginnerHint,
      ActivityLevel.intermediate => l10n.workoutLevelIntermediateHint,
      ActivityLevel.advanced => l10n.workoutLevelAdvancedHint,
    };

IconData _levelIcon(ActivityLevel level) => switch (level) {
  ActivityLevel.beginner => Icons.self_improvement_rounded,
  ActivityLevel.intermediate => Icons.directions_run_rounded,
  ActivityLevel.advanced => Icons.bolt_rounded,
};

class PhysicalActivityPage extends ConsumerWidget {
  const PhysicalActivityPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selected =
        ref.watch(onboardingProfileControllerProvider).activityLevel;
    final controller = ref.read(onboardingProfileControllerProvider.notifier);
    final l10n = AppLocalizations.of(context);
    final canContinue = selected != null;

    return WizardScaffold(
      step: 6,
      totalSteps: 8,
      title: l10n.onboardingPhysicalTitle,
      description: l10n.onboardingPhysicalBody,
      footerMessage: canContinue ? null : l10n.onboardingPhysicalRequired,
      body: WizardOptionList(
        children: [
          for (final level in ActivityLevel.values)
            WizardOptionCard(
              icon: _levelIcon(level),
              label: _levelLabel(l10n, level),
              hint: _levelHint(l10n, level),
              isSelected: selected == level,
              onTap: () => controller.selectActivityLevel(level),
            ),
        ],
      ),
      button: PrimaryButton(
        label: l10n.actionContinue,
        onPressed:
            canContinue ? () => context.push(AppRoutes.setupEquipment) : null,
      ),
    );
  }
}
