import 'package:nabvera/core/localization/generated/app_localizations.dart';
import 'package:nabvera/core/theme/app_spacing.dart';
import 'package:nabvera/core/theme/app_theme_extension.dart';
import 'package:nabvera/core/widgets/pressable_scale.dart';
import 'package:nabvera/core/widgets/smart_image.dart';
import 'package:nabvera/features/nutrition/domain/nutrition_models.dart';
import 'package:flutter/material.dart';

import 'premium_recipe_card.dart';

/// Renders a meal-idea section (hero banner + Recommended row + Recipes
/// list). Replaces the legacy `CommonMealIdeaPage`
/// (lib/view/common_mealidea_page.dart), reusing [MealDetail] instead of
/// two separate ad-hoc item classes.
class MealIdeaSectionView extends StatelessWidget {
  const MealIdeaSectionView({
    super.key,
    required this.section,
    required this.isFavorite,
    required this.onToggleFavorite,
    required this.onOpenDetail,
  });

  final MealIdeaSection section;
  final bool Function(String? key) isFavorite;
  final void Function(String? key) onToggleFavorite;
  final void Function(MealDetail meal, String tag) onOpenDetail;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final ext = Theme.of(context).extension<AppThemeExtension>()!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: _TopRecipeHero(
            meal: section.top,
            badge: l10n.nutritionRecipeOfTheDay,
            isFavorite: isFavorite(section.top.favoriteKey),
            onFavoriteTap: () => onToggleFavorite(section.top.favoriteKey),
            onTap:
                () => onOpenDetail(section.top, l10n.nutritionRecipeOfTheDay),
          ),
        ),
        const SizedBox(height: 22),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (section.recommended.isNotEmpty) ...[
                Text(
                  l10n.nutritionRecommended,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: Theme.of(context).colorScheme.primary,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  height: 246,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: section.recommended.length,
                    separatorBuilder: (_, _) => const SizedBox(width: 12),
                    itemBuilder: (context, index) {
                      final item = section.recommended[index];
                      return SizedBox(
                        width: 190,
                        child: PremiumRecipeCard(
                          image: item.image,
                          name: item.name,
                          time: recipeMinutesLabel(
                            l10n,
                            item.prepTimeMinutes,
                            item.time,
                          ),
                          calories: recipeCaloriesLabel(
                            l10n,
                            item.caloriesValue,
                            item.calories,
                          ),
                          protein: item.protein,
                          carbs: item.carbs,
                          fat: item.fat,
                          rating: item.rating,
                          difficulty:
                              item.difficulty == null
                                  ? null
                                  : recipeDifficultyLabel(
                                    l10n,
                                    item.difficulty,
                                  ),
                          isFavorite: isFavorite(item.favoriteKey),
                          onFavoriteTap:
                              () => onToggleFavorite(item.favoriteKey),
                          onTap:
                              () =>
                                  onOpenDetail(item, l10n.nutritionRecommended),
                          imageHeight: 140,
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 22),
              ],
              if (section.recipes.isNotEmpty) ...[
                Text(
                  l10n.nutritionRecipesForYou,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: Theme.of(context).colorScheme.primary,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 12),
                ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: section.recipes.length,
                  separatorBuilder:
                      (_, _) => Padding(
                        padding: const EdgeInsets.symmetric(vertical: 6),
                        child: Divider(height: 1, color: ext.glassBorder),
                      ),
                  itemBuilder: (context, index) {
                    final item = section.recipes[index];
                    return PremiumRecipeListTile(
                      image: item.image,
                      name: item.name,
                      time: recipeMinutesLabel(
                        l10n,
                        item.prepTimeMinutes,
                        item.time,
                      ),
                      calories: recipeCaloriesLabel(
                        l10n,
                        item.caloriesValue,
                        item.calories,
                      ),
                      rating: item.rating,
                      difficulty:
                          item.difficulty == null
                              ? null
                              : recipeDifficultyLabel(l10n, item.difficulty),
                      isFavorite: isFavorite(item.favoriteKey),
                      onFavoriteTap: () => onToggleFavorite(item.favoriteKey),
                      onTap:
                          () => onOpenDetail(item, l10n.nutritionRecipesForYou),
                    );
                  },
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

class _TopRecipeHero extends StatelessWidget {
  const _TopRecipeHero({
    required this.meal,
    required this.badge,
    required this.isFavorite,
    required this.onFavoriteTap,
    required this.onTap,
  });

  final MealDetail meal;
  final String badge;
  final bool isFavorite;
  final VoidCallback onFavoriteTap;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final ext = theme.extension<AppThemeExtension>()!;
    final l10n = AppLocalizations.of(context);

    return PressableScale(
      child: GestureDetector(
        onTap: onTap,
        child: AspectRatio(
          aspectRatio: 16 / 11,
          child: Container(
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(AppRadius.card),
              border: Border.all(color: ext.glassBorder),
            ),
            child: Stack(
              fit: StackFit.expand,
              children: [
                SmartImage(meal.image),
                Positioned.fill(
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.transparent,
                          Colors.transparent,
                          Colors.black.withValues(alpha: 0.82),
                        ],
                        stops: const [0, 0.4, 1],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                  ),
                ),
                PositionedDirectional(
                  top: 14,
                  start: 14,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 7,
                    ),
                    decoration: BoxDecoration(
                      gradient: ext.accentGradient,
                      borderRadius: BorderRadius.circular(AppRadius.pill),
                    ),
                    child: Text(
                      badge,
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w900,
                        color: ext.onAccent,
                        letterSpacing: 0.4,
                      ),
                    ),
                  ),
                ),
                PositionedDirectional(
                  top: 14,
                  end: 14,
                  child: GestureDetector(
                    onTap: onFavoriteTap,
                    child: Container(
                      width: 38,
                      height: 38,
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.32),
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.2),
                        ),
                      ),
                      child: Icon(
                        isFavorite
                            ? Icons.star_rounded
                            : Icons.star_border_rounded,
                        color: isFavorite ? ext.accentGlow : Colors.white,
                        size: 20,
                      ),
                    ),
                  ),
                ),
                PositionedDirectional(
                  start: 16,
                  end: 16,
                  bottom: 14,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        meal.name,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.titleLarge?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w900,
                          height: 1.12,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(
                            Icons.timer_outlined,
                            size: 15,
                            color: Colors.white.withValues(alpha: 0.8),
                          ),
                          const SizedBox(width: 5),
                          Text(
                            recipeMinutesLabel(
                              l10n,
                              meal.prepTimeMinutes,
                              meal.time,
                            ),
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Icon(
                            Icons.local_fire_department_rounded,
                            size: 15,
                            color: Colors.white.withValues(alpha: 0.8),
                          ),
                          const SizedBox(width: 5),
                          Text(
                            recipeCaloriesLabel(
                              l10n,
                              meal.caloriesValue,
                              meal.calories,
                            ),
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.white,
                            ),
                          ),
                          if (meal.rating != null) ...[
                            const SizedBox(width: 16),
                            Icon(
                              Icons.star_rounded,
                              size: 15,
                              color: ext.accentGlow,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              meal.rating!.toStringAsFixed(1),
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.white,
                              ),
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
        ),
      ),
    );
  }
}
