import 'package:fitness_app/core/localization/generated/app_localizations.dart';
import 'package:fitness_app/core/routing/app_routes.dart';
import 'package:fitness_app/core/theme/app_spacing.dart';
import 'package:fitness_app/core/theme/app_theme_extension.dart';
import 'package:fitness_app/core/widgets/premium_scaffold.dart';
import 'package:fitness_app/core/widgets/primary_button.dart';
import 'package:fitness_app/core/widgets/smart_image.dart';
import 'package:fitness_app/features/nutrition/presentation/providers/meal_breakfast_controller.dart';
import 'package:fitness_app/features/onboarding/presentation/widgets/wizard_scaffold.dart';
import 'package:fitness_app/features/workout/presentation/widgets/workout_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class MealPlanBreakfastPage extends ConsumerWidget {
  const MealPlanBreakfastPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final options = ref.watch(mealBreakfastControllerProvider);
    final controller = ref.read(mealBreakfastControllerProvider.notifier);
    final selectedIndex = ref.watch(selectedBreakfastIndexProvider);
    final theme = Theme.of(context);
    final ext = theme.extension<AppThemeExtension>()!;
    final l10n = AppLocalizations.of(context);

    return PremiumScaffold(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          WorkoutHeader(title: l10n.nutritionTabMealPlans),
          const SizedBox(height: 14),
          const WizardStepIndicator(step: 4, totalSteps: 4),
          const SizedBox(height: 20),
          Text(
            l10n.mealPlanBreakfastTitle,
            style: theme.textTheme.titleLarge?.copyWith(
              color: theme.colorScheme.primary,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            l10n.mealPlanBreakfastBody,
            style: TextStyle(fontSize: 13, color: ext.textMuted),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: ListView.separated(
              itemCount: options.length,
              separatorBuilder: (_, _) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final item = options[index];
                final isSelected = selectedIndex == index;
                return _BreakfastOptionCard(
                  isSelected: isSelected,
                  onTap: () {
                    ref
                        .read(selectedBreakfastIndexProvider.notifier)
                        .select(index);
                    context.push(AppRoutes.mealDetail, extra: item.toDetail());
                  },
                  image: item.image,
                  name: item.name,
                  time: item.time,
                  calories: item.calories,
                  isFavorite: item.isFavorite,
                  onFavoriteTap: () => controller.toggleFavorite(index),
                );
              },
            ),
          ),
          const SizedBox(height: 16),
          PrimaryButton(
            label: l10n.mealPlanSeeRecipe,
            icon: Icons.arrow_forward_rounded,
            onPressed: () => context.push(AppRoutes.mealIdeaDiscover),
          ),
        ],
      ),
    );
  }
}

class _BreakfastOptionCard extends StatelessWidget {
  const _BreakfastOptionCard({
    required this.isSelected,
    required this.onTap,
    required this.image,
    required this.name,
    required this.time,
    required this.calories,
    required this.isFavorite,
    required this.onFavoriteTap,
  });

  final bool isSelected;
  final VoidCallback onTap;
  final String image;
  final String name;
  final String time;
  final String calories;
  final bool isFavorite;
  final VoidCallback onFavoriteTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final ext = theme.extension<AppThemeExtension>()!;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: ext.glassFill,
          borderRadius: BorderRadius.circular(AppRadius.card),
          border: Border.all(
            color: isSelected ? theme.colorScheme.primary : ext.glassBorder,
            width: isSelected ? 1.6 : 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: isSelected ? ext.accentGradient : null,
                border:
                    isSelected
                        ? null
                        : Border.all(color: ext.glassBorder, width: 2),
              ),
              child:
                  isSelected
                      ? Icon(Icons.check_rounded, size: 15, color: ext.onAccent)
                      : null,
            ),
            const SizedBox(width: 12),
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Stack(
                children: [
                  SmartImage(image, width: 88, height: 88),
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
                        color: isFavorite ? ext.accentGlow : Colors.white,
                        size: 20,
                      ),
                    ),
                  ),
                ],
              ),
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
                    style: TextStyle(
                      fontSize: 14,
                      color: ext.textPrimary,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(
                        Icons.timer_outlined,
                        size: 14,
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
                      const SizedBox(width: 10),
                      Icon(
                        Icons.local_fire_department_rounded,
                        size: 14,
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
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
