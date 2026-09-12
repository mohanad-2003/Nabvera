import 'package:nabvera/core/routing/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// The search/notifications/profile icon trio duplicated across ~6 legacy
/// screens (home, search, header_workout, favorite, meal_plane, challenge).
class TopIconActions extends StatelessWidget {
  const TopIconActions({super.key, this.color});

  final Color? color;

  @override
  Widget build(BuildContext context) {
    final iconColor = color ?? Theme.of(context).colorScheme.primary;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          onPressed: () => context.push(AppRoutes.search),
          icon: Icon(Icons.search, color: iconColor),
        ),
        IconButton(
          onPressed: () => context.push(AppRoutes.notifications),
          icon: Icon(Icons.notifications, color: iconColor),
        ),
        IconButton(
          // `go`, not `push`: AppRoutes.profile is a branch of the bottom
          // StatefulShellRoute (app_router.dart), not a standalone route.
          // `push`ing it from a screen that lives outside the shell (e.g.
          // ChallengePage, a top-level sibling route) crashes — go_router
          // can't insert a shell branch as a single pushed page onto the
          // root Navigator. `go` re-resolves the full location, correctly
          // entering the shell, and matches how tapping the Profile tab
          // itself behaves (switches to it, doesn't stack).
          onPressed: () => context.go(AppRoutes.profile),
          icon: Icon(Icons.person, color: iconColor),
        ),
      ],
    );
  }
}
