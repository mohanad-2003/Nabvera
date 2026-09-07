import 'package:nabvera/core/localization/generated/app_localizations.dart';
import 'package:nabvera/core/routing/app_routes.dart';
import 'package:nabvera/core/widgets/primary_button.dart';
import 'package:nabvera/features/onboarding/presentation/providers/onboarding_profile_controller.dart';
import 'package:nabvera/features/onboarding/presentation/widgets/wizard_option_card.dart';
import 'package:nabvera/features/onboarding/presentation/widgets/wizard_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

String _equipmentLabel(AppLocalizations l10n, AvailableEquipment equipment) =>
    switch (equipment) {
      AvailableEquipment.none => l10n.onboardingEquipmentNone,
      AvailableEquipment.dumbbell => l10n.onboardingEquipmentDumbbell,
      AvailableEquipment.barbell => l10n.onboardingEquipmentBarbell,
      AvailableEquipment.machine => l10n.onboardingEquipmentMachine,
      AvailableEquipment.resistanceBand => l10n.onboardingEquipmentBand,
      AvailableEquipment.kettlebell => l10n.onboardingEquipmentKettlebell,
    };

String _equipmentHint(AppLocalizations l10n, AvailableEquipment equipment) =>
    switch (equipment) {
      AvailableEquipment.none => l10n.onboardingEquipmentNoneHint,
      AvailableEquipment.dumbbell => l10n.onboardingEquipmentDumbbellHint,
      AvailableEquipment.barbell => l10n.onboardingEquipmentBarbellHint,
      AvailableEquipment.machine => l10n.onboardingEquipmentMachineHint,
      AvailableEquipment.resistanceBand => l10n.onboardingEquipmentBandHint,
      AvailableEquipment.kettlebell => l10n.onboardingEquipmentKettlebellHint,
    };

IconData _equipmentIcon(AvailableEquipment equipment) => switch (equipment) {
  AvailableEquipment.none => Icons.accessibility_new_rounded,
  AvailableEquipment.dumbbell => Icons.fitness_center_rounded,
  AvailableEquipment.barbell => Icons.sports_gymnastics_rounded,
  AvailableEquipment.machine => Icons.precision_manufacturing_rounded,
  AvailableEquipment.resistanceBand => Icons.waves_rounded,
  AvailableEquipment.kettlebell => Icons.sports_rounded,
};

class EquipmentPage extends ConsumerWidget {
  const EquipmentPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = ref.watch(onboardingProfileControllerProvider);
    final controller = ref.read(onboardingProfileControllerProvider.notifier);
    final l10n = AppLocalizations.of(context);

    return WizardScaffold(
      step: 7,
      totalSteps: 8,
      title: l10n.onboardingEquipmentTitle,
      description: l10n.onboardingEquipmentBody,
      body: WizardOptionList(
        children: [
          for (final equipment in AvailableEquipment.values)
            WizardOptionCard(
              icon: _equipmentIcon(equipment),
              label: _equipmentLabel(l10n, equipment),
              hint: _equipmentHint(l10n, equipment),
              isSelected: profile.availableEquipment.contains(equipment),
              multiSelect: true,
              onTap: () => controller.toggleEquipment(equipment),
            ),
        ],
      ),
      // No footer validation here: toggleEquipment() always keeps at
      // least "none" selected (see the controller), so there is never an
      // empty/invalid state a user could get stuck in on this step.
      button: PrimaryButton(
        label: l10n.actionContinue,
        onPressed: () => context.push(AppRoutes.setupTime),
      ),
    );
  }
}
