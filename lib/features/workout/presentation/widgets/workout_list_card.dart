import 'package:flutter/material.dart';
import 'package:nabvera/core/localization/generated/app_localizations.dart';
import 'package:nabvera/core/theme/app_theme_extension.dart';
import 'package:nabvera/core/widgets/smart_image.dart';
import 'package:nabvera/features/workout/domain/workout_models.dart';

/// An intrinsic-height row; metadata wraps instead of clipping on small phones.
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
    return InkWell(
      onTap: onTap,
      child: ConstrainedBox(
        constraints: BoxConstraints(minHeight: height),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: SmartImage(item.image, width: 80, height: 88),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.name,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: ext.textPrimary,
                        fontWeight: FontWeight.w800,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 10,
                      runSpacing: 6,
                      children: [
                        if (item.time != null)
                          Text(
                            item.time!,
                            style: TextStyle(color: ext.textMuted),
                          ),
                        if (item.calories != null)
                          Text(
                            item.calories!,
                            style: TextStyle(color: ext.textMuted),
                          ),
                        if (item.exercises != null)
                          Text(
                            item.exercises!,
                            style: TextStyle(color: ext.textMuted),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
              IconButton(
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
    );
  }
}
