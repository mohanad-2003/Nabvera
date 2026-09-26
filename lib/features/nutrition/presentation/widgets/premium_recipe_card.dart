import 'package:nabvera/core/theme/app_spacing.dart';
import 'package:nabvera/core/theme/app_theme_extension.dart';
import 'package:nabvera/core/widgets/pressable_scale.dart';
import 'package:nabvera/core/widgets/smart_image.dart';
import 'package:flutter/material.dart';

/// Premium vertical recipe card: large image with a glass gradient overlay,
/// a floating favorite button, an optional difficulty badge and rating
/// chip over the photo, then title + macro chips underneath. Used for both
/// grid layouts (Nutrition home) and horizontal-scroll rows (Meal Ideas
/// "Recommended"), replacing the several near-duplicate card widgets that
/// used to live in each page.
class PremiumRecipeCard extends StatelessWidget {
  const PremiumRecipeCard({
    super.key,
    required this.image,
    required this.name,
    required this.time,
    required this.calories,
    this.subtitle,
    this.protein,
    this.carbs,
    this.fat,
    this.rating,
    this.difficulty,
    this.isFavorite = false,
    this.onFavoriteTap,
    this.onTap,
    this.imageHeight = 130,
  });

  final String image;
  final String name;
  final String time;
  final String calories;
  final String? subtitle;
  final String? protein;
  final String? carbs;
  final String? fat;
  final double? rating;
  final String? difficulty;
  final bool isFavorite;
  final VoidCallback? onFavoriteTap;
  final VoidCallback? onTap;
  final double imageHeight;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final ext = theme.extension<AppThemeExtension>()!;

    // No wrapping card box — just a rounded photo with its stats sitting
    // plainly underneath, directly on the page background.
    return PressableScale(
      enabled: onTap != null,
      child: GestureDetector(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(AppRadius.card),
              child: SizedBox(
                height: imageHeight,
                width: double.infinity,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    SmartImage(image),
                    Positioned.fill(
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Colors.transparent,
                              Colors.black.withValues(alpha: 0.45),
                            ],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                          ),
                        ),
                      ),
                    ),
                    if (difficulty != null)
                      PositionedDirectional(
                        top: 8,
                        start: 8,
                        child: _Chip(
                          label: difficulty!,
                          background: Colors.black.withValues(alpha: 0.4),
                          foreground: Colors.white,
                        ),
                      ),
                    PositionedDirectional(
                      top: 6,
                      end: 6,
                      child: GestureDetector(
                        onTap: onFavoriteTap,
                        child: Container(
                          width: 30,
                          height: 30,
                          decoration: BoxDecoration(
                            color: Colors.black.withValues(alpha: 0.36),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            isFavorite
                                ? Icons.star_rounded
                                : Icons.star_border_rounded,
                            color: isFavorite ? ext.accentGlow : Colors.white,
                            size: 18,
                          ),
                        ),
                      ),
                    ),
                    if (rating != null)
                      PositionedDirectional(
                        bottom: 8,
                        start: 8,
                        child: _Chip(
                          label: rating!.toStringAsFixed(1),
                          background: Colors.black.withValues(alpha: 0.4),
                          foreground: Colors.white,
                          icon: Icons.star_rounded,
                          iconColor: ext.accentGlow,
                        ),
                      ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 10, 10, 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: ext.textPrimary,
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  if (subtitle != null && subtitle!.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Text(
                      subtitle!,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(color: ext.textMuted, fontSize: 11),
                    ),
                  ],
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(
                        Icons.timer_outlined,
                        size: 13,
                        color: ext.textMuted,
                      ),
                      const SizedBox(width: 4),
                      Flexible(
                        child: Text(
                          time,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(fontSize: 11, color: ext.textMuted),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Icon(
                        Icons.local_fire_department_rounded,
                        size: 13,
                        color: theme.colorScheme.secondary,
                      ),
                      const SizedBox(width: 4),
                      Flexible(
                        child: Text(
                          calories,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(fontSize: 11, color: ext.textMuted),
                        ),
                      ),
                    ],
                  ),
                  if (protein != null || carbs != null || fat != null) ...[
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 6,
                      runSpacing: 6,
                      children: [
                        if (protein != null)
                          _MacroTag(label: 'P', value: protein!),
                        if (carbs != null) _MacroTag(label: 'C', value: carbs!),
                        if (fat != null) _MacroTag(label: 'F', value: fat!),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Horizontal recipe row (image beside text) for vertical list contexts —
/// the "Recipes for you" style list.
class PremiumRecipeListTile extends StatelessWidget {
  const PremiumRecipeListTile({
    super.key,
    required this.image,
    required this.name,
    required this.time,
    required this.calories,
    this.rating,
    this.difficulty,
    this.isFavorite = false,
    this.onFavoriteTap,
    this.onTap,
  });

  final String image;
  final String name;
  final String time;
  final String calories;
  final double? rating;
  final String? difficulty;
  final bool isFavorite;
  final VoidCallback? onFavoriteTap;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final ext = theme.extension<AppThemeExtension>()!;

    // No card container — the list separates rows with a divider instead
    // (see the pages that build this tile).
    return PressableScale(
      enabled: onTap != null,
      child: GestureDetector(
        onTap: onTap,
        child: Row(
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: SmartImage(image, width: 92, height: 92),
                ),
                PositionedDirectional(
                  top: 6,
                  end: 6,
                  child: GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: onFavoriteTap,
                    child: Icon(
                      isFavorite
                          ? Icons.star_rounded
                          : Icons.star_border_rounded,
                      color: isFavorite ? ext.danger : Colors.white,
                      size: 20,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    name,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: ext.textPrimary,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(
                        Icons.timer_outlined,
                        size: 15,
                        color: ext.textMuted,
                      ),
                      const SizedBox(width: 5),
                      Flexible(
                        child: Text(
                          time,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(fontSize: 12, color: ext.textMuted),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Icon(
                        Icons.local_fire_department_rounded,
                        size: 15,
                        color: theme.colorScheme.secondary,
                      ),
                      const SizedBox(width: 5),
                      Flexible(
                        child: Text(
                          calories,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(fontSize: 12, color: ext.textMuted),
                        ),
                      ),
                      if (rating != null) ...[
                        const SizedBox(width: 12),
                        Icon(
                          Icons.star_rounded,
                          size: 15,
                          color: ext.accentGlow,
                        ),
                        const SizedBox(width: 3),
                        Text(
                          rating!.toStringAsFixed(1),
                          style: TextStyle(fontSize: 12, color: ext.textMuted),
                        ),
                      ],
                    ],
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

class _MacroTag extends StatelessWidget {
  const _MacroTag({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final ext = Theme.of(context).extension<AppThemeExtension>()!;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
      decoration: BoxDecoration(
        color: ext.glassBorder,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        '$label $value',
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w800,
          color: ext.textMuted,
        ),
      ),
    );
  }
}

class _Chip extends StatelessWidget {
  const _Chip({
    required this.label,
    required this.background,
    required this.foreground,
    this.icon,
    this.iconColor,
  });

  final String label;
  final Color background;
  final Color foreground;
  final IconData? icon;
  final Color? iconColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 12, color: iconColor ?? foreground),
            const SizedBox(width: 3),
          ],
          Text(
            label,
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w800,
              color: foreground,
            ),
          ),
        ],
      ),
    );
  }
}
