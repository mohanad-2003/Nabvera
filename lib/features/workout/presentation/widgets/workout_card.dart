import 'package:fitness_app/core/network/app_icons.dart';
import 'package:fitness_app/core/theme/app_colors.dart';
import 'package:fitness_app/core/theme/app_spacing.dart';
import 'package:fitness_app/core/theme/app_theme_extension.dart';
import 'package:fitness_app/core/widgets/icon_stat.dart';
import 'package:fitness_app/core/widgets/pressable_scale.dart';
import 'package:fitness_app/core/widgets/smart_image.dart';
import 'package:flutter/material.dart';

/// Premium workout tile: large image, dark gradient scrim, favorite button,
/// floating neon play button, title + reps/time stats. Replaces the legacy
/// `RoutineGridCard`. Shared by the routine grid and the create-routine grid
/// (via [actionIcon]/[actionColor] overrides).
class WorkoutCard extends StatelessWidget {
  const WorkoutCard({
    super.key,
    required this.image,
    required this.title,
    required this.time,
    required this.reps,
    required this.isFavorite,
    required this.onFavoriteTap,
    this.actionIcon = Icons.play_arrow_rounded,
    this.actionColor,
    this.onActionTap,
    this.onTap,
  });

  final String image;
  final String title;
  final String time;
  final String reps;
  final bool isFavorite;
  final VoidCallback onFavoriteTap;
  final IconData actionIcon;
  final Color? actionColor;
  final VoidCallback? onActionTap;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final ext = Theme.of(context).extension<AppThemeExtension>()!;
    final radius = BorderRadius.circular(AppRadius.card);
    final accent = actionColor ?? AppColors.seedLime;

    return PressableScale(
      child: InkWell(
        onTap: onTap,
        borderRadius: radius,
        child: Container(
          decoration: BoxDecoration(
            color: ext.glassFill,
            borderRadius: radius,
            border: Border.all(color: ext.glassBorder),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.22),
                blurRadius: 22,
                offset: const Offset(0, 12),
              ),
            ],
          ),
          clipBehavior: Clip.antiAlias,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Hero(
                      tag: image,
                      child: SmartImage(image),
                    ),
                    DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Colors.black.withValues(alpha: 0.05),
                            AppColors.seedInk.withValues(alpha: 0.78),
                          ],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                      ),
                    ),
                    Positioned(
                      top: 8,
                      right: 8,
                      child: _CircleAction(
                        icon: Icons.star_rounded,
                        color: isFavorite ? AppColors.seedLime : Colors.white,
                        background: Colors.black.withValues(alpha: 0.32),
                        onTap: onFavoriteTap,
                      ),
                    ),
                    if (onActionTap != null)
                      Positioned(
                        bottom: 8,
                        right: 8,
                        child: _FloatingActionCircle(
                          icon: actionIcon,
                          color: accent,
                          onTap: onActionTap!,
                        ),
                      ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        color: ext.textPrimary,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        IconStat(
                          icon: AppIcons.calories,
                          label: reps,
                          color: ext.textMuted,
                          fontSize: 11,
                        ),
                        const SizedBox(width: 8),
                        IconStat(
                          icon: AppIcons.time,
                          label: time,
                          color: ext.textMuted,
                          fontSize: 11,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CircleAction extends StatelessWidget {
  const _CircleAction({
    required this.icon,
    required this.color,
    required this.background,
    required this.onTap,
  });

  final IconData icon;
  final Color color;
  final Color background;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 34,
        height: 34,
        decoration: BoxDecoration(
          color: background,
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white.withValues(alpha: 0.14)),
        ),
        child: Icon(icon, color: color, size: 19),
      ),
    );
  }
}

class _FloatingActionCircle extends StatelessWidget {
  const _FloatingActionCircle({
    required this.icon,
    required this.color,
    required this.onTap,
  });

  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: color.withValues(alpha: 0.55),
              blurRadius: 16,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Icon(icon, color: AppColors.seedInk, size: 22),
      ),
    );
  }
}
