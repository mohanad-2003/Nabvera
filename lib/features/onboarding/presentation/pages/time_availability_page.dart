import 'package:nabvera/core/localization/generated/app_localizations.dart';
import 'package:nabvera/core/routing/app_routes.dart';
import 'package:nabvera/core/widgets/primary_button.dart';
import 'package:nabvera/features/onboarding/presentation/providers/onboarding_profile_controller.dart';
import 'package:nabvera/features/onboarding/presentation/widgets/wizard_option_card.dart';
import 'package:nabvera/features/onboarding/presentation/widgets/wizard_scaffold.dart';
import 'package:nabvera/features/profile/presentation/providers/profile_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

String _timeLabel(AppLocalizations l10n, AvailableTime time) => switch (time) {
  AvailableTime.minutes15 => l10n.onboardingTime15,
  AvailableTime.minutes30 => l10n.onboardingTime30,
  AvailableTime.minutes45 => l10n.onboardingTime45,
  AvailableTime.minutes60 => l10n.onboardingTime60,
};

String _timeHint(AppLocalizations l10n, AvailableTime time) => switch (time) {
  AvailableTime.minutes15 => l10n.onboardingTime15Hint,
  AvailableTime.minutes30 => l10n.onboardingTime30Hint,
  AvailableTime.minutes45 => l10n.onboardingTime45Hint,
  AvailableTime.minutes60 => l10n.onboardingTime60Hint,
};

IconData _timeIcon(AvailableTime time) => switch (time) {
  AvailableTime.minutes15 => Icons.timer_rounded,
  AvailableTime.minutes30 => Icons.schedule_rounded,
  AvailableTime.minutes45 => Icons.access_time_rounded,
  AvailableTime.minutes60 => Icons.watch_later_rounded,
};

class TimeAvailabilityPage extends ConsumerStatefulWidget {
  const TimeAvailabilityPage({super.key});

  @override
  ConsumerState<TimeAvailabilityPage> createState() =>
      _TimeAvailabilityPageState();
}

class _TimeAvailabilityPageState extends ConsumerState<TimeAvailabilityPage> {
  bool _saving = false;
  bool _failed = false;

  Future<void> _finish() async {
    setState(() {
      _saving = true;
      _failed = false;
    });
    try {
      await ref.read(onboardingProfileControllerProvider.notifier).submit();
      ref.invalidate(currentUserProfileProvider);
      // Only reached on real success — a thrown error skips straight to
      // catch, so Home is never entered on a failed save.
      if (mounted) context.go(AppRoutes.home);
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _saving = false;
        _failed = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final selected =
        ref.watch(onboardingProfileControllerProvider).availableTime;
    final controller = ref.read(onboardingProfileControllerProvider.notifier);
    final l10n = AppLocalizations.of(context);

    return WizardScaffold(
      step: 8,
      totalSteps: 8,
      title: l10n.onboardingTimeTitle,
      description: l10n.onboardingTimeBody,
      footerMessage:
          _saving
              ? l10n.onboardingSaving
              : _failed
              ? l10n.onboardingSaveFailed
              : null,
      footerMessageIsError: _failed,
      body: WizardOptionList(
        children: [
          for (final time in AvailableTime.values)
            WizardOptionCard(
              icon: _timeIcon(time),
              label: _timeLabel(l10n, time),
              hint: _timeHint(l10n, time),
              isSelected: selected == time,
              onTap: _saving ? () {} : () => controller.selectAvailableTime(time),
            ),
        ],
      ),
      // isLoading (not just onPressed: null) both shows a real saving
      // state and blocks a repeated tap from firing submit() twice.
      button: PrimaryButton(
        label: _failed ? l10n.actionRetry : l10n.onboardingStart,
        isLoading: _saving,
        onPressed: _finish,
      ),
    );
  }
}
