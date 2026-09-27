import 'package:nabvera/core/localization/generated/app_localizations.dart';
import 'package:nabvera/core/responsive/app_responsive.dart';
import 'package:nabvera/core/theme/app_spacing.dart';
import 'package:nabvera/core/theme/app_theme_extension.dart';
import 'package:nabvera/core/widgets/smart_image.dart';
import 'package:nabvera/features/nutrition/domain/nutrition_models.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'premium_recipe_card.dart';

/// Full scrollable body of the recipe-detail screen: large hero image with
/// floating back/favorite buttons, title + quick stats, an optional
/// nutrition-facts card, ingredients, numbered cooking steps, optional tips
/// and health-benefits cards, and a "Similar Recipes" discovery row.
/// Replaces the old ingredients/preparation-only layout.
class MealDetailHeader extends StatelessWidget {
  const MealDetailHeader({
    super.key,
    required this.meal,
    required this.tagText,
    this.isFavorite = false,
    this.onFavoriteTap,
    this.similar = const [],
    this.onTapSimilar,
  });

  final MealDetail meal;
  final String tagText;
  final bool isFavorite;
  final VoidCallback? onFavoriteTap;

  /// Other recipes in the same category as [meal] (see
  /// `MealDetail.similarRecipes`) — tapping one fetches its full detail
  /// and opens it via [onTapSimilar].
  final List<MealItem> similar;
  final ValueChanged<MealItem>? onTapSimilar;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final ext = theme.extension<AppThemeExtension>()!;
    final l10n = AppLocalizations.of(context);
    final heroHeight = context.responsive(
      compact: 260.0,
      standard: 300.0,
      medium: 340.0,
      expanded: 380.0,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _Hero(
          meal: meal,
          tagText: tagText,
          height: heroHeight,
          isFavorite: isFavorite,
          onFavoriteTap: onFavoriteTap,
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                meal.localizedName(context),
                style: theme.textTheme.headlineSmall?.copyWith(
                  color: ext.textPrimary,
                  height: 1.08,
                ),
              ),
              const SizedBox(height: 14),
              Wrap(
                spacing: 18,
                runSpacing: 10,
                children: [
                  _Stat(
                    icon: Icons.timer_outlined,
                    label: recipeMinutesLabel(
                      l10n,
                      meal.prepTimeMinutes,
                      meal.time,
                    ),
                  ),
                  _Stat(
                    icon: Icons.local_fire_department_rounded,
                    label: recipeCaloriesLabel(
                      l10n,
                      meal.caloriesValue,
                      meal.calories,
                    ),
                    iconColor: theme.colorScheme.secondary,
                  ),
                  if (meal.servings != null)
                    _Stat(
                      icon: Icons.people_alt_outlined,
                      label: '${meal.servings} ${l10n.nutritionServingsShort}',
                    ),
                  if (meal.difficulty != null)
                    _Stat(
                      icon: Icons.speed_rounded,
                      label: recipeDifficultyLabel(l10n, meal.difficulty),
                    ),
                  if (meal.rating != null)
                    _Stat(
                      icon: Icons.star_rounded,
                      label: meal.rating!.toStringAsFixed(1),
                      iconColor: ext.accentGlow,
                    ),
                ],
              ),
              if (meal.protein != null ||
                  meal.carbs != null ||
                  meal.fat != null) ...[
                const SizedBox(height: 22),
                _SectionCard(
                  title: l10n.nutritionNutritionFacts,
                  child: Row(
                    children: [
                      if (meal.protein != null)
                        Expanded(
                          child: _MacroRing(
                            label: l10n.nutritionProteinLabel,
                            grams: meal.protein!,
                            dailyValueGrams: 50,
                            color: const Color(0xFF29D9C0),
                          ),
                        ),
                      if (meal.carbs != null)
                        Expanded(
                          child: _MacroRing(
                            label: l10n.nutritionCarbsLabel,
                            grams: meal.carbs!,
                            dailyValueGrams: 275,
                            color: const Color(0xFFFFB020),
                          ),
                        ),
                      if (meal.fat != null)
                        Expanded(
                          child: _MacroRing(
                            label: l10n.nutritionFatLabel,
                            grams: meal.fat!,
                            dailyValueGrams: 78,
                            color: const Color(0xFFE8951A),
                          ),
                        ),
                    ],
                  ),
                ),
              ],
              if (meal.localizedIngredients(context).isNotEmpty) ...[
                const SizedBox(height: 18),
                _SectionCard(
                  title: l10n.mealIngredients,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      for (final ingredient in meal.localizedIngredients(
                        context,
                      ))
                        _IngredientRow(text: ingredient),
                    ],
                  ),
                ),
              ],
              if (meal.localizedPreparation(context).isNotEmpty) ...[
                const SizedBox(height: 18),
                _SectionCard(
                  title: l10n.nutritionCookingSteps,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      for (final (i, step)
                          in meal.localizedPreparation(context).indexed)
                        _StepRow(
                          index: i + 1,
                          text: step,
                          isLast:
                              i ==
                              meal.localizedPreparation(context).length - 1,
                        ),
                    ],
                  ),
                ),
              ],
              if (meal.localizedTips(context).isNotEmpty) ...[
                const SizedBox(height: 18),
                _SectionCard(
                  title: l10n.nutritionTips,
                  icon: Icons.lightbulb_outline_rounded,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      for (final tip in meal.localizedTips(context))
                        _Bullet(text: tip),
                    ],
                  ),
                ),
              ],
              if (meal.localizedBenefits(context).isNotEmpty) ...[
                const SizedBox(height: 18),
                _SectionCard(
                  title: l10n.nutritionBenefits,
                  icon: Icons.favorite_border_rounded,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      for (final benefit in meal.localizedBenefits(context))
                        _Bullet(text: benefit),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
        if (similar.isNotEmpty) ...[
          const SizedBox(height: 22),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              l10n.nutritionSimilarRecipes,
              style: theme.textTheme.titleLarge?.copyWith(
                color: theme.colorScheme.primary,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 246,
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              scrollDirection: Axis.horizontal,
              itemCount: similar.length,
              separatorBuilder: (_, _) => const SizedBox(width: 12),
              itemBuilder: (context, index) {
                final item = similar[index];
                return SizedBox(
                  width: 190,
                  child: PremiumRecipeCard(
                    image: item.image,
                    name: item.localizedName(context),
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
                            : recipeDifficultyLabel(l10n, item.difficulty),
                    imageHeight: 140,
                    onTap:
                        onTapSimilar == null ? null : () => onTapSimilar!(item),
                  ),
                );
              },
            ),
          ),
        ],
      ],
    );
  }
}

