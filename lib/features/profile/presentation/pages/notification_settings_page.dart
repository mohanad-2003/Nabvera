import 'package:nabvera/core/localization/generated/app_localizations.dart';
import 'package:nabvera/core/theme/app_theme_extension.dart';
import 'package:nabvera/core/widgets/fade_slide_in.dart';
import 'package:nabvera/core/widgets/premium_scaffold.dart';
import 'package:nabvera/features/profile/presentation/widgets/settings_card.dart';
import 'package:nabvera/features/profile/presentation/widgets/settings_toggle_row.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

enum _NotificationToggle {
  general,
  sound,
  doNotDisturb,
  vibrate,
  lockScreen,
  reminders,
}

class NotificationSettingsPage extends StatefulWidget {
  const NotificationSettingsPage({super.key});

  @override
  State<NotificationSettingsPage> createState() =>
      _NotificationSettingsPageState();
}

class _NotificationSettingsPageState extends State<NotificationSettingsPage> {
  final Map<_NotificationToggle, bool> _toggles = {
    _NotificationToggle.general: true,
    _NotificationToggle.sound: true,
    _NotificationToggle.doNotDisturb: false,
    _NotificationToggle.vibrate: true,
    _NotificationToggle.lockScreen: true,
    _NotificationToggle.reminders: true,
  };

  (IconData, String, String) _copy(
    _NotificationToggle key,
    AppLocalizations l10n,
  ) => switch (key) {
    _NotificationToggle.general => (
      Icons.notifications_active_outlined,
      l10n.notificationToggleGeneral,
      l10n.notificationToggleGeneralBody,
    ),
    _NotificationToggle.sound => (
      Icons.volume_up_outlined,
      l10n.notificationToggleSound,
      l10n.notificationToggleSoundBody,
    ),
    _NotificationToggle.doNotDisturb => (
      Icons.do_not_disturb_on_outlined,
      l10n.notificationToggleDoNotDisturb,
      l10n.notificationToggleDoNotDisturbBody,
    ),
    _NotificationToggle.vibrate => (
      Icons.vibration_rounded,
      l10n.notificationToggleVibrate,
      l10n.notificationToggleVibrateBody,
    ),
    _NotificationToggle.lockScreen => (
      Icons.lock_outline_rounded,
      l10n.notificationToggleLockScreen,
      l10n.notificationToggleLockScreenBody,
    ),
    _NotificationToggle.reminders => (
      Icons.alarm_outlined,
      l10n.notificationToggleReminders,
      l10n.notificationToggleRemindersBody,
    ),
  };

  @override
  Widget build(BuildContext context) {
    final ext = Theme.of(context).extension<AppThemeExtension>()!;
    final l10n = AppLocalizations.of(context);

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
                  for (final key in _NotificationToggle.values)
                    Builder(
                      builder: (context) {
                        final (icon, title, subtitle) = _copy(key, l10n);
                        return SettingsToggleRow(
                          icon: icon,
                          title: title,
                          subtitle: subtitle,
                          value: _toggles[key]!,
                          onChanged:
                              (value) => setState(() => _toggles[key] = value),
                        );
                      },
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
