import 'package:flutter/material.dart';
import 'package:nabvera/core/localization/generated/app_localizations.dart';
import 'package:nabvera/core/theme/app_spacing.dart';
import 'package:nabvera/core/theme/app_theme_extension.dart';
import 'package:nabvera/core/widgets/pressable_scale.dart';
import 'package:nabvera/core/widgets/smart_image.dart';
import 'package:nabvera/features/workout/domain/workout_models.dart';

/// A workout row rendered as a soft glass card: thumbnail, name, meta chips,
/// favorite toggle and a trailing affordance — an intrinsic-height row so
/// metadata wraps instead of clipping on small phones.
class WorkoutListCard extends StatelessWidget {
  const WorkoutListCard({
    super.key,
    required this.item,
    required this.onToggleFavorite,
    this.onTap,
    this.height = 117,
  });
  final WorkoutListItem item;
  final VoidCallback onToggleFavorite;
  final VoidCallback? onTap;
  final double height;

  @override
  Widget build(BuildContext context) {
    final ext = Theme.of(context).extension<AppThemeExtension>()!;
    return PressableScale(
      enabled: onTap != null,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadius.card),
        child: ConstrainedBox(
          constraints: BoxConstraints(minHeight: height),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(14),
                  child: SmartImage(item.image, width: 76, height: 88),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        item.name,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: ext.textPrimary,
                          fontWeight: FontWeight.w800,
                          fontSize: 15.5,
                          height: 1.2,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8,
                        runSpacing: 6,
                        children: [
                          if (item.time != null)
                            _MetaChip(
                              icon: Icons.schedule_rounded,
                              label: item.time!,
                              ext: ext,
                            ),
                          if (item.calories != null)
                            _MetaChip(
                              icon: Icons.local_fire_department_rounded,
                              label: item.calories!,
                              ext: ext,
                            ),
                          if (item.exercises != null)
                            _MetaChip(
                              icon: Icons.fitness_center_rounded,
                              label: item.exercises!,
                              ext: ext,
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
                IconButton(
                  visualDensity: VisualDensity.compact,
                  onPressed: onToggleFavorite,
                  tooltip: AppLocalizations.of(context).favoriteTitle,
                  icon: Icon(
                    item.isFavorite
                        ? Icons.star_rounded
                        : Icons.star_border_rounded,
                    color: item.isFavorite ? ext.accentGlow : ext.textMuted,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _MetaChip extends StatelessWidget {
  const _MetaChip({required this.icon, required this.label, required this.ext});

  final IconData icon;
  final String label;
  final AppThemeExtension ext;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: ext.accentGlow.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(AppRadius.pill),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: ext.accentGlow),
          const SizedBox(width: 4),
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: ext.textMuted,
              fontSize: 11.5,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
