import 'package:flutter/material.dart';

import 'package:nabvera/core/theme/app_theme_extension.dart';

/// Premium capsule page indicator: the active dot stretches into a
/// gradient-filled pill while inactive dots stay small, neutral circles.
class OnboardingPageIndicator extends StatelessWidget {
  const OnboardingPageIndicator({
    super.key,
    required this.count,
    required this.currentIndex,
  });

  final int count;
  final int currentIndex;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final ext = theme.extension<AppThemeExtension>()!;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (var i = 0; i < count; i++)
          AnimatedContainer(
            duration: const Duration(milliseconds: 320),
            curve: Curves.easeOutCubic,
            margin: const EdgeInsetsDirectional.only(end: 8),
            width: i == currentIndex ? 30 : 8,
            height: 8,
            decoration: BoxDecoration(
              gradient: i == currentIndex ? ext.accentGradient : null,
              color:
                  i == currentIndex
                      ? null
                      : theme.colorScheme.surfaceContainerHighest.withValues(
                        alpha: 0.4,
                      ),
              borderRadius: BorderRadius.circular(999),
            ),
          ),
      ],
    );
  }
}
