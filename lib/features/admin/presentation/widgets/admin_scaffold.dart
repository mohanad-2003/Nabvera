import 'package:nabvera/core/localization/generated/app_localizations.dart';
import 'package:nabvera/core/routing/app_routes.dart';
import 'package:nabvera/core/theme/app_theme_extension.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// The seven Admin console destinations — one per top-level page. Order
/// here is also nav order (bottom nav's condensed set, the "More" hub, and
/// the wide-screen rail all read from this single list).
enum AdminDestination {
  dashboard,
  workouts,
  exercises,
  recipes,
  articles,
  challenges,
  profile,
}

extension on AdminDestination {
  String route(BuildContext context) => switch (this) {
    AdminDestination.dashboard => AppRoutes.adminDashboard,
    AdminDestination.workouts => AppRoutes.adminWorkouts,
    AdminDestination.exercises => AppRoutes.adminExercises,
    AdminDestination.recipes => AppRoutes.adminRecipes,
    AdminDestination.articles => AppRoutes.adminArticles,
    AdminDestination.challenges => AppRoutes.adminChallenges,
    AdminDestination.profile => AppRoutes.adminProfile,
  };

  IconData get icon => switch (this) {
    AdminDestination.dashboard => Icons.dashboard_outlined,
    AdminDestination.workouts => Icons.fitness_center_outlined,
    AdminDestination.exercises => Icons.sports_gymnastics_outlined,
    AdminDestination.recipes => Icons.restaurant_menu_outlined,
    AdminDestination.articles => Icons.article_outlined,
    AdminDestination.challenges => Icons.emoji_events_outlined,
    AdminDestination.profile => Icons.admin_panel_settings_outlined,
  };

  String label(AppLocalizations l10n) => switch (this) {
    AdminDestination.dashboard => l10n.adminNavDashboard,
    AdminDestination.workouts => l10n.adminNavWorkouts,
    AdminDestination.exercises => l10n.adminNavExercises,
    AdminDestination.recipes => l10n.adminNavRecipes,
    AdminDestination.articles => l10n.adminNavArticles,
    AdminDestination.challenges => l10n.adminNavChallenges,
    AdminDestination.profile => l10n.adminNavProfile,
  };
}

/// The four destinations grouped under the mobile bottom nav's "More" tab
/// — kept off the condensed bar itself so it stays a short, thumb-friendly
/// row, per the design brief's "short bottom nav or a More list".
const _kMoreGroup = {
  AdminDestination.exercises,
  AdminDestination.recipes,
  AdminDestination.articles,
  AdminDestination.challenges,
};

/// Width past which the Admin console switches from a bottom nav to a
/// side [NavigationRail] — matches common tablet/desktop breakpoints.
const _kWideBreakpoint = 700.0;

/// Shared chrome for every Admin console page: a condensed bottom nav (plus
/// a "More" hub for the four content types) on narrow screens, and a full
/// [NavigationRail] on wide ones — kept structurally separate from
/// [AppBottomNav]/the user shell entirely, so nothing here can affect the
/// ordinary user experience.
class AdminScaffold extends StatelessWidget {
  const AdminScaffold({
    super.key,
    required this.currentTab,
    required this.child,
  });

  final AdminDestination currentTab;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final ext = Theme.of(context).extension<AppThemeExtension>()!;
    final l10n = AppLocalizations.of(context);

    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide = constraints.maxWidth >= _kWideBreakpoint;
        final body = DecoratedBox(
          decoration: BoxDecoration(gradient: ext.backgroundGradient),
          child: SafeArea(child: child),
        );

        if (isWide) {
          return Scaffold(
            body: Row(
              children: [
                NavigationRail(
                  backgroundColor: ext.cardColor,
                  selectedIndex: AdminDestination.values.indexOf(currentTab),
                  onDestinationSelected:
                      (index) => _goTo(context, AdminDestination.values[index]),
                  labelType: NavigationRailLabelType.all,
                  leading: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    child: Icon(
                      Icons.shield_moon_outlined,
                      color: ext.accentGlow,
                      size: 28,
                    ),
                  ),
                  destinations: [
                    for (final destination in AdminDestination.values)
                      NavigationRailDestination(
                        icon: Icon(destination.icon),
                        label: Text(destination.label(l10n)),
                      ),
                  ],
                ),
                VerticalDivider(width: 1, color: ext.glassBorder),
                Expanded(child: body),
              ],
            ),
          );
        }

        final mobileTabs = [
          AdminDestination.dashboard,
          AdminDestination.workouts,
          null, // "More" — not a single destination, see _kMoreGroup.
          AdminDestination.profile,
        ];
        final selectedMobileIndex =
            _kMoreGroup.contains(currentTab)
                ? 2
                : mobileTabs.indexOf(currentTab);

        return Scaffold(
          body: body,
          bottomNavigationBar: NavigationBar(
            backgroundColor: ext.cardColor,
            selectedIndex: selectedMobileIndex < 0 ? 0 : selectedMobileIndex,
            onDestinationSelected: (index) {
              final destination = mobileTabs[index];
              if (destination == null) {
                if (!_kMoreGroup.contains(currentTab)) {
                  context.push(AppRoutes.adminMore);
                }
                return;
              }
              _goTo(context, destination);
            },
            destinations: [
              NavigationDestination(
                icon: Icon(AdminDestination.dashboard.icon),
                label: l10n.adminNavDashboard,
              ),
              NavigationDestination(
                icon: Icon(AdminDestination.workouts.icon),
                label: l10n.adminNavWorkouts,
              ),
              NavigationDestination(
                icon: const Icon(Icons.apps_rounded),
                label: l10n.adminNavMore,
              ),
              NavigationDestination(
                icon: Icon(AdminDestination.profile.icon),
                label: l10n.adminNavProfile,
              ),
            ],
          ),
        );
      },
    );
  }

  void _goTo(BuildContext context, AdminDestination destination) {
    if (destination == currentTab) return;
    context.go(destination.route(context));
  }
}