class _Hero extends StatelessWidget {
  const _Hero({
    required this.meal,
    required this.tagText,
    required this.height,
    required this.isFavorite,
    required this.onFavoriteTap,
  });

  final MealDetail meal;
  final String tagText;
  final double height;
  final bool isFavorite;
  final VoidCallback? onFavoriteTap;

  @override
  Widget build(BuildContext context) {
    final ext = Theme.of(context).extension<AppThemeExtension>()!;
    final topInset = MediaQuery.paddingOf(context).top;

    return SizedBox(
      height: height,
      width: double.infinity,
      child: Stack(
        fit: StackFit.expand,
        children: [
          SmartImage(meal.image),
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.black.withValues(alpha: 0.32),
                    Colors.transparent,
                    Colors.black.withValues(alpha: 0.1),
                  ],
                  stops: const [0, 0.4, 1],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
          ),
          PositionedDirectional(
            top: topInset + 10,
            start: 14,
            child: GestureDetector(
              onTap: () => context.canPop() ? context.pop() : null,
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.36),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Directionality.of(context) == TextDirection.rtl
                      ? Icons.arrow_forward_ios_rounded
                      : Icons.arrow_back_ios_new_rounded,
                  color: Colors.white,
                  size: 18,
                ),
              ),
            ),
          ),
          PositionedDirectional(
            top: topInset + 10,
            end: 14,
            child: GestureDetector(
              onTap: onFavoriteTap,
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.36),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  isFavorite ? Icons.star_rounded : Icons.star_border_rounded,
                  color: isFavorite ? ext.accentGlow : Colors.white,
                  size: 20,
                ),
              ),
            ),
          ),
          PositionedDirectional(
            bottom: 14,
            start: 14,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
              decoration: BoxDecoration(
                gradient: ext.accentGradient,
                borderRadius: BorderRadius.circular(AppRadius.pill),
              ),
              child: Text(
                tagText,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w900,
                  color: ext.onAccent,
                  letterSpacing: 0.4,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Stat extends StatelessWidget {
  const _Stat({required this.icon, required this.label, this.iconColor});

  final IconData icon;
  final String label;
  final Color? iconColor;

  @override
  Widget build(BuildContext context) {
    final ext = Theme.of(context).extension<AppThemeExtension>()!;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 17, color: iconColor ?? ext.textMuted),
        const SizedBox(width: 6),
        Text(
          label,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w700,
            color: ext.textPrimary,
          ),
        ),
      ],
    );
  }
}

class _SectionCard extends StatelessWidget {
  const _SectionCard({required this.title, required this.child, this.icon});

  final String title;
  final Widget child;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final ext = theme.extension<AppThemeExtension>()!;

    // No boxed container — a section header plus a thin underline, then the
    // content directly on the page background.
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            if (icon != null) ...[
              Icon(icon, size: 18, color: theme.colorScheme.primary),
              const SizedBox(width: 8),
            ],
            Text(
              title,
              style: theme.textTheme.titleMedium?.copyWith(
                color: theme.colorScheme.primary,
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Divider(height: 1, color: ext.glassBorder),
        const SizedBox(height: 14),
        child,
      ],
    );
  }
}

