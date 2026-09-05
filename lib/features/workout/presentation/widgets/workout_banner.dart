import 'package:nabvera/core/theme/app_colors.dart';
import 'package:nabvera/core/theme/app_spacing.dart';
import 'package:nabvera/core/theme/app_theme_extension.dart';
import 'package:flutter/material.dart';

/// Motivational banner: fitness photo background, dark scrim, kicker title +
/// body copy, and a neon-gradient "Start Now" pill CTA.
class WorkoutBanner extends StatelessWidget {
  const WorkoutBanner({
    super.key,
    required this.title,
    required this.body,
    required this.ctaLabel,
    required this.onTap,
  });

  final String title;
  final String body;
  final String ctaLabel;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final ext = Theme.of(context).extension<AppThemeExtension>()!;
    final radius = BorderRadius.circular(AppRadius.card);

    return Container(
      decoration: BoxDecoration(
        borderRadius: radius,
        // `assets/workout.png` is the tiny generic "no image" placeholder
        // icon (see `SmartImage`'s fallback) — stretched full-bleed here it
        // read as a missing photo rather than the motivational banner this
        // is meant to be, so use an actual gym photo instead.
        image: const DecorationImage(
          image: AssetImage('assets/cardio.png'),
          fit: BoxFit.cover,
        ),
        border: Border.all(color: ext.glassBorder),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.22),
            blurRadius: 22,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              AppColors.seedInk.withValues(alpha: 0.30),
              AppColors.seedInk.withValues(alpha: 0.92),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              body,
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: Colors.white70),
            ),
            const SizedBox(height: 16),
            GestureDetector(
              onTap: onTap,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 22,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  gradient: ext.accentGradient,
                  borderRadius: BorderRadius.circular(999),
                  boxShadow: [
                    BoxShadow(
                      color: ext.accentGlow.withValues(alpha: 0.4),
                      blurRadius: 18,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Text(
                  ctaLabel,
                  style: TextStyle(
                    color: ext.onAccent,
                    fontWeight: FontWeight.w800,
                    fontSize: 13.5,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
