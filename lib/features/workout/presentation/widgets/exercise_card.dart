import 'package:fitness_app/core/responsive/app_responsive.dart';
import 'package:fitness_app/core/theme/app_colors.dart';
import 'package:fitness_app/core/theme/app_spacing.dart';
import 'package:fitness_app/core/theme/app_theme_extension.dart';
import 'package:fitness_app/core/widgets/pressable_scale.dart';
import 'package:fitness_app/core/widgets/smart_image.dart';
import 'package:flutter/material.dart';

/// Premium row card for the "Choose Exercises" library: thumbnail, name,
/// muscle group + sets/reps, favorite star, and an add/remove circle.
class ExerciseCard extends StatelessWidget {
  const ExerciseCard({
    super.key,
    required this.image,
    required this.name,
    required this.muscleGroup,
    required this.setsRepsLabel,
    required this.isFavorite,
    required this.isAdded,
    required this.onFavoriteTap,
    required this.onAddTap,
  });

  final String image;
  final String name;
  final String muscleGroup;
  final String setsRepsLabel;
  final bool isFavorite;
  final bool isAdded;
  final VoidCallback onFavoriteTap;
  final VoidCallback onAddTap;

  @override
  Widget build(BuildContext context) {
    final ext = Theme.of(context).extension<AppThemeExtension>()!;
    final radius = BorderRadius.circular(AppRadius.card);

    return PressableScale(
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: isAdded ? ext.cardColor : ext.glassFill,
          borderRadius: radius,
          border: Border.all(
            color:
                isAdded
                    ? AppColors.seedLime.withValues(alpha: 0.5)
                    : ext.glassBorder,
          ),
          boxShadow: isAdded ? ext.cardShadow : const [],
        ),
        child: Row(
          children: [
            ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: context.responsive(
                  compact: 56.0,
                  standard: 64.0,
                  medium: 72.0,
                  expanded: 80.0,
                ),
              ),
              child: AspectRatio(
                aspectRatio: 1,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(14),
                  child: SmartImage(image),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: ext.textPrimary,
                      fontWeight: FontWeight.w800,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    muscleGroup,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(color: ext.accentGlow, fontSize: 11.5),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    setsRepsLabel,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(color: ext.textMuted, fontSize: 11.5),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            GestureDetector(
              onTap: onFavoriteTap,
              child: Icon(
                isFavorite ? Icons.star_rounded : Icons.star_border_rounded,
                color: isFavorite ? AppColors.seedLime : ext.textMuted,
                size: 22,
              ),
            ),
            const SizedBox(width: 6),
            GestureDetector(
              onTap: onAddTap,
              child: Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: isAdded ? AppColors.seedLime : ext.glassFill,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isAdded ? Colors.transparent : ext.glassBorder,
                  ),
                ),
                child: Icon(
                  isAdded ? Icons.check_rounded : Icons.add_rounded,
                  color: isAdded ? AppColors.seedInk : ext.textPrimary,
                  size: 18,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
