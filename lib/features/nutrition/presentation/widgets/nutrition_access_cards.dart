import 'package:flutter/material.dart';
import 'package:nabvera/core/localization/generated/app_localizations.dart';
import 'package:nabvera/core/theme/app_spacing.dart';
import 'package:nabvera/core/theme/app_theme_extension.dart';
import 'package:nabvera/features/nutrition/presentation/widgets/nutrition_surface.dart';

const _mealPlansImage = 'assets/nutrition_illustrations/meal_plans.png';
const _mealIdeasImage = 'assets/nutrition_illustrations/meal_ideas.png';

/// The two entry points into the standalone Meal Plans and Meal Ideas pages.
/// Drawn as tappable cards (illustration, title, one-line description, and a
/// forward arrow) rather than tabs, because tapping navigates away.
///
/// Side by side normally; stacked on a narrow window or a large system font
/// so the text is never squeezed.
class NutritionAccessCards extends StatelessWidget {
  const NutritionAccessCards({
    super.key,
    required this.onMealPlans,
    required this.onMealIdeas,
  });

  final VoidCallback onMealPlans;
  final VoidCallback onMealIdeas;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return LayoutBuilder(
      builder: (context, constraints) {
        final stacked =
            MediaQuery.textScalerOf(context).scale(14) / 14 > 1.3 ||
            constraints.maxWidth < 300;

        final plans = _AccessCard(
          image: _mealPlansImage,
          title: l10n.nutritionCardMealPlansTitle,
          body: l10n.nutritionCardMealPlansBody,
          horizontal: stacked,
          onTap: onMealPlans,
        );
        final ideas = _AccessCard(
          image: _mealIdeasImage,
          title: l10n.nutritionCardMealIdeasTitle,
          body: l10n.nutritionCardMealIdeasBody,
          horizontal: stacked,
          onTap: onMealIdeas,
        );

        if (stacked) {
          return Column(
            children: [plans, const SizedBox(height: AppSpacing.md), ideas],
          );
        }
        return IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(child: plans),
              const SizedBox(width: AppSpacing.md),
              Expanded(child: ideas),
            ],
          ),
        );
      },
    );
  }
}

class _AccessCard extends StatelessWidget {
  const _AccessCard({
    required this.image,
    required this.title,
    required this.body,
    required this.horizontal,
    required this.onTap,
  });

  final String image;
  final String title;
  final String body;

  /// Image beside the text (stacked layout) instead of above it.
  final bool horizontal;
  final VoidCallback onTap;

  static const double _imageSize = 72;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final ext = theme.extension<AppThemeExtension>()!;
    final dpr = MediaQuery.devicePixelRatioOf(context);

    // Decorative: the title and description next to it already say it all.
    final art = ExcludeSemantics(
      child: SizedBox(
        width: _imageSize,
        height: _imageSize,
        child: Image.asset(
          image,
          fit: BoxFit.contain,
          // The PNGs are 1254px square; decode only what is drawn.
          cacheWidth: (_imageSize * dpr).ceil(),
          excludeFromSemantics: true,
          errorBuilder: (_, _, _) => const SizedBox.shrink(),
        ),
      ),
    );

    final arrow = ExcludeSemantics(
      child: Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: ext.accentGlow.withValues(alpha: 0.12),
        ),
        child: Icon(
          Directionality.of(context) == TextDirection.rtl
              ? Icons.arrow_back_rounded
              : Icons.arrow_forward_rounded,
          size: 18,
          color: ext.accentGlow,
        ),
      ),
    );

    final texts = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          title,
          style: theme.textTheme.titleSmall?.copyWith(
            color: ext.textPrimary,
            fontWeight: FontWeight.w900,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          body,
          style: theme.textTheme.bodySmall?.copyWith(color: ext.textMuted),
        ),
      ],
    );

    return Semantics(
      button: true,
      child: NutritionSurface(
        onTap: onTap,
        padding: const EdgeInsets.all(AppSpacing.md),
        child:
            horizontal
                ? Row(
                  children: [
                    art,
                    const SizedBox(width: AppSpacing.md),
                    Expanded(child: texts),
                    const SizedBox(width: AppSpacing.sm),
                    arrow,
                  ],
                )
                : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [art, arrow],
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    texts,
                  ],
                ),
      ),
    );
  }
}
