import 'package:flutter/material.dart';

import '../../../../core/theme/app_theme_extension.dart';

/// Compact rectangular filter card (All / Unread / Workouts / …). The
/// selected card gets the brand gradient; others stay softly outlined.
class NotificationCategoryChip extends StatelessWidget {
  const NotificationCategoryChip({
    super.key,
    required this.label,
    required this.selected,
    required this.onTap,
    this.icon,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    final ext = Theme.of(context).extension<AppThemeExtension>()!;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeOutCubic,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          gradient: selected ? ext.accentGradient : null,
          color: selected ? null : ext.glassFill,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: selected ? Colors.transparent : ext.glassBorder,
          ),
          boxShadow: [
            if (selected)
              BoxShadow(
                color: ext.accentGlow.withValues(alpha: 0.28),
                blurRadius: 16,
                offset: const Offset(0, 6),
              ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Icon(
                icon,
                size: 15,
                color: selected ? ext.onAccent : ext.textMuted,
              ),
              const SizedBox(width: 6),
            ],
            Text(
              label,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w800,
                color: selected ? ext.onAccent : ext.textPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
