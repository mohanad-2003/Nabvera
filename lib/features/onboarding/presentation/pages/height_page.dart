import 'package:nabvera/core/localization/generated/app_localizations.dart';
import 'package:nabvera/core/routing/app_routes.dart';
import 'package:nabvera/core/widgets/primary_button.dart';
import 'package:nabvera/features/onboarding/domain/onboarding_bounds.dart';
import 'package:nabvera/features/onboarding/presentation/providers/onboarding_profile_controller.dart';
import 'package:nabvera/features/onboarding/presentation/widgets/wizard_scaffold.dart';
import 'package:nabvera/features/onboarding/presentation/widgets/wizard_value_stepper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class HeightPage extends ConsumerWidget {
  const HeightPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final height = ref.watch(onboardingProfileControllerProvider).heightCm;
    final controller = ref.read(onboardingProfileControllerProvider.notifier);
    final l10n = AppLocalizations.of(context);

    return WizardScaffold(
      step: 4,
      totalSteps: 8,
      title: l10n.onboardingHeightTitle,
      description: l10n.onboardingHeightBody,
      body: WizardValueStepper(
        value: height,
        min: OnboardingBounds.minHeightCm,
        max: OnboardingBounds.maxHeightCm,
        unit: l10n.unitCm,
        semanticLabel: l10n.onboardingHeightValue(height),
        onChanged: controller.setHeight,
      ),
      button: PrimaryButton(
        label: l10n.actionContinue,
        onPressed: () => context.push(AppRoutes.setupGoal),
      ),
    );
  }
}
