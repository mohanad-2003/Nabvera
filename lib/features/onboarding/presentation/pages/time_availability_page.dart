import 'package:fitness_app/core/localization/generated/app_localizations.dart';
import 'package:fitness_app/core/routing/app_routes.dart';
import 'package:fitness_app/core/widgets/primary_button.dart';
import 'package:fitness_app/core/widgets/selectable_option_card.dart';
import 'package:fitness_app/features/onboarding/presentation/providers/onboarding_profile_controller.dart';
import 'package:fitness_app/features/onboarding/presentation/widgets/wizard_scaffold.dart';
import 'package:fitness_app/features/profile/presentation/providers/profile_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

String _timeLabel(AppLocalizations l10n, AvailableTime time) => switch (time) {
  AvailableTime.minutes15 => l10n.onboardingTime15,
  AvailableTime.minutes30 => l10n.onboardingTime30,
  AvailableTime.minutes45 => l10n.onboardingTime45,
  AvailableTime.minutes60 => l10n.onboardingTime60,
};

class TimeAvailabilityPage extends ConsumerWidget {
  const TimeAvailabilityPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selected =
        ref.watch(onboardingProfileControllerProvider).availableTime;
    final controller = ref.read(onboardingProfileControllerProvider.notifier);
    final l10n = AppLocalizations.of(context);
    return WizardScaffold(
      step: 8,
      totalSteps: 8,
      title: l10n.onboardingTimeTitle,
      description: l10n.onboardingTimeBody,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          children: [
            for (final time in AvailableTime.values) ...[
              SelectableOptionCard(
                label: _timeLabel(l10n, time),
                isSelected: selected == time,
                centered: true,
                onTap: () => controller.selectAvailableTime(time),
              ),
              const SizedBox(height: 16),
            ],
          ],
        ),
      ),
      button: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: PrimaryButton(
          label: l10n.onboardingStart,
          onPressed: () async {
            await controller.submit();
            ref.invalidate(currentUserProfileProvider);
            if (context.mounted) context.go(AppRoutes.home);
          },
        ),
      ),
    );
  }
}
