import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:nabvera/core/localization/generated/app_localizations.dart';
import 'package:nabvera/core/routing/app_routes.dart';
import 'package:nabvera/core/widgets/primary_button.dart';
import 'package:nabvera/features/onboarding/domain/onboarding_bounds.dart';
import 'package:nabvera/features/onboarding/presentation/providers/onboarding_profile_controller.dart';
import 'package:nabvera/features/onboarding/presentation/widgets/wizard_scaffold.dart';
import 'package:nabvera/features/onboarding/presentation/widgets/wizard_value_stepper.dart';

class AgePage extends ConsumerWidget {
  const AgePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final age = ref.watch(onboardingProfileControllerProvider).age;
    final controller = ref.read(onboardingProfileControllerProvider.notifier);
    final l10n = AppLocalizations.of(context);

    return WizardScaffold(
      step: 2,
      totalSteps: 8,
      title: l10n.onboardingAgeTitle,
      description: l10n.onboardingAgeBody,
      body: WizardValueStepper(
        value: age,
        min: OnboardingBounds.minAge,
        max: OnboardingBounds.maxAge,
        unit: '',
        semanticLabel: l10n.onboardingAgeValue(age),
        onChanged: controller.setAge,
      ),
      button: PrimaryButton(
        label: l10n.actionContinue,
        onPressed: () => context.push(AppRoutes.setupWeight),
      ),
    );
  }
}
