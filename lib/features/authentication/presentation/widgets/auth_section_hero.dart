import 'package:flutter/material.dart';
import 'package:nabvera/core/theme/app_theme_extension.dart';

import 'onboarding_hero_art.dart';

/// Premium hero banner shared by every auth screen: the same abstract
/// gradient-medallion artwork used on the onboarding carousel, topped with
/// an optional kicker chip, a bold title, and a short subtitle. Replaces the
/// per-screen photo cards (boxing.png, kett.png, finger.png…) so the whole
/// auth flow reads as one cohesive design system with splash/onboarding.
class AuthSectionHero extends StatelessWidget {
  const AuthSectionHero({
    super.key,
    required this.icon,
    required this.colors,
    required this.title,
    required this.subtitle,
    this.kicker,
    this.heroHeight = 172,
  });

  final IconData icon;
  final List<Color> colors;
  final String title;
  final String subtitle;
  final String? kicker;
  final double heroHeight;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final ext = theme.extension<AppThemeExtension>()!;

    return Column(
      children: [
        SizedBox(
          height: heroHeight,
          child: OnboardingHeroArt(icon: icon, colors: colors),
        ),
        const SizedBox(height: 12),
        if (kicker != null) ...[
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: colors),
              borderRadius: BorderRadius.circular(999),
            ),
            child: Text(
              kicker!,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w800,
                fontSize: 11,
                letterSpacing: 1.1,
              ),
            ),
          ),
          const SizedBox(height: 14),
        ],
        Text(
          title,
          textAlign: TextAlign.center,
          style: theme.textTheme.headlineMedium?.copyWith(
            color: ext.textPrimary,
            height: 1.08,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          subtitle,
          textAlign: TextAlign.center,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: ext.textMuted,
            height: 1.4,
          ),
        ),
      ],
    );
  }
}
