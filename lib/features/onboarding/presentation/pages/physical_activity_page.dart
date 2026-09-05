import 'package:nabvera/core/localization/generated/app_localizations.dart';
import 'package:nabvera/core/routing/app_routes.dart';
import 'package:nabvera/core/widgets/primary_button.dart';
import 'package:nabvera/core/widgets/selectable_option_card.dart';
import 'package:nabvera/features/onboarding/presentation/providers/onboarding_profile_controller.dart';
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

class PhysicalActivityPage extends ConsumerWidget {
  const PhysicalActivityPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selected =
        ref.watch(onboardingProfileControllerProvider).activityLevel;
    final controller = ref.read(onboardingProfileControllerProvider.notifier);
    final l10n = AppLocalizations.of(context);

    return WizardScaffold(
      step: 6,
      totalSteps: 8,
      title: l10n.onboardingPhysicalTitle,
      description: l10n.onboardingPhysicalBody,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          children: [
            for (final level in ActivityLevel.values) ...[
              SelectableOptionCard(
                label: _levelLabel(l10n, level),
                isSelected: selected == level,
                centered: true,
                onTap: () => controller.selectActivityLevel(level),
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
          onPressed: () => context.push(AppRoutes.setupEquipment),
        ),
      ),
    );
  }
}
