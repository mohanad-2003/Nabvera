import 'package:fitness_app/core/localization/generated/app_localizations.dart';
import 'package:fitness_app/core/routing/app_routes.dart';
import 'package:fitness_app/core/theme/app_theme_extension.dart';
import 'package:fitness_app/core/widgets/premium_scaffold.dart';
import 'package:fitness_app/features/nutrition/presentation/providers/meal_idea_controller.dart';
import 'package:fitness_app/features/nutrition/presentation/widgets/meal_idea_section_view.dart';
import 'package:fitness_app/features/workout/presentation/widgets/workout_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:fitness_app/features/nutrition/domain/nutrition_models.dart';

const _categoryEmoji = {
  MealCategory.breakfast: '🍳',
  MealCategory.lunch: '🥪',
  MealCategory.dinner: '🍝',
};

class MealIdeaPage extends ConsumerWidget {
  const MealIdeaPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final category = ref.watch(mealIdeaCategoryControllerProvider);
    final section = ref.watch(mealIdeaSectionControllerProvider(category));
    final favorites = ref.watch(mealIdeaFavoritesProvider.notifier);
    final favSet = ref.watch(mealIdeaFavoritesProvider);
    final l10n = AppLocalizations.of(context);

    return PremiumScaffold(
      padding: EdgeInsets.zero,
      child: SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  WorkoutHeader(title: l10n.mealIdeaTitle),
                  const SizedBox(height: 18),
                  SizedBox(
                    height: 40,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: MealCategory.values.length,
                      separatorBuilder: (_, _) => const SizedBox(width: 10),
                      itemBuilder: (context, index) {
                        final cat = MealCategory.values[index];
                        return _CategoryChip(
                          emoji: _categoryEmoji[cat]!,
                          label: _label(l10n, cat),
                          selected: cat == category,
                          onTap:
                              () => ref
                                  .read(
                                    mealIdeaCategoryControllerProvider.notifier,
                                  )
                                  .select(cat),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 6),
            MealIdeaSectionView(
              section: section,
              isFavorite: (key) => key != null && favSet.contains(key),
              onToggleFavorite: favorites.toggle,
              onOpenDetail:
                  (meal, tag) =>
                      context.push(AppRoutes.mealDetail, extra: meal),
            ),
          ],
        ),
      ),
    );
  }

  String _label(AppLocalizations l10n, MealCategory category) =>
      switch (category) {
        MealCategory.breakfast => l10n.mealCategoryBreakfast,
        MealCategory.lunch => l10n.mealCategoryLunch,
        MealCategory.dinner => l10n.mealCategoryDinner,
      };
}

class _CategoryChip extends StatelessWidget {
  const _CategoryChip({
    required this.emoji,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String emoji;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final ext = theme.extension<AppThemeExtension>()!;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeOut,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          gradient: selected ? ext.accentGradient : null,
          color: selected ? null : ext.glassFill,
          borderRadius: BorderRadius.circular(999),
          border: Border.all(
            color: selected ? Colors.transparent : ext.glassBorder,
          ),
        ),
        alignment: Alignment.center,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(emoji, style: const TextStyle(fontSize: 15)),
            const SizedBox(width: 7),
            Text(
              label,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: selected ? ext.onAccent : ext.textPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
