import 'package:nabvera/core/localization/generated/app_localizations.dart';
import 'package:nabvera/core/routing/app_routes.dart';
import 'package:nabvera/core/theme/app_spacing.dart';
import 'package:nabvera/core/theme/app_theme_extension.dart';
import 'package:nabvera/core/widgets/premium_scaffold.dart';
import 'package:nabvera/features/nutrition/data/nutrition_repository.dart';
import 'package:nabvera/features/nutrition/domain/nutrition_models.dart';
import 'package:nabvera/features/nutrition/domain/nutrition_recipe_sections.dart';
import 'package:nabvera/features/nutrition/presentation/providers/meal_idea_controller.dart';
import 'package:nabvera/features/nutrition/presentation/providers/nutrition_controller.dart';
import 'package:nabvera/features/nutrition/presentation/widgets/log_water_sheet.dart';
import 'package:nabvera/features/nutrition/presentation/widgets/nutrition_access_cards.dart';
import 'package:nabvera/features/nutrition/presentation/widgets/nutrition_summary_card.dart';
import 'package:nabvera/features/nutrition/presentation/widgets/nutrition_surface.dart';
import 'package:nabvera/features/nutrition/presentation/widgets/nutrition_water_card.dart';
import 'package:nabvera/features/nutrition/presentation/widgets/premium_recipe_card.dart';
import 'package:nabvera/features/workout/presentation/widgets/workout_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// Space the floating bottom navigation pill and the AI coach button take up
/// at the end of the scroll view (they float over the page body).
const double _kFloatingNavClearance = 66 + 76;

class NutritionPage extends ConsumerStatefulWidget {
  const NutritionPage({super.key});

  @override
  ConsumerState<NutritionPage> createState() => _NutritionPageState();
}

class _NutritionPageState extends ConsumerState<NutritionPage> {
  /// Set while a recipe is being fetched so a second tap can't push the
  /// detail page twice.
  bool _openingRecipe = false;

