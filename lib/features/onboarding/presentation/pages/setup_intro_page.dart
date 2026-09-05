import 'package:nabvera/core/localization/generated/app_localizations.dart';
import 'package:nabvera/core/routing/app_routes.dart';
import 'package:nabvera/core/theme/app_theme_extension.dart';
import 'package:nabvera/core/widgets/primary_button.dart';
import 'package:nabvera/features/authentication/presentation/widgets/auth_background.dart';
import 'package:nabvera/features/authentication/presentation/widgets/auth_header.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SetupIntroPage extends StatelessWidget {
  const SetupIntroPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final ext = theme.extension<AppThemeExtension>()!;
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      body: AuthBackground(
        child: Column(
          children: [
            const AuthHeader(),
            const SizedBox(height: 20),
            const _SetupHero(),
            const SizedBox(height: 30),
            Text(
              l10n.setupIntroHeadline,
              textAlign: TextAlign.center,
              style: theme.textTheme.headlineSmall?.copyWith(
                color: theme.colorScheme.primary,
                fontWeight: FontWeight.w800,
                height: 1.3,
              ),
            ),
            const SizedBox(height: 20),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 24),
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: ext.glassFill,
                borderRadius: BorderRadius.circular(25),
                border: Border.all(color: ext.glassBorder),
              ),
              child: Text(
                textAlign: TextAlign.center,
                l10n.setupIntroBody,
                style: TextStyle(
                  color: ext.textMuted,
                  fontSize: 14,
                  height: 1.5,
                ),
              ),
            ),
            const SizedBox(height: 30),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: PrimaryButton(
                label: l10n.setupIntroCta,
                onPressed: () => context.push(AppRoutes.setupGender),
              ),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}

/// Icon/gradient hero replacing the previous full-bleed stock photo
/// (`assets/setup.png`) — three concentric rings around a gradient medallion
/// with a fitness glyph, plus small orbiting accent chips.
class _SetupHero extends StatelessWidget {
  const _SetupHero();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final ext = theme.extension<AppThemeExtension>()!;

    return SizedBox(
      height: 220,
      child: Center(
        child: Stack(
          alignment: Alignment.center,
          children: [
            Container(
              width: 220,
              height: 220,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: ext.glassFill),
              ),
            ),
            Container(
              width: 168,
              height: 168,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: ext.glassBorder),
              ),
            ),
            Container(
              width: 116,
              height: 116,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: ext.accentGradient,
                boxShadow: [
                  BoxShadow(
                    color: ext.accentGlow.withValues(alpha: 0.35),
                    blurRadius: 40,
                    offset: const Offset(0, 16),
                  ),
                ],
              ),
              child: Icon(
                Icons.fitness_center_rounded,
                color: ext.onAccent,
                size: 52,
              ),
            ),
            Positioned(
              top: 12,
              right: 24,
              child: _AccentChip(
                icon: Icons.local_fire_department_rounded,
                color: ext.warning,
              ),
            ),
            Positioned(
              bottom: 18,
              left: 18,
              child: _AccentChip(
                icon: Icons.favorite_rounded,
                color: ext.danger,
              ),
            ),
            Positioned(
              bottom: 4,
              right: 4,
              child: _AccentChip(
                icon: Icons.emoji_events_rounded,
                color: ext.success,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AccentChip extends StatelessWidget {
  const _AccentChip({required this.icon, required this.color});

  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final ext = Theme.of(context).extension<AppThemeExtension>()!;

    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: ext.cardColor,
        border: Border.all(color: color.withValues(alpha: 0.4), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.28),
            blurRadius: 14,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Icon(icon, color: color, size: 18),
    );
  }
}
