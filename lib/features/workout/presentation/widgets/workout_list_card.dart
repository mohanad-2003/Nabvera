import 'package:nabvera/core/network/app_icons.dart';
import 'package:nabvera/core/theme/app_colors.dart';
import 'package:nabvera/core/theme/app_theme_extension.dart';
import 'package:nabvera/core/widgets/icon_stat.dart';
import 'package:nabvera/core/widgets/smart_image.dart';
import 'package:nabvera/features/workout/domain/workout_models.dart';
import 'package:flutter/material.dart';

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
    // No card container — sits directly on the page background; the list
    // separates items with a divider instead (see WorkoutPage's SliverList).
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: double.infinity,
        height: height,
        child: Row(
          children: [
            Flexible(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      item.name,
                      style: TextStyle(
                        color: ext.textPrimary,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        if (item.time != null)
                          IconStat(
                            icon: AppIcons.time,
                            label: item.time!,
                            color: ext.textMuted,
                          ),
                        const SizedBox(width: 10),
                        if (item.calories != null)
                          IconStat(
                            icon: AppIcons.calories,
                            label: item.calories!,
                            color: ext.textMuted,
                          ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    if (item.exercises != null)
                      IconStat(
                        icon: AppIcons.run,
                        label: item.exercises!,
                        color: ext.textMuted,
                      ),
                  ],
                ),
              ),
            ),
            Flexible(
              flex: 1,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(24),
                    child: SmartImage(
                      item.image,
                      width: double.infinity,
                      height: double.infinity,
                    ),
                  ),
                  Positioned(
                    top: 5,
                    right: 5,
                    child: GestureDetector(
                      onTap: onToggleFavorite,
                      child: Icon(
                        Icons.star_rate_rounded,
                        color:
                            item.isFavorite ? AppColors.seedLime : Colors.white,
                        size: 20,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
