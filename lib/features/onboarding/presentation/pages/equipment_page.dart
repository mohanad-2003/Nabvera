import 'package:nabvera/core/localization/generated/app_localizations.dart';
import 'package:nabvera/core/routing/app_routes.dart';
import 'package:nabvera/core/widgets/primary_button.dart';
import 'package:nabvera/core/widgets/selectable_option_card.dart';
import 'package:nabvera/features/onboarding/presentation/providers/onboarding_profile_controller.dart';
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
      body: SizedBox(
        height: 260,
        child: ListView.separated(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          itemCount: AvailableEquipment.values.length,
          separatorBuilder: (_, _) => const SizedBox(height: 12),
          itemBuilder: (context, index) {
            final equipment = AvailableEquipment.values[index];
            return SelectableOptionCard(
              label: _equipmentLabel(l10n, equipment),
              isSelected: profile.availableEquipment.contains(equipment),
              showCheckmark: true,
              onTap: () => controller.toggleEquipment(equipment),
            );
          },
        ),
      ),
      button: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: PrimaryButton(
          label: l10n.actionContinue,
          onPressed: () => context.push(AppRoutes.setupTime),
        ),
      ),
    );
  }
}
