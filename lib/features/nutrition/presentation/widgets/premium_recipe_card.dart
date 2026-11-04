import 'package:flutter/material.dart';
import 'package:nabvera/core/localization/generated/app_localizations.dart';
import 'package:nabvera/core/theme/app_spacing.dart';
import 'package:nabvera/core/theme/app_theme_extension.dart';
import 'package:nabvera/core/widgets/pressable_scale.dart';
import 'package:nabvera/core/widgets/smart_image.dart';
import 'package:nabvera/features/nutrition/domain/nutrition_formatters.dart';
import 'package:nabvera/features/nutrition/presentation/widgets/nutrition_surface.dart';

/// Row height for horizontally scrolling lists of [PremiumRecipeCard]s. The
/// card's text can wrap (two-line name, wrapping meta), so a list that needs a
/// bounded height grows it with the user's font scale instead of clipping.
double recipeCardRowHeight(BuildContext context, {double base = 272}) {
  final scale = MediaQuery.textScalerOf(context).scale(14) / 14;
  return base + (scale - 1).clamp(0.0, 1.5) * 120;
}

/// Localized "{n}g protein" for a recipe's raw [grams], or null when the
/// recipe has no protein value — a missing value is never shown as 0.
String? recipeProteinLabel(AppLocalizations l10n, double? grams) {
  if (grams == null) return null;
  return l10n.nutritionRecipeProteinValue(formatNutritionNumber(grams));
}

/// Screen-reader label for a recipe's favorite toggle.
String recipeFavoriteLabel(
  AppLocalizations l10n,
  String name, {
  required bool isFavorite,
}) =>
    isFavorite
        ? l10n.nutritionFavoriteRemove(name)
        : l10n.nutritionFavoriteAdd(name);

/// Recipe card: dish photo, a name of up to two lines, then prep time,
/// calories and — only when the recipe has it — protein. Everything else
/// lives on the recipe page. The height follows the content (no fixed
/// height), so nothing is clipped at large font sizes.
///
/// The favorite button is its own 48dp tap target and never opens the recipe.
class PremiumRecipeCard extends StatelessWidget {
  const PremiumRecipeCard({
    super.key,
    required this.image,
    required this.name,
    required this.time,
    required this.calories,
    this.protein,
    this.isFavorite = false,
    this.onFavoriteTap,
    this.favoriteLabel,
    this.onTap,
    this.imageHeight,
  });

  final String image;
  final String name;
  final String time;
  final String calories;

  /// Pre-localized protein text (see [recipeProteinLabel]); null hides it.
  final String? protein;
  final bool isFavorite;

  /// Null hides the favorite button.
  final VoidCallback? onFavoriteTap;
  final String? favoriteLabel;
  final VoidCallback? onTap;

  /// Fixed photo height; null sizes the photo by aspect ratio instead.
  final double? imageHeight;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final ext = theme.extension<AppThemeExtension>()!;
    final animate = !MediaQuery.disableAnimationsOf(context);

    final photo = Stack(
      fit: StackFit.expand,
      children: [
        SmartImage(image),
        if (onFavoriteTap != null)
          PositionedDirectional(
            top: 0,
            end: 0,
            child: RecipeFavoriteButton(
              isFavorite: isFavorite,
              label: favoriteLabel ?? name,
              onTap: onFavoriteTap!,
            ),
          ),
      ],
    );

