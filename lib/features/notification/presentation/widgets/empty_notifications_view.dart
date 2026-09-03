import 'package:flutter/material.dart';

import '../../../../core/theme/app_theme_extension.dart';
import '../../../../core/widgets/primary_button.dart';

/// Fitness-themed empty state: a layered icon illustration (concentric
/// rings + gradient medallion, matching the app's onboarding hero style)
/// plus a motivational message and a Start Workout CTA.
class EmptyNotificationsView extends StatelessWidget {
  const EmptyNotificationsView({
    super.key,
    required this.title,
    required this.body,
    required this.ctaLabel,
    required this.onStartWorkout,
  });

  final String title;
  final String body;
  final String ctaLabel;
  final VoidCallback onStartWorkout;

  @override
  Widget build(BuildContext context) {
    final ext = Theme.of(context).extension<AppThemeExtension>()!;

    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: 180,
              width: 180,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    width: 180,
                    height: 180,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: ext.glassBorder),
                    ),
                  ),
                  Container(
                    width: 132,
                    height: 132,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: ext.glassBorder),
                    ),
                  ),
                  Container(
                    width: 92,
                    height: 92,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: ext.accentGradient,
                      boxShadow: [
                        BoxShadow(
                          color: ext.accentGlow.withValues(alpha: 0.32),
                          blurRadius: 30,
                          offset: const Offset(0, 12),
                        ),
                      ],
                    ),
                    child: Icon(
                      Icons.notifications_none_rounded,
                      color: ext.onAccent,
                      size: 40,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 28),
            Text(
              title,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: ext.textPrimary,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              body,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: ext.textMuted,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 26),
            PrimaryButton(
              label: ctaLabel,
              icon: Icons.play_arrow_rounded,
              onPressed: onStartWorkout,
            ),
          ],
        ),
      ),
    );
  }
}
