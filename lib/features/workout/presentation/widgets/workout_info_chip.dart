import 'package:flutter/material.dart';
import 'package:nabvera/core/theme/app_theme_extension.dart';

/// Small icon+label pill used across workout cards (duration, calories,
/// difficulty). Replaces the ad-hoc `Image.asset` + `Text` rows that used
/// to be duplicated inline in the hero and grid cards.
class WorkoutInfoChip extends StatelessWidget {
  const WorkoutInfoChip({
    super.key,
    required this.icon,
    required this.label,
    this.iconColor,
    this.textColor,
    this.background,
  });

  final IconData icon;
  final String label;
  final Color? iconColor;
  final Color? textColor;
  final Color? background;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: background ?? Colors.black.withValues(alpha: 0.38),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: iconColor ?? Colors.white),
          const SizedBox(width: 5),
          Flexible(
            child: Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: textColor ?? Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Maps a difficulty/level label to a semantic accent color, shared by the
/// hero card and grid cards so a level always reads the same color
/// regardless of which card renders it.
Color workoutDifficultyColor(String level, AppThemeExtension ext) {
  final normalized = level.toLowerCase();
  if (normalized.contains('advance') || normalized.contains('hard')) {
    return ext.danger;
  }
  if (normalized.contains('inter') || normalized.contains('medium')) {
    return ext.warning;
  }
  return ext.success;
}