    return PressableScale(
      enabled: onTap != null && animate,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        child: Semantics(
          button: onTap != null,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(AppRadius.card),
                child:
                    imageHeight == null
                        ? AspectRatio(aspectRatio: 1.35, child: photo)
                        : SizedBox(
                          height: imageHeight,
                          width: double.infinity,
                          child: photo,
                        ),
              ),
              Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(4, 10, 4, 4),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      name,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.titleSmall?.copyWith(
                        color: ext.textPrimary,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 6),
                    RecipeMeta(
                      time: time,
                      calories: calories,
                      protein: protein,
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

/// Horizontal recipe row (image beside text) for vertical list contexts.
class PremiumRecipeListTile extends StatelessWidget {
  const PremiumRecipeListTile({
    super.key,
    required this.image,
    required this.name,
    required this.time,
    required this.calories,
    this.protein,
    this.isFavorite = false,
    this.onFavoriteTap,
    this.favoriteLabel,
    this.onTap,
  });

  final String image;
  final String name;
  final String time;
  final String calories;
  final String? protein;
  final bool isFavorite;
  final VoidCallback? onFavoriteTap;
  final String? favoriteLabel;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final ext = theme.extension<AppThemeExtension>()!;
    final animate = !MediaQuery.disableAnimationsOf(context);

    return PressableScale(
      enabled: onTap != null && animate,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        child: Semantics(
          button: onTap != null,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: SmartImage(image, width: 92, height: 92),
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
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: ext.textPrimary,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 8),
                    RecipeMeta(
                      time: time,
                      calories: calories,
                      protein: protein,
                    ),
                  ],
                ),
              ),
              if (onFavoriteTap != null)
                RecipeFavoriteButton(
                  isFavorite: isFavorite,
                  label: favoriteLabel ?? name,
                  onTap: onFavoriteTap!,
                  onPhoto: false,
                ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Compact "recipe of the day": a small photo beside the badge, name (up to
/// two lines) and the same meta as every other recipe card. Deliberately
/// short so today's nutrition stays the focus of the page.
class RecipeOfTheDayCard extends StatelessWidget {
  const RecipeOfTheDayCard({
    super.key,
    required this.image,
    required this.badge,
    required this.name,
    required this.time,
    required this.calories,
    this.protein,
    this.isFavorite = false,
    this.onFavoriteTap,
    this.favoriteLabel,
    this.onTap,
  });

  final String image;
  final String badge;
  final String name;
  final String time;
  final String calories;
  final String? protein;
  final bool isFavorite;
  final VoidCallback? onFavoriteTap;
  final String? favoriteLabel;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final ext = theme.extension<AppThemeExtension>()!;
    final animate = !MediaQuery.disableAnimationsOf(context);

    return PressableScale(
      enabled: onTap != null && animate,
      child: Semantics(
        button: onTap != null,
        child: NutritionSurface(
          onTap: onTap,
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(AppRadius.lg),
                child: SmartImage(image, width: 92, height: 92),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ExcludeSemantics(
                          child: Icon(
                            Icons.auto_awesome_rounded,
                            size: 14,
                            color: ext.accentGlow,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Flexible(
                          child: Text(
                            badge,
                            style: theme.textTheme.labelMedium?.copyWith(
                              color: ext.accentGlow,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      name,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.titleSmall?.copyWith(
                        color: ext.textPrimary,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 6),
                    RecipeMeta(
                      time: time,
                      calories: calories,
                      protein: protein,
                    ),
                  ],
                ),
              ),
              if (onFavoriteTap != null)
                RecipeFavoriteButton(
                  isFavorite: isFavorite,
                  label: favoriteLabel ?? name,
                  onTap: onFavoriteTap!,
                  onPhoto: false,
                ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Prep time, calories and (when known) protein, wrapping onto more lines
/// instead of overflowing.
class RecipeMeta extends StatelessWidget {
  const RecipeMeta({
    super.key,
    required this.time,
    required this.calories,
    this.protein,
  });

  final String time;
  final String calories;
  final String? protein;

  @override
  Widget build(BuildContext context) {
    final ext = Theme.of(context).extension<AppThemeExtension>()!;
    return Wrap(
      spacing: 12,
      runSpacing: 4,
      children: [
        _MetaItem(
          icon: Icons.timer_outlined,
          label: time,
          color: ext.textMuted,
        ),
        _MetaItem(
          icon: Icons.local_fire_department_rounded,
          label: calories,
          color: ext.textMuted,
        ),
        if (protein != null)
          _MetaItem(
            icon: Icons.egg_alt_outlined,
            label: protein!,
            color: ext.textMuted,
          ),
      ],
    );
  }
}

class _MetaItem extends StatelessWidget {
  const _MetaItem({
    required this.icon,
    required this.label,
    required this.color,
  });

  final IconData icon;
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        ExcludeSemantics(child: Icon(icon, size: 14, color: color)),
        const SizedBox(width: 4),
        Flexible(
          child: Text(
            label,
            style: Theme.of(
              context,
            ).textTheme.bodySmall?.copyWith(color: color),
          ),
        ),
      ],
    );
  }
}

/// Star toggle with a 48dp touch target. Absorbs its own tap, so pressing it
/// never opens the recipe behind it. [onPhoto] draws it as a dark disc for use
/// over a photo; otherwise it sits plainly on the surface.
class RecipeFavoriteButton extends StatelessWidget {
  const RecipeFavoriteButton({
    super.key,
    required this.isFavorite,
    required this.label,
    required this.onTap,
    this.onPhoto = true,
  });

  final bool isFavorite;

  /// Full screen-reader label, e.g. "Add Lentil soup to favorites".
  final String label;
  final VoidCallback onTap;
  final bool onPhoto;

  @override
  Widget build(BuildContext context) {
    final ext = Theme.of(context).extension<AppThemeExtension>()!;
    final iconColor =
        onPhoto
            ? (isFavorite ? const Color(0xFFFFD166) : Colors.white)
            : (isFavorite ? ext.accentGlow : ext.textMuted);

    return Semantics(
      container: true,
      button: true,
      toggled: isFavorite,
      label: label,
      excludeSemantics: true,
      onTap: onTap,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        child: SizedBox(
          width: kNutritionTapTarget,
          height: kNutritionTapTarget,
          child: Center(
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: onPhoto ? Colors.black.withValues(alpha: 0.45) : null,
                shape: BoxShape.circle,
              ),
              child: Padding(
                padding: const EdgeInsets.all(7),
                child: Icon(
                  isFavorite ? Icons.star_rounded : Icons.star_border_rounded,
                  color: iconColor,
                  size: 22,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
