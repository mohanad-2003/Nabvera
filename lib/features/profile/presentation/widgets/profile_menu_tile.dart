import 'package:flutter/material.dart';
import 'package:nabvera/core/theme/app_theme_extension.dart';
import 'package:nabvera/core/widgets/pressable_scale.dart';

/// Premium glass-row menu item used throughout the Profile screen —
/// replaces the plain [ListTile]-based `_ProfileTile` (flat violet circle,
/// no card surface) with the same glass-card + gradient-icon language used
/// across Workout/Nutrition/Community. Optional [subtitle] gives each item
/// a one-line description (e.g. "Update your personal information").
class ProfileMenuTile extends StatelessWidget {
  const ProfileMenuTile({
    super.key,
    required this.icon,
    required this.title,
    this.subtitle,
    this.onTap,
    this.iconColor,
    this.flat = false,
  });

  final IconData icon;
  final String title;
  final String? subtitle;
  final VoidCallback? onTap;
  final Color? iconColor;
  final bool flat;

  @override
  Widget build(BuildContext context) {
    final ext = Theme.of(context).extension<AppThemeExtension>()!;
    final theme = Theme.of(context);
    final accent = iconColor ?? theme.colorScheme.secondary;

    return PressableScale(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(flat ? 12 : 20),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          decoration:
              flat
                  ? null
                  : BoxDecoration(
                    color: ext.glassFill,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: ext.glassBorder),
                  ),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: accent.withValues(alpha: 0.14),
                ),
                child: Center(child: Icon(icon, color: accent, size: 22)),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: ext.textPrimary,
                      ),
                    ),
                    if (subtitle != null) ...[
                      const SizedBox(height: 2),
                      Text(
                        subtitle!,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(fontSize: 12, color: ext.textMuted),
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(width: 6),
              Icon(
                Directionality.of(context) == TextDirection.rtl
                    ? Icons.chevron_left_rounded
                    : Icons.chevron_right_rounded,
                color: ext.textMuted,
                size: 24,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
