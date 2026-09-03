import 'package:fitness_app/core/localization/generated/app_localizations.dart';
import 'package:fitness_app/core/routing/app_routes.dart';
import 'package:fitness_app/core/theme/app_theme_extension.dart';
import 'package:fitness_app/core/widgets/primary_button.dart';
import 'package:fitness_app/features/nutrition/data/nutrition_repository.dart';
import 'package:fitness_app/features/nutrition/domain/nutrition_models.dart';
import 'package:fitness_app/features/nutrition/presentation/providers/meal_idea_controller.dart';
import 'package:fitness_app/features/nutrition/presentation/widgets/meal_detail_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// Generic recipe/meal detail screen — replaces the legacy
/// detailsMealPage.dart and the three ad-hoc detail branches inline in
/// mealIdeaPage.dart (top/recommended/recipe), all of which rendered the
/// same ingredients+preparation layout.
class MealDetailPage extends ConsumerWidget {
  const MealDetailPage({super.key, required this.meal, this.tag = 'Recipe'});

  final MealDetail meal;
  final String tag;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final ext = theme.extension<AppThemeExtension>()!;
    final l10n = AppLocalizations.of(context);
    final favorites = ref.watch(mealIdeaFavoritesProvider.notifier);
    final isFavorite = ref
        .watch(mealIdeaFavoritesProvider)
        .contains(meal.favoriteKey);
    final similar = meal.similarRecipes;

    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(gradient: ext.backgroundGradient),
            ),
          ),
          SafeArea(
            bottom: false,
            child: SingleChildScrollView(
              padding: const EdgeInsets.only(bottom: 24),
              child: MealDetailHeader(
                meal: meal,
                tagText: tag,
                isFavorite: meal.favoriteKey != null && isFavorite,
                onFavoriteTap:
                    meal.favoriteKey == null
                        ? null
                        : () => favorites.toggle(meal.favoriteKey),
                similar: similar,
                onTapSimilar: (item) => _openRecipe(context, ref, item.id),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar:
          meal.favoriteKey == null
              ? null
              : SafeArea(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 12, 20, 16),
                  child: PrimaryButton(
                    label:
                        isFavorite
                            ? l10n.nutritionRecipeSaved
                            : l10n.nutritionSaveRecipe,
                    icon:
                        isFavorite
                            ? Icons.check_rounded
                            : Icons.star_border_rounded,
                    onPressed: () => favorites.toggle(meal.favoriteKey),
                  ),
                ),
              ),
    );
  }

  /// Fetches the full recipe and pushes a new [MealDetailPage] for it — the
  /// similar-recipe card only carries the trimmed list fields.
  Future<void> _openRecipe(
    BuildContext context,
    WidgetRef ref,
    String recipeId,
  ) async {
    if (recipeId.isEmpty) return;
    try {
      final json = await ref
          .read(nutritionRepositoryProvider)
          .fetchRecipeById(recipeId);
      if (!context.mounted) return;
      context.push(AppRoutes.mealDetail, extra: MealDetail.fromJson(json));
    } catch (_) {
      // Backend unreachable / recipe deleted — silently do nothing.
    }
  }
}
