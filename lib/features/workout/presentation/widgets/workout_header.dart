import 'package:nabvera/core/routing/app_routes.dart';
import 'package:nabvera/core/theme/app_theme_extension.dart';
import 'package:nabvera/features/workout/presentation/widgets/workout_surface.dart';
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
    this.showActions = true,
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

  /// Set to `false` to hide the search/notifications pair — both are one
  /// tap away from Home already, so a secondary screen that also needs
  /// its own header actions (e.g. Meal Plans' shopping-list/home buttons)
  /// ends up with too many icons crowding a title that's already sharing
  /// the row with a back button.
  final bool showActions;

  @override
  Widget build(BuildContext context) {
    final ext = Theme.of(context).extension<AppThemeExtension>()!;
    final canPop = showBack && context.canPop();
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        if (canPop)
          WorkoutBackButton(
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
        if (showActions) ...[
          const SizedBox(width: 10),
          _WorkoutHeaderIconButton(
            icon: Icons.search_rounded,
            onTap: () => context.push(AppRoutes.search),
          ),
          const SizedBox(width: 10),
          _WorkoutHeaderIconButton(
            icon: Icons.notifications_none_rounded,
            onTap: () => context.push(AppRoutes.notifications),
          ),
        ],
        if (showProfileAction) ...[
          const SizedBox(width: 10),
          _WorkoutHeaderIconButton(
            icon: Icons.person_outline_rounded,
            // `go`, not `push` — AppRoutes.profile is a bottom-nav shell
            // branch, not a standalone route; pushing it from a screen
            // outside the shell crashes (see top_icon_actions.dart's
            // matching fix). Not reachable today (no call site passes
            // showProfileAction: true yet), fixed pre-emptively so
            // whoever enables it next doesn't reintroduce the crash.
            onTap: () => context.go(AppRoutes.profile),
          ),
        ],
      ],
    );
  }
}

/// Header action with a full 44dp tap target but no card, fill, or border.
class _WorkoutHeaderIconButton extends StatelessWidget {
  const _WorkoutHeaderIconButton({required this.icon, required this.onTap});

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final ext = Theme.of(context).extension<AppThemeExtension>()!;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: SizedBox.square(
        dimension: 44,
        child: Icon(icon, color: ext.textPrimary, size: 22),
      ),
    );
  }
}
