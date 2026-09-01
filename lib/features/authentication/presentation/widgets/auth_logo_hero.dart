import 'package:flutter/material.dart';

import '../../../../core/theme/app_theme_extension.dart';

/// Static app-logo hero for the auth screens — replaces the rotating
/// [OnboardingHeroArt] medallion (kept for onboarding/welcome, where a bit
/// of motion suits the "first impression" moment) with the real brand mark,
/// no animation, so the login/signup/forgot-password screens read as calm
/// and immediate rather than showing something spinning on every visit.
class AuthLogoHero extends StatelessWidget {
  const AuthLogoHero({
    super.key,
    this.title,
    this.subtitle,
    this.logoSize = 108,
  });

  final String? title;
  final String? subtitle;
  final double logoSize;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final ext = theme.extension<AppThemeExtension>()!;

    return Column(
      children: [
        Image.asset('assets/app_logo.png', width: logoSize, height: logoSize),
        if (title != null) ...[
          const SizedBox(height: 14),
          Text(
            title!,
            textAlign: TextAlign.center,
            style: theme.textTheme.headlineMedium?.copyWith(
              color: ext.textPrimary,
              height: 1.08,
            ),
          ),
        ],
        if (subtitle != null) ...[
          const SizedBox(height: 8),
          Text(
            subtitle!,
            textAlign: TextAlign.center,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: ext.textMuted,
              height: 1.4,
            ),
          ),
        ],
      ],
    );
  }
}
