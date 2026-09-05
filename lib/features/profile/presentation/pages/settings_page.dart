import 'package:nabvera/core/localization/generated/app_localizations.dart';
import 'package:nabvera/core/localization/locale_controller.dart';
import 'package:nabvera/core/routing/app_routes.dart';
import 'package:nabvera/core/theme/app_theme_extension.dart';
import 'package:nabvera/core/theme/theme_controller.dart';
import 'package:nabvera/core/widgets/fade_slide_in.dart';
import 'package:nabvera/core/widgets/premium_scaffold.dart';
import 'package:nabvera/features/profile/presentation/widgets/profile_menu_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final themeMode = ref.watch(themeControllerProvider);
    final locale = ref.watch(localeControllerProvider);
    final ext = Theme.of(context).extension<AppThemeExtension>()!;

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
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n.settingsTitle,
                        style: Theme.of(
                          context,
                        ).textTheme.headlineSmall?.copyWith(
                          color: ext.textPrimary,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      Text(
                        l10n.settingsSubtitle,
                        style: Theme.of(
                          context,
                        ).textTheme.bodyMedium?.copyWith(color: ext.textMuted),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 26),
              PremiumSectionHeader(title: l10n.settingsTheme),
              const SizedBox(height: 12),
              _AppearanceCard(themeMode: themeMode),
              const SizedBox(height: 26),
              PremiumSectionHeader(title: l10n.settingsLanguage),
              const SizedBox(height: 12),
              _LanguageCard(locale: locale),
              const SizedBox(height: 26),
              PremiumSectionHeader(title: l10n.settingsSectionAccount),
              const SizedBox(height: 12),
              ProfileMenuTile(
                icon: Icons.notifications_outlined,
                title: l10n.settingsNotification,
                subtitle: l10n.settingsNotificationSubtitle,
                flat: true,
                onTap: () => context.push(AppRoutes.notificationSettings),
              ),
              const SizedBox(height: 10),
              ProfileMenuTile(
                icon: Icons.key_outlined,
                title: l10n.settingsPassword,
                subtitle: l10n.settingsPasswordSubtitle,
                flat: true,
                onTap: () => context.push(AppRoutes.passwordSettings),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AppearanceCard extends ConsumerWidget {
  const _AppearanceCard({required this.themeMode});
  final ThemeMode themeMode;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final controller = ref.read(themeControllerProvider.notifier);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
      child: Column(
        children: [
          _ThemeOptionTile(
            icon: Icons.light_mode_rounded,
            label: l10n.themeLight,
            selected: themeMode == ThemeMode.light,
            onTap: () => controller.setThemeMode(ThemeMode.light),
          ),
          Divider(
            color:
                Theme.of(context).extension<AppThemeExtension>()!.glassBorder,
            height: 1,
          ),
          _ThemeOptionTile(
            icon: Icons.dark_mode_rounded,
            label: l10n.themeDark,
            selected: themeMode == ThemeMode.dark,
            onTap: () => controller.setThemeMode(ThemeMode.dark),
          ),
          Divider(
            color:
                Theme.of(context).extension<AppThemeExtension>()!.glassBorder,
            height: 1,
          ),
          _ThemeOptionTile(
            icon: Icons.phone_iphone_rounded,
            label: l10n.themeSystem,
            selected: themeMode == ThemeMode.system,
            onTap: () => controller.setThemeMode(ThemeMode.system),
          ),
        ],
      ),
    );
  }
}

class _ThemeOptionTile extends StatelessWidget {
  const _ThemeOptionTile({
    required this.icon,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final ext = Theme.of(context).extension<AppThemeExtension>()!;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
        child: Row(
          children: [
            Icon(
              icon,
              color:
                  selected
                      ? Theme.of(context).colorScheme.primary
                      : ext.textMuted,
              size: 22,
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  color: ext.textPrimary,
                  fontSize: 15,
                  fontWeight: selected ? FontWeight.w800 : FontWeight.w500,
                ),
              ),
            ),
            Icon(
              selected
                  ? Icons.radio_button_checked_rounded
                  : Icons.radio_button_off_rounded,
              color:
                  selected
                      ? Theme.of(context).colorScheme.primary
                      : ext.textMuted,
              size: 22,
            ),
          ],
        ),
      ),
    );
  }
}

class _LanguageCard extends ConsumerWidget {
  const _LanguageCard({required this.locale});
  final Locale locale;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.read(localeControllerProvider.notifier);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
      child: Column(
        children: [
          _LanguageOptionTile(
            flag: '🇺🇸',
            label: 'English',
            selected: locale.languageCode == 'en',
            onTap: () => controller.setLocale(const Locale('en')),
          ),
          Divider(
            color:
                Theme.of(context).extension<AppThemeExtension>()!.glassBorder,
            height: 1,
          ),
          _LanguageOptionTile(
            flag: '🇸🇦',
            label: 'العربية',
            selected: locale.languageCode == 'ar',
            onTap: () => controller.setLocale(const Locale('ar')),
          ),
        ],
      ),
    );
  }
}

class _LanguageOptionTile extends StatelessWidget {
  const _LanguageOptionTile({
    required this.flag,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String flag;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final ext = Theme.of(context).extension<AppThemeExtension>()!;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
        child: Row(
          children: [
            Text(flag, style: const TextStyle(fontSize: 20)),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  color: ext.textPrimary,
                  fontSize: 15,
                  fontWeight: selected ? FontWeight.w800 : FontWeight.w500,
                ),
              ),
            ),
            Icon(
              selected
                  ? Icons.radio_button_checked_rounded
                  : Icons.radio_button_off_rounded,
              color:
                  selected
                      ? Theme.of(context).colorScheme.primary
                      : ext.textMuted,
              size: 22,
            ),
          ],
        ),
      ),
    );
  }
}
