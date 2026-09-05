import 'package:nabvera/core/routing/app_routes.dart';
import 'package:nabvera/core/theme/app_theme_extension.dart';
import 'package:nabvera/core/widgets/premium_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Replaces the legacy `HeaderWorkout` (lib/view/header_workout.dart).
class WorkoutHeader extends StatelessWidget {
  const WorkoutHeader({
    super.key,
    required this.title,
    this.subtitle,
    this.showProfileAction = false,
    this.showBack = true,
  });

  final String title;

  /// Optional line under the title (e.g. "Tap any exercise to preview
  /// details and start").
  final String? subtitle;

  /// Adds a third circular action (profile) after search/notifications —
  /// opt-in per screen so existing headers stay unchanged elsewhere.
  final bool showProfileAction;

  /// Set to `false` on bottom-nav tab roots (Workout, Nutrition) — they're
  /// reached via the nav bar, never pushed, so `context.canPop()` is
  /// meaningless there and a back arrow with nowhere to go is just noise.
  final bool showBack;

  @override
  Widget build(BuildContext context) {
    final ext = Theme.of(context).extension<AppThemeExtension>()!;
    final canPop = showBack && context.canPop();
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        if (canPop)
          PremiumIconButton(
            icon: Icons.arrow_back_ios_new_rounded,
            onTap: () => context.canPop() ? context.pop() : null,
          ),
        if (canPop) const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: ext.textPrimary,
                  fontWeight: FontWeight.w900,
                ),
              ),
              if (subtitle != null) ...[
                const SizedBox(height: 4),
                Text(
                  subtitle!,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.copyWith(color: ext.textMuted),
                ),
              ],
            ],
          ),
        ),
        const SizedBox(width: 10),
        PremiumIconButton(
          icon: Icons.search_rounded,
          onTap: () => context.push(AppRoutes.search),
        ),
        const SizedBox(width: 10),
        PremiumIconButton(
          icon: Icons.notifications_none_rounded,
          onTap: () => context.push(AppRoutes.notifications),
        ),
        if (showProfileAction) ...[
          const SizedBox(width: 10),
          PremiumIconButton(
            icon: Icons.person_outline_rounded,
            onTap: () => context.push(AppRoutes.profile),
          ),
        ],
      ],
    );
  }
}
