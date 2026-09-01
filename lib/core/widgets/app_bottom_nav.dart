import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../localization/generated/app_localizations.dart';
import '../theme/app_colors.dart';
import '../theme/app_radius_shadows.dart';
import '../theme/app_spacing.dart';

class AppBottomNavItem {
  const AppBottomNavItem({
    required this.image,
    required this.fallbackIcon,
    required this.label,
  });

  final String image;
  final IconData fallbackIcon;
  final String label;
}

/// Premium floating bottom navigation bar: a frosted-glass pill
/// (BackdropFilter blur over the page behind it), a soft glow indicator
/// that slides to the active tab, always-visible micro-labels under every
/// icon (no layout jumps between tabs), and light haptic feedback on tap.
/// Intentionally not a [BottomNavigationBar]/[NavigationBar] — those can't
/// give this floating pill look or the sliding-indicator animation.
class AppBottomNav extends StatelessWidget {
  const AppBottomNav({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  final int currentIndex;
  final ValueChanged<int> onTap;

  List<AppBottomNavItem> _items(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return [
      AppBottomNavItem(
        image: 'assets/bottom/home.png',
        fallbackIcon: Icons.home_rounded,
        label: l10n.navHome,
      ),
      AppBottomNavItem(
        image: 'assets/bottom/workout.png',
        fallbackIcon: Icons.fitness_center_rounded,
        label: l10n.navWorkout,
      ),
      AppBottomNavItem(
        image: 'assets/bottom/nutrition.png',
        fallbackIcon: Icons.restaurant_rounded,
        label: l10n.navNutrition,
      ),
      AppBottomNavItem(
        image: 'assets/bottom/community.png',
        fallbackIcon: Icons.groups_rounded,
        label: l10n.navCommunity,
      ),
      AppBottomNavItem(
        image: 'assets/bottom/profile.png',
        fallbackIcon: Icons.person_rounded,
        label: l10n.navProfile,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final items = _items(context);

    return SafeArea(
      minimum: const EdgeInsets.fromLTRB(
        AppSpacing.lg,
        0,
        AppSpacing.lg,
        AppSpacing.md,
      ),
      // The shadow must live outside the ClipRRect, otherwise the blur
      // clip would cut it off.
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppRadius.pill),
          boxShadow: AppShadows.floating(theme.brightness),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(AppRadius.pill),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
            child: Container(
              height: 66,
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
              decoration: BoxDecoration(
                color: AppColors.graphite.withValues(alpha: 0.80),
                borderRadius: BorderRadius.circular(AppRadius.pill),
                border: Border.all(color: Colors.white.withValues(alpha: 0.10)),
              ),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final itemWidth = constraints.maxWidth / items.length;
                  return Stack(
                    children: [
                      // Soft radial glow that slides behind the active tab.
                      AnimatedPositionedDirectional(
                        duration: const Duration(milliseconds: 320),
                        curve: Curves.easeOutCubic,
                        start: currentIndex * itemWidth,
                        top: 0,
                        bottom: 0,
                        width: itemWidth,
                        child: Center(
                          child: Container(
                            width: 52,
                            height: 52,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: RadialGradient(
                                colors: [
                                  AppColors.seedLime.withValues(alpha: 0.22),
                                  AppColors.seedLime.withValues(alpha: 0),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      Row(
                        children: [
                          for (var i = 0; i < items.length; i++)
                            _NavItemButton(
                              item: items[i],
                              selected: i == currentIndex,
                              onTap: () {
                                HapticFeedback.selectionClick();
                                onTap(i);
                              },
                            ),
                        ],
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _NavItemButton extends StatelessWidget {
  const _NavItemButton({
    required this.item,
    required this.selected,
    required this.onTap,
  });

  final AppBottomNavItem item;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color =
        selected ? AppColors.seedLime : Colors.white.withValues(alpha: 0.55);

    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadius.pill),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 180),
              transitionBuilder: (child, animation) => ScaleTransition(
                scale: Tween<double>(begin: 0.84, end: 1).animate(animation),
                child: FadeTransition(opacity: animation, child: child),
              ),
              child: Opacity(
                key: ValueKey(selected),
                opacity: selected ? 1 : 0.58,
                child: Image.asset(
                  item.image,
                  width: 25,
                  height: 25,
                  fit: BoxFit.contain,
                  errorBuilder: (_, _, _) => Icon(
                    item.fallbackIcon,
                    color: color,
                    size: 23,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 3),
            AnimatedDefaultTextStyle(
              duration: const Duration(milliseconds: 180),
              style: TextStyle(
                fontSize: 10,
                fontWeight: selected ? FontWeight.w800 : FontWeight.w600,
                color: color,
              ),
              child: Text(
                item.label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
