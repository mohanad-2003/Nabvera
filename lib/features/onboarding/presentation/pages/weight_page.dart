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

class WeightPage extends ConsumerWidget {
  const WeightPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final weight = ref.watch(onboardingProfileControllerProvider).weightKg;
    final controller = ref.read(onboardingProfileControllerProvider.notifier);
    final l10n = AppLocalizations.of(context);

    return WizardScaffold(
      step: 3,
      totalSteps: 8,
      title: l10n.onboardingWeightTitle,
      description: l10n.onboardingWeightBody,
      body: WizardValueStepper(
        value: weight,
        min: OnboardingBounds.minWeightKg,
        max: OnboardingBounds.maxWeightKg,
        unit: l10n.unitKg,
        semanticLabel: l10n.onboardingWeightValue(weight),
        onChanged: controller.setWeight,
      ),
      button: PrimaryButton(
        label: l10n.actionContinue,
        onPressed: () => context.push(AppRoutes.setupHeight),
      ),
    );
  }
}