  @override
  Widget build(BuildContext context) {
    // Watched only to keep the selected tab alive: the access cards record
    // their tab here before navigating away (the provider is autoDispose).
    ref.watch(nutritionTabControllerProvider);
    final recommended = ref.watch(nutritionRecommendedProvider);
    final recipes = ref.watch(nutritionRecipesProvider);
    final recipesStatus = ref.watch(nutritionRecipesStatusProvider);
    final summary = ref.watch(dailyNutritionSummaryControllerProvider);
    final favorites = ref.watch(mealIdeaFavoritesProvider);
    final ext = Theme.of(context).extension<AppThemeExtension>()!;
    final l10n = AppLocalizations.of(context);

    // Recipe of the day, suggestions and the explore list never repeat a
    // recipe. Only this page's view is filtered; the shared source isn't.
    final sections = splitNutritionRecipes(
      recommended: recommended,
      recipes: recipes,
    );

    final bottomClearance =
        MediaQuery.paddingOf(context).bottom + _kFloatingNavClearance;

    Widget recipeCardFor(MealItem item) => PremiumRecipeCard(
      image: item.image,
      name: item.localizedName(context),
      time: recipeMinutesLabel(l10n, item.prepTimeMinutes, item.time),
      calories: recipeCaloriesLabel(l10n, item.caloriesValue, item.calories),
      protein: recipeProteinLabel(l10n, item.proteinGrams),
      isFavorite: favorites.contains(item.id),
      onFavoriteTap:
          item.id.isEmpty
              ? null
              : () =>
                  ref.read(mealIdeaFavoritesProvider.notifier).toggle(item.id),
      favoriteLabel: recipeFavoriteLabel(
        l10n,
        item.localizedName(context),
        isFavorite: favorites.contains(item.id),
      ),
      onTap: () => _openRecipe(item.id),
    );

    final today = sections.today;

    return PremiumScaffold(
      // One CustomScrollView for the whole page (vertical overflow is
      // structurally impossible), wrapped in a RefreshIndicator so pulling
      // down re-fetches the recipes and today's summary — see _pullToRefresh.
      child: RefreshIndicator(
        color: ext.accentGlow,
        backgroundColor: ext.cardColor,
        onRefresh: _pullToRefresh,
        child: CustomScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          slivers: [
            SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  WorkoutHeader(title: l10n.navNutrition, showBack: false),
                  const SizedBox(height: AppSpacing.lg),
                  NutritionSummaryCard(
                    summary: summary,
                    onSetGoals:
                        () => context.push(AppRoutes.mealPlanPreferences),
                    onRetry:
                        () =>
                            ref
                                .read(
                                  dailyNutritionSummaryControllerProvider
                                      .notifier,
                                )
                                .refresh(),
                  ),
                  if (!summary.isLoading && !summary.loadFailed) ...[
                    const SizedBox(height: AppSpacing.md),
                    NutritionWaterCard(
                      summary: summary,
                      onAddWater: () => showLogWaterSheet(context, ref),
                    ),
                  ],
                  const SizedBox(height: AppSpacing.lg),
                  NutritionAccessCards(
                    onMealPlans: () {
                      ref
                          .read(nutritionTabControllerProvider.notifier)
                          .select(NutritionTab.mealPlans);
                      context.push(AppRoutes.mealPlanHome);
                    },
                    onMealIdeas: () {
                      ref
                          .read(nutritionTabControllerProvider.notifier)
                          .select(NutritionTab.mealIdeas);
                      context.push(AppRoutes.mealIdea);
                    },
                  ),
                  if (today != null) ...[
                    const SizedBox(height: AppSpacing.lg),
                    RecipeOfTheDayCard(
                      image: today.image,
                      badge: l10n.nutritionRecipeOfTheDay,
                      name: today.localizedName(context),
                      time: recipeMinutesLabel(
                        l10n,
                        today.prepTimeMinutes,
                        today.time,
                      ),
                      calories: recipeCaloriesLabel(
                        l10n,
                        today.caloriesValue,
                        today.calories,
                      ),
                      protein: recipeProteinLabel(l10n, today.proteinGrams),
                      isFavorite: favorites.contains(today.id),
                      onFavoriteTap:
                          today.id.isEmpty
                              ? null
                              : () => ref
                                  .read(mealIdeaFavoritesProvider.notifier)
                                  .toggle(today.id),
                      favoriteLabel: recipeFavoriteLabel(
                        l10n,
                        today.localizedName(context),
                        isFavorite: favorites.contains(today.id),
                      ),
                      onTap: () => _openRecipe(today.id),
                    ),
                  ],
                ],
              ),
            ),
            if (sections.suggested.isNotEmpty) ...[
              _SectionTitle(l10n.nutritionSectionSuggested),
              _RecipeGridSliver(
                items: sections.suggested,
                itemBuilder: recipeCardFor,
              ),
            ],
            if (sections.explore.isNotEmpty) ...[
              _SectionTitle(l10n.nutritionSectionExplore),
              _RecipeGridSliver(
                items: sections.explore,
                itemBuilder: recipeCardFor,
              ),
            ],
            if (sections.isEmpty) ...[
              _SectionTitle(l10n.nutritionSectionExplore),
              SliverToBoxAdapter(
                child: _RecipesStatusBlock(
                  status: recipesStatus,
                  onRetry: _retryRecipes,
                ),
              ),
            ],
            SliverToBoxAdapter(child: SizedBox(height: bottomClearance)),
          ],
        ),
      ),
    );
  }

  /// Awaits a real reload of every provider this page reads from, so the
  /// [RefreshIndicator] spinner stays up until fresh data (or a real
  /// error) has come back — mirrors Home's own `_pullToRefresh`. On
  /// failure, whatever was already shown is left as-is (see
  /// [NutritionRecipesSource.refresh], which never clears `state` on
  /// error, and the caught-internally [DailyNutritionSummaryController._load])
  /// and a short, retriable error is surfaced instead of pretending it worked.
  Future<void> _pullToRefresh() async {
    try {
      await Future.wait([
        ref.read(nutritionRecipesSourceProvider.notifier).refresh(),
        ref.read(dailyNutritionSummaryControllerProvider.notifier).refresh(),
      ]);
    } catch (_) {
      if (!mounted) return;
      final l10n = AppLocalizations.of(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.nutritionRefreshFailed),
          action: SnackBarAction(
            label: l10n.actionRetry,
            onPressed: _pullToRefresh,
          ),
        ),
      );
    }
  }

  Future<void> _retryRecipes() async {
    try {
      await ref.read(nutritionRecipesSourceProvider.notifier).refresh();
    } catch (_) {
      // The status provider already flipped back to "failed", which is what
      // the retry block renders.
    }
  }

  /// Fetches the full recipe and opens it as a real [MealDetail] — the
  /// card only carries the trimmed list fields, so this gets the real
  /// ingredients/steps/tips/benefits before navigating.
  Future<void> _openRecipe(String recipeId) async {
    if (recipeId.isEmpty || _openingRecipe) return;
    _openingRecipe = true;
    try {
      final json = await ref
          .read(nutritionRepositoryProvider)
          .fetchRecipeById(recipeId);
      if (!mounted) return;
      context.push(AppRoutes.mealDetail, extra: MealDetail.fromJson(json));
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context).nutritionRecipeOpenFailed),
        ),
      );
    } finally {
      _openingRecipe = false;
    }
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle(this.title);

  final String title;

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.only(
          top: AppSpacing.xl,
          bottom: AppSpacing.md,
        ),
        child: Semantics(
          header: true,
          child: PremiumSectionHeader(title: title),
        ),
      ),
    );
  }
}

