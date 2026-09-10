import 'package:nabvera/core/localization/generated/app_localizations.dart';
import 'package:nabvera/core/notifications/push_notification_service.dart';
import 'package:nabvera/core/storage/preferences_service.dart';
import 'package:nabvera/core/theme/app_colors.dart';
import 'package:nabvera/core/theme/app_theme_extension.dart';
import 'package:nabvera/core/widgets/fade_slide_in.dart';
import 'package:nabvera/core/widgets/premium_scaffold.dart';
import 'package:nabvera/features/profile/presentation/providers/profile_controller.dart';
import 'package:nabvera/features/profile/presentation/providers/workout_schedule_controller.dart';
import 'package:nabvera/features/profile/presentation/widgets/settings_action_row.dart';
import 'package:nabvera/features/profile/presentation/widgets/settings_card.dart';
import 'package:nabvera/features/profile/presentation/widgets/settings_toggle_row.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:permission_handler/permission_handler.dart';

/// Two of the six toggles this screen used to show were purely cosmetic —
/// a local `setState` with nothing behind it, resetting the moment you
/// left the screen. The other four (sound/vibrate/lock-screen/do-not-
/// disturb) can't be toggles at all: on Android, a notification channel's
/// sound/vibration/visibility are locked in at the moment the channel is
/// first created and only the user can change them afterwards, from
/// system Settings — no app, this one included, can override that later.
/// So this screen now has exactly two *real* toggles (General, wired to
/// [PreferencesService.notificationsEnabled]; Reminders, wired to the
/// actual [WorkoutReminderScheduler] via `profile.reminderEnabled`) and
/// one action row that opens system Settings for everything else.
class NotificationSettingsPage extends ConsumerStatefulWidget {
  const NotificationSettingsPage({super.key});

  @override
  ConsumerState<NotificationSettingsPage> createState() =>
      _NotificationSettingsPageState();
}

class _NotificationSettingsPageState
    extends ConsumerState<NotificationSettingsPage> {
  late bool _generalEnabled;
  bool _savingReminders = false;

  @override
  void initState() {
    super.initState();
    _generalEnabled = ref.read(preferencesServiceProvider).notificationsEnabled;
  }

  Future<void> _onGeneralChanged(bool value) async {
    setState(() => _generalEnabled = value);
    await ref.read(preferencesServiceProvider).setNotificationsEnabled(value);
    // Actually start/stop receiving push, not just remember the choice —
    // see PushNotificationService's own doc comments.
    final pushService = ref.read(pushNotificationServiceProvider);
    if (value) {
      await pushService.initializeIfNeeded();
    } else {
      await pushService.unregisterCurrentDevice();
    }
  }

  Future<void> _onRemindersChanged(bool value) async {
    final profile = ref.read(currentUserProfileProvider);
    setState(() => _savingReminders = true);
    try {
      await saveWorkoutSchedule(
        ref,
        patch: {'reminderEnabled': value},
        previousReminderEnabled: profile.reminderEnabled,
      );
    } catch (_) {
      if (!mounted) return;
      final l10n = AppLocalizations.of(context);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(l10n.workoutScheduleSaveFailed)));
    } finally {
      if (mounted) setState(() => _savingReminders = false);
    }
  }

  Future<void> _openSystemSettings() async {
    final opened = await openAppSettings();
    if (!opened && mounted) {
      final l10n = AppLocalizations.of(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.notificationOpenSystemSettingsFailed)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final ext = Theme.of(context).extension<AppThemeExtension>()!;
    final l10n = AppLocalizations.of(context);
    final remindersEnabled = ref.watch(
      currentUserProfileProvider.select((p) => p.reminderEnabled),
    );

    return PremiumScaffold(
      child: SingleChildScrollView(
        child: FadeSlideIn(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  if (context.canPop())
                    PremiumIconButton(
                      icon: Icons.arrow_back_ios_new_rounded,
                      onTap: () => context.pop(),
                    ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          l10n.notificationSettingsTitle,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(
                            context,
                          ).textTheme.headlineSmall?.copyWith(
                            color: ext.textPrimary,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        Text(
                          l10n.notificationSettingsSubtitle,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(color: ext.textMuted),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 26),
              SettingsCard(
                children: [
                  SettingsToggleRow(
                    icon: Icons.notifications_active_outlined,
                    title: l10n.notificationToggleGeneral,
                    subtitle: l10n.notificationToggleGeneralBody,
                    value: _generalEnabled,
                    onChanged: (value) => _onGeneralChanged(value),
                  ),
                  Opacity(
                    opacity: _savingReminders ? 0.5 : 1,
                    child: IgnorePointer(
                      ignoring: _savingReminders,
                      child: SettingsToggleRow(
                        icon: Icons.alarm_outlined,
                        title: l10n.notificationToggleReminders,
                        subtitle: l10n.notificationToggleRemindersBody,
                        value: remindersEnabled,
                        onChanged: (value) => _onRemindersChanged(value),
                        // Matches NotificationCategory.reminder's own
                        // accent (notification_models.dart) — the same
                        // concept, so the same color, wherever it shows up.
                        iconColor: AppColors.aquaBlue,
                      ),
                    ),
                  ),
                  SettingsActionRow(
                    icon: Icons.tune_rounded,
                    title: l10n.notificationOpenSystemSettingsTitle,
                    subtitle: l10n.notificationOpenSystemSettingsBody,
                    onTap: _openSystemSettings,
                    // Deliberately muted, not a brand accent — this row
                    // doesn't toggle an in-app feature, it hands off to
                    // the OS, and the color says so at a glance.
                    iconColor: ext.textMuted,
                  ),
                ],
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
