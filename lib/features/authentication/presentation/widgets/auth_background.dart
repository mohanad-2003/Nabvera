import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nabvera/core/localization/generated/app_localizations.dart';
import 'package:nabvera/core/localization/locale_controller.dart';
import 'package:nabvera/core/theme/app_theme_extension.dart';
import 'package:nabvera/core/theme/theme_controller.dart';

/// Shared gradient backdrop for the auth/onboarding flow with theme-aware
/// surfaces and locale-aware preference controls.
class AuthBackground extends ConsumerWidget {
  const AuthBackground({
    super.key,
    required this.child,
    this.scrollable = true,
    this.showPreferenceControls = true,
  });

  final Widget child;
  final bool scrollable;
  final bool showPreferenceControls;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ext = Theme.of(context).extension<AppThemeExtension>()!;
    final theme = Theme.of(context);
    // Watch so toggling from the pill rebuilds; the effective brightness
    // (which also resolves ThemeMode.system) comes from the active theme.
    ref.watch(themeControllerProvider);
    final locale = ref.watch(localeControllerProvider);
    final isLightMode = theme.brightness == Brightness.light;
    final isArabic = locale.languageCode == 'ar';
    final content = SafeArea(child: child);

    return DecoratedBox(
      decoration: BoxDecoration(gradient: ext.backgroundGradient),
      child: Stack(
        children: [
          Positioned(
            top: -120,
            right: -90,
            child: _GlowOrb(
              size: 260,
              color: theme.colorScheme.primary,
              opacity: 0.24,
            ),
          ),
          Positioned(
            bottom: -90,
            left: -110,
            child: _GlowOrb(
              size: 280,
              color: theme.colorScheme.secondary,
              opacity: 0.18,
            ),
          ),
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    theme.colorScheme.surface,
                    theme.colorScheme.surfaceContainerHighest,
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
            ),
          ),
          Positioned.fill(
            child: scrollable ? SingleChildScrollView(child: content) : content,
          ),
          if (showPreferenceControls)
            SafeArea(
              child: Align(
                alignment: AlignmentDirectional.topEnd,
                child: Padding(
                  padding: const EdgeInsetsDirectional.only(top: 14, end: 18),
                  child: _PreferenceControls(
                    isLightMode: isLightMode,
                    isArabic: isArabic,
                    onThemeTap:
                        () => ref
                            .read(themeControllerProvider.notifier)
                            .setThemeMode(
                              isLightMode ? ThemeMode.dark : ThemeMode.light,
                            ),
                    onLocaleTap:
                        () => ref
                            .read(localeControllerProvider.notifier)
                            .setLocale(Locale(isArabic ? 'en' : 'ar')),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _PreferenceControls extends StatelessWidget {
  const _PreferenceControls({
    required this.isLightMode,
    required this.isArabic,
    required this.onThemeTap,
    required this.onLocaleTap,
  });

  final bool isLightMode;
  final bool isArabic;
  final VoidCallback onThemeTap;
  final VoidCallback onLocaleTap;

  @override
  Widget build(BuildContext context) {
    final ext = Theme.of(context).extension<AppThemeExtension>()!;
    final l10n = AppLocalizations.of(context);

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _PreferenceButton(
          icon:
              isLightMode ? Icons.dark_mode_rounded : Icons.light_mode_rounded,
          label: isLightMode ? l10n.themeDark : l10n.themeLight,
          onTap: onThemeTap,
          color: ext.textPrimary,
          borderColor: ext.glassBorder,
          fillColor: ext.glassFill,
        ),
        const SizedBox(width: 8),
        _PreferenceButton(
          icon: Icons.language_rounded,
          label: isArabic ? 'EN' : 'AR',
          onTap: onLocaleTap,
          color: ext.textPrimary,
          borderColor: ext.glassBorder,
          fillColor: ext.glassFill,
        ),
      ],
    );
  }
}

class _PreferenceButton extends StatelessWidget {
  const _PreferenceButton({
    required this.icon,
    required this.label,
    required this.onTap,
    required this.color,
    required this.borderColor,
    required this.fillColor,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final Color color;
  final Color borderColor;
  final Color fillColor;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(999),
      child: Container(
        height: 36,
        padding: const EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
          color: fillColor,
          borderRadius: BorderRadius.circular(999),
          border: Border.all(color: borderColor),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: color, size: 16),
            const SizedBox(width: 5),
            Text(
              label,
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.w800,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _GlowOrb extends StatelessWidget {
  const _GlowOrb({
    required this.size,
    required this.color,
    required this.opacity,
  });

  final double size;
  final Color color;
  final double opacity;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(
          colors: [
            color.withValues(alpha: opacity),
            color.withValues(alpha: 0),
          ],
        ),
      ),
    );
  }
}