/// Two-column (one on very narrow/large-text layouts, three on wide ones)
/// grid of recipe cards. Rows are as tall as their tallest card — no fixed
/// extent — so wrapped text is never clipped.
class _RecipeGridSliver extends StatelessWidget {
  const _RecipeGridSliver({required this.items, required this.itemBuilder});

  final List<MealItem> items;
  final Widget Function(MealItem item) itemBuilder;

  static const double _gap = AppSpacing.md;

  @override
  Widget build(BuildContext context) {
    return SliverLayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.crossAxisExtent;
        final textScale = MediaQuery.textScalerOf(context).scale(14) / 14;
        var columns = (width / 160).floor().clamp(1, 3);
        if (textScale > 1.6) columns = 1;
        final rowCount = (items.length / columns).ceil();

        return SliverList(
          delegate: SliverChildBuilderDelegate((context, row) {
            final children = <Widget>[];
            for (var c = 0; c < columns; c++) {
              final index = row * columns + c;
              if (c > 0) children.add(const SizedBox(width: _gap));
              children.add(
                Expanded(
                  child:
                      index < items.length
                          ? itemBuilder(items[index])
                          : const SizedBox.shrink(),
                ),
              );
            }
            return Padding(
              padding: EdgeInsets.only(
                bottom: row == rowCount - 1 ? 0 : AppSpacing.lg,
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: children,
              ),
            );
          }, childCount: rowCount),
        );
      },
    );
  }
}

/// Stand-in for the recipe sections while there is nothing to list: still
/// loading, failed to load (retriable), or genuinely empty — three different
/// situations, shown differently.
class _RecipesStatusBlock extends StatelessWidget {
  const _RecipesStatusBlock({required this.status, required this.onRetry});

  final NutritionLoadStatus status;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final ext = theme.extension<AppThemeExtension>()!;
    final l10n = AppLocalizations.of(context);

    if (status == NutritionLoadStatus.loading) {
      return const SizedBox(
        height: 120,
        child: Center(
          child: SizedBox(
            width: 28,
            height: 28,
            child: CircularProgressIndicator(strokeWidth: 2.4),
          ),
        ),
      );
    }

    final failed = status == NutritionLoadStatus.failed;
    return NutritionSurface(
      padding: const EdgeInsets.all(AppSpacing.xl),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ExcludeSemantics(
            child: Icon(
              failed ? Icons.cloud_off_rounded : Icons.restaurant_menu_rounded,
              size: 36,
              color: ext.textMuted,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            failed
                ? l10n.nutritionRecipesLoadFailedTitle
                : l10n.nutritionRecipesEmptyTitle,
            textAlign: TextAlign.center,
            style: theme.textTheme.titleMedium?.copyWith(
              color: ext.textPrimary,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            failed
                ? l10n.nutritionRecipesLoadFailedBody
                : l10n.nutritionRecipesEmptyBody,
            textAlign: TextAlign.center,
            style: theme.textTheme.bodyMedium?.copyWith(color: ext.textMuted),
          ),
          if (failed) ...[
            const SizedBox(height: AppSpacing.lg),
            NutritionActionButton(
              label: l10n.actionRetry,
              icon: Icons.refresh_rounded,
              onPressed: onRetry,
            ),
          ],
        ],
      ),
    );
  }
}
