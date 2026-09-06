import 'package:nabvera/core/localization/generated/app_localizations.dart';
import 'package:nabvera/core/network/app_icons.dart';
import 'package:nabvera/core/routing/app_routes.dart';
import 'package:nabvera/core/theme/app_colors.dart';
import 'package:nabvera/core/theme/app_theme_extension.dart';
import 'package:nabvera/core/widgets/featured_card.dart';
import 'package:nabvera/core/widgets/premium_scaffold.dart';
import 'package:nabvera/features/nutrition/data/nutrition_repository.dart';
import 'package:nabvera/features/nutrition/domain/nutrition_models.dart';
import 'package:nabvera/features/nutrition/presentation/providers/meal_idea_controller.dart';
import 'package:nabvera/features/nutrition/presentation/providers/nutrition_controller.dart';
import 'package:nabvera/features/nutrition/presentation/widgets/log_water_sheet.dart';
import 'package:nabvera/features/nutrition/presentation/widgets/nutrition_summary_card.dart';
import 'package:nabvera/features/nutrition/presentation/widgets/premium_recipe_card.dart';
import 'package:nabvera/features/workout/presentation/widgets/workout_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class NutritionPage extends ConsumerWidget {
  const NutritionPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tab = ref.watch(nutritionTabControllerProvider);
    final recommended = ref.watch(nutritionRecommendedProvider);
    final recipes = ref.watch(nutritionRecipesProvider);
    final summary = ref.watch(dailyNutritionSummaryControllerProvider);
    final favorites = ref.watch(mealIdeaFavoritesProvider);
    final ext = Theme.of(context).extension<AppThemeExtension>()!;
    final l10n = AppLocalizations.of(context);
    final compact = MediaQuery.sizeOf(context).height < 720;
    final spacing = compact ? 10.0 : 14.0;
    final heroHeight = compact ? 150.0 : 200.0;

    return PremiumScaffold(
      // The whole page is one CustomScrollView: header/summary/chips/hero/
      // Recommended row live in a single SliverToBoxAdapter, and "Recipes
      // for you" is a SliverList right below it — one real scroll view, so
      // vertical overflow is structurally impossible regardless of device.
      child: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                WorkoutHeader(title: l10n.navNutrition, showBack: false),
                const SizedBox(height: 6),
                Text(
                  l10n.nutritionSubtitle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.copyWith(color: ext.textMuted),
                ),
                SizedBox(height: spacing),
                NutritionSummaryCard(
                  summary: summary,
                  onLogWater: () => showLogWaterSheet(context, ref),
                  onSetGoals: () => context.push(AppRoutes.mealPlanPreferences),
                ),
                SizedBox(height: spacing),
                Row(
                  children: [
                    Expanded(
                      child: PremiumPill(
                        label: l10n.nutritionTabMealPlans,
                        icon: Icons.calendar_month_rounded,
                        selected: tab == NutritionTab.mealPlans,
                        onTap: () {
                          ref
                              .read(nutritionTabControllerProvider.notifier)
                              .select(NutritionTab.mealPlans);
                          context.push(AppRoutes.mealPlanHome);
                        },
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: PremiumPill(
                        label: l10n.nutritionTabMealIdeas,
                        icon: Icons.restaurant_menu_rounded,
                        selected: tab == NutritionTab.mealIdeas,
                        onTap: () {
                          ref
                              .read(nutritionTabControllerProvider.notifier)
                              .select(NutritionTab.mealIdeas);
                          context.push(AppRoutes.mealIdea);
                        },
                      ),
                    ),
                  ],
                ),
                SizedBox(height: spacing),
                FeaturedCard(
                  image: 'assets/carrot.png',
                  badge: l10n.nutritionRecipeOfTheDay,
                  // Nutrition's secondary accent per the design system.
                  badgeColor: AppColors.seedViolet,
                  title: l10n.nutritionFeaturedRecipeName,
                  metas: [
                    FeaturedCardMeta(
                      icon: AppIcons.time,
                      label: l10n.nutritionFeaturedRecipeDuration,
                    ),
                    FeaturedCardMeta(
                      icon: AppIcons.calories,
                      label: l10n.nutritionFeaturedRecipeCalories,
                    ),
                  ],
                  height: heroHeight,
                  onTap:
                      recommended.isEmpty
                          ? null
                          : () =>
                              _openRecipe(context, ref, recommended.first.id),
                ),
                SizedBox(height: compact ? 14 : 22),
                PremiumSectionHeader(title: l10n.nutritionRecommended),
                const SizedBox(height: 10),
              ],
            ),
          ),
          SliverGrid(
            gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 220,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              // Sized to the card's actual content (104 image + ~10 more
              // lines of text/chips below it) — the previous 284 left a
              // large empty gap under every card regardless of content.
              mainAxisExtent: 220,
            ),
            delegate: SliverChildBuilderDelegate((context, index) {
              final item = recommended[index];
              return PremiumRecipeCard(
                image: item.image,
                name: item.name,
                time: recipeMinutesLabel(l10n, item.prepTimeMinutes, item.time),
                calories: recipeCaloriesLabel(
                  l10n,
                  item.caloriesValue,
                  item.calories,
                ),
                subtitle: item.subtitle,
                protein: item.protein,
                carbs: item.carbs,
                fat: item.fat,
                rating: item.rating,
                difficulty:
                    item.difficulty == null
                        ? null
                        : recipeDifficultyLabel(l10n, item.difficulty),
                imageHeight: 104,
                isFavorite: favorites.contains(item.id),
                onFavoriteTap:
                    () => ref
                        .read(mealIdeaFavoritesProvider.notifier)
                        .toggle(item.id),
                onTap: () => _openRecipe(context, ref, item.id),
              );
            }, childCount: recommended.length),
          ),
          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: compact ? 14 : 22),
                PremiumSectionHeader(title: l10n.nutritionRecipesForYou),
                const SizedBox(height: 10),
              ],
            ),
          ),
          SliverList.separated(
            itemCount: recipes.length,
            separatorBuilder:
                (_, _) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6),
                  child: Divider(height: 1, color: ext.glassBorder),
                ),
            itemBuilder: (context, index) {
              final item = recipes[index];
              return PremiumRecipeListTile(
                image: item.image,
                name: item.name,
                time: recipeMinutesLabel(l10n, item.prepTimeMinutes, item.time),
                calories: recipeCaloriesLabel(
                  l10n,
                  item.caloriesValue,
                  item.calories,
                ),
                rating: item.rating,
                isFavorite: favorites.contains(item.id),
                onFavoriteTap:
                    () => ref
                        .read(mealIdeaFavoritesProvider.notifier)
                        .toggle(item.id),
                onTap: () => _openRecipe(context, ref, item.id),
              );
            },
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 8)),
        ],
      ),
    );
  }

  /// Fetches the full recipe and opens it as a real [MealDetail] — the
  /// card only carries the trimmed list fields, so this gets the real
  /// ingredients/steps/tips/benefits before navigating.
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
