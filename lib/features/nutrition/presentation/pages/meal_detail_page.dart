import 'package:nabvera/core/localization/generated/app_localizations.dart';
import 'package:nabvera/core/routing/app_routes.dart';
import 'package:nabvera/core/theme/app_theme_extension.dart';
import 'package:nabvera/core/widgets/primary_button.dart';
import 'package:nabvera/features/nutrition/data/nutrition_repository.dart';
import 'package:nabvera/features/nutrition/domain/nutrition_models.dart';
import 'package:nabvera/features/nutrition/presentation/providers/meal_idea_controller.dart';
import 'package:nabvera/features/nutrition/presentation/providers/nutrition_controller.dart';
import 'package:nabvera/features/nutrition/presentation/widgets/meal_detail_header.dart';
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
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _MarkMealEatenButton(meal: meal),
                      const SizedBox(height: 10),
                      PrimaryButton(
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
                    ],
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

/// "Mark as eaten" for a Meal Ideas recipe — no meal-plan slot involved,
/// so (unlike meal_plan_home_page.dart's version) there's no persistent
/// "already logged" state to seed from the backend: the same recipe can
/// legitimately be eaten more than once a day. Only tracks *this screen
/// visit's* log locally, to offer an immediate undo.
class _MarkMealEatenButton extends ConsumerStatefulWidget {
  const _MarkMealEatenButton({required this.meal});

  final MealDetail meal;

  @override
  ConsumerState<_MarkMealEatenButton> createState() => _MarkMealEatenButtonState();
}

class _MarkMealEatenButtonState extends ConsumerState<_MarkMealEatenButton> {
  bool _submitting = false;
  String? _logId;

  Future<void> _markEaten() async {
    final recipeId = widget.meal.favoriteKey;
    if (recipeId == null) return;
    final l10n = AppLocalizations.of(context);
    setState(() => _submitting = true);
    try {
      final entry = await ref.read(nutritionRepositoryProvider).logMeal(
        recipeId: recipeId,
        mealType: widget.meal.defaultMealType,
      );
      final loggedMeals = (entry['loggedMeals'] as List? ?? const []).cast<Map<String, dynamic>>();
      final logId = loggedMeals.isEmpty ? null : loggedMeals.last['_id'] as String?;
      ref.read(dailyNutritionSummaryControllerProvider.notifier).refresh();
      if (!mounted) return;
      setState(() => _logId = logId);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l10n.mealLogAdded)));
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l10n.mealLogFailed)));
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  Future<void> _undo() async {
    final logId = _logId;
    if (logId == null) return;
    final l10n = AppLocalizations.of(context);
    setState(() => _submitting = true);
    try {
      await ref.read(nutritionRepositoryProvider).unlogMeal(logId);
      ref.read(dailyNutritionSummaryControllerProvider.notifier).refresh();
      if (!mounted) return;
      setState(() => _logId = null);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l10n.mealLogRemoved)));
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l10n.mealLogUndoFailed)));
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    if (widget.meal.favoriteKey == null) return const SizedBox.shrink();

    if (_logId != null) {
      return SizedBox(
        width: double.infinity,
        child: OutlinedButton.icon(
          onPressed: _submitting ? null : _undo,
          icon: const Icon(Icons.check_circle_rounded),
          label: Text('${l10n.mealLogged} · ${l10n.mealLogUndo}'),
        ),
      );
    }

    return SizedBox(
      width: double.infinity,
      child: OutlinedButton.icon(
        onPressed: _submitting ? null : _markEaten,
        icon: _submitting
            ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2))
            : const Icon(Icons.restaurant_rounded),
        label: Text(l10n.mealMarkAsEaten),
      ),
    );
  }
}
