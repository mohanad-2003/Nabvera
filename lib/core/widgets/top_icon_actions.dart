import 'package:fitness_app/core/routing/app_routes.dart';
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
          onPressed: () => context.push(AppRoutes.profile),
          icon: Icon(Icons.person, color: iconColor),
        ),
      ],
    );
  }
}