/// A single macro's share of a standard daily reference intake, drawn as a
/// filled ring with the percentage centered inside — the recipe only ever
/// carries an absolute gram amount, so [dailyValueGrams] (FDA %DV-style
/// reference: 50g protein / 275g carbs / 78g fat) is what turns that into a
/// meaningful ring fraction instead of an arbitrary bar length.
class _MacroRing extends StatelessWidget {
  const _MacroRing({
    required this.label,
    required this.grams,
    required this.dailyValueGrams,
    required this.color,
  });

  final String label;

  /// e.g. `"12g"` — parsed back to a number for the ring fraction.
  final String grams;
  final double dailyValueGrams;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final ext = Theme.of(context).extension<AppThemeExtension>()!;
    final value =
        double.tryParse(RegExp(r'[\d.]+').stringMatch(grams) ?? '') ?? 0;
    final fraction = (value / dailyValueGrams).clamp(0.0, 1.0);
    final percent = (fraction * 100).round();

    return Column(
      children: [
        SizedBox(
          width: 56,
          height: 56,
          child: Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                width: 56,
                height: 56,
                child: CircularProgressIndicator(
                  value: 1,
                  strokeWidth: 5,
                  strokeCap: StrokeCap.round,
                  color: ext.glassBorder,
                ),
              ),
              SizedBox(
                width: 56,
                height: 56,
                child: CircularProgressIndicator(
                  value: fraction,
                  strokeWidth: 5,
                  strokeCap: StrokeCap.round,
                  backgroundColor: Colors.transparent,
                  color: color,
                ),
              ),
              Text(
                '$percent%',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w900,
                  color: ext.textPrimary,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        Text(
          grams,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w800,
            color: ext.textPrimary,
          ),
        ),
        const SizedBox(height: 2),
        Text(label, style: TextStyle(fontSize: 11.5, color: ext.textMuted)),
      ],
    );
  }
}

class _Bullet extends StatelessWidget {
  const _Bullet({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final ext = theme.extension<AppThemeExtension>()!;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 6,
            height: 6,
            margin: const EdgeInsets.only(top: 7),
            decoration: BoxDecoration(
              color: theme.colorScheme.secondary,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 13.5,
                color: ext.textPrimary,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// One ingredient line, split into a leading quantity chip (when the string
/// starts with a recognizable amount, e.g. `"250g Steel-Cut Oats"`) and the
/// ingredient name — `MealDetail.ingredients` only ever hands over that one
/// combined string, so the split happens here rather than upstream.
class _IngredientRow extends StatelessWidget {
  const _IngredientRow({required this.text});

  final String text;

  static final _leadingAmount = RegExp(
    r'^([\d./]+\s?(?:g|kg|ml|l|cup|cups|tbsp|tsp|oz|pcs|piece|pieces|clove|cloves|slice|slices|كوب|ملعقة|جرام|غرام|جم|غم|كغم|حبة|حبات)?)\s+(.+)$',
    caseSensitive: false,
  );

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final ext = theme.extension<AppThemeExtension>()!;
    final match = _leadingAmount.firstMatch(text);
    final amount = match?.group(1)?.trim();
    final name = match?.group(2)?.trim() ?? text;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: ext.glassFill,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: ext.glassBorder),
        ),
        child: Row(
          children: [
            Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                color: theme.colorScheme.secondary,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                name,
                style: TextStyle(
                  fontSize: 13.5,
                  fontWeight: FontWeight.w600,
                  color: ext.textPrimary,
                  height: 1.3,
                ),
              ),
            ),
            if (amount != null && amount.isNotEmpty) ...[
              const SizedBox(width: 10),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 5,
                ),
                decoration: BoxDecoration(
                  gradient: ext.accentGradient,
                  borderRadius: BorderRadius.circular(AppRadius.pill),
                ),
                child: Text(
                  amount,
                  style: TextStyle(
                    fontSize: 11.5,
                    fontWeight: FontWeight.w900,
                    color: ext.onAccent,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _StepRow extends StatelessWidget {
  const _StepRow({
    required this.index,
    required this.text,
    required this.isLast,
  });

  final int index;
  final String text;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final ext = theme.extension<AppThemeExtension>()!;

    return Padding(
      padding: EdgeInsets.only(bottom: isLast ? 0 : 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 26,
            height: 26,
            decoration: BoxDecoration(
              gradient: ext.accentGradient,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                '$index',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w900,
                  color: ext.onAccent,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(top: 3),
              child: Text(
                text,
                style: TextStyle(
                  fontSize: 13.5,
                  color: ext.textPrimary,
                  height: 1.45,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
