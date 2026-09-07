import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:nabvera/core/localization/generated/app_localizations.dart';
import 'package:nabvera/core/routing/app_routes.dart';
import 'package:nabvera/core/theme/app_colors.dart';
import 'package:nabvera/core/theme/app_theme_extension.dart';
import 'package:nabvera/core/widgets/premium_scaffold.dart';
import 'package:nabvera/core/widgets/smart_image.dart';
import 'package:nabvera/features/favorite/domain/favorite_models.dart';
import 'package:nabvera/features/favorite/presentation/providers/favorite_controller.dart';
import 'package:nabvera/features/nutrition/data/nutrition_repository.dart';
import 'package:nabvera/features/nutrition/domain/nutrition_models.dart';
import 'package:nabvera/features/workout/data/workout_repository.dart';
import 'package:nabvera/features/workout/domain/exercise_detail_models.dart';

class FavoritePage extends ConsumerWidget {
  const FavoritePage({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filter = ref.watch(favoriteFilterControllerProvider);
    final items = ref.watch(filteredFavoritesProvider);
    final ext = Theme.of(context).extension<AppThemeExtension>()!;
    final l10n = AppLocalizations.of(context);

    return PremiumScaffold(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              PremiumBackButton(
                onTap:
                    () =>
                        context.canPop()
                            ? context.pop()
                            : context.go(AppRoutes.home),
              ),
              const SizedBox(width: 12),
              Text(
                l10n.navFavorites,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: ext.textPrimary,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const Spacer(),
              PremiumIconButton(
                icon: Icons.search_rounded,
                onTap: () => context.push(AppRoutes.search),
              ),
              const SizedBox(width: 10),
              PremiumIconButton(
                icon: Icons.notifications_none_rounded,
                onTap: () => context.push(AppRoutes.notifications),
              ),
            ],
          ),
          const SizedBox(height: 18),
          SizedBox(
            height: 38,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: FavoriteFilter.values.length,
              separatorBuilder: (_, _) => const SizedBox(width: 8),
              itemBuilder: (context, index) {
                final f = FavoriteFilter.values[index];
                final isSelected = f == filter;
                return _FilterPill(
                  label: _label(l10n, f),
                  icon: _icon(f),
                  selected: isSelected,
                  onTap:
                      () => ref
                          .read(favoriteFilterControllerProvider.notifier)
                          .select(f),
                );
              },
            ),
          ),
          const SizedBox(height: 18),
          Expanded(
            child:
                items.isEmpty
                    ? _FavoriteEmptyState(filter: filter)
                    : ListView.separated(
                      padding: EdgeInsets.zero,
                      itemCount: items.length,
                      separatorBuilder:
                          (context, _) => Divider(
                            height: 21,
                            color:
                                Theme.of(
                                  context,
                                ).extension<AppThemeExtension>()!.glassBorder,
                          ),
                      itemBuilder: (context, index) {
                        final item = items[index];
                        return TweenAnimationBuilder<double>(
                          key: ValueKey(item.title),
                          tween: Tween(begin: 0, end: 1),
                          duration: Duration(
                            milliseconds: 220 + (index * 40).clamp(0, 300),
                          ),
                          curve: Curves.easeOutCubic,
                          builder:
                              (context, value, child) => Opacity(
                                opacity: value,
                                child: Transform.translate(
                                  offset: Offset(0, (1 - value) * 16),
                                  child: child,
                                ),
                              ),
                          child: _FavoriteCard(
                            item: item,
                            onOpen: () => _openFavorite(context, ref, item),
                            onUnfavorite:
                                () => ref
                                    .read(filteredFavoritesProvider.notifier)
                                    .remove(item),
                          ),
                        );
                      },
                    ),
          ),
        ],
      ),
    );
  }

  String _label(AppLocalizations l10n, FavoriteFilter filter) =>
      switch (filter) {
        FavoriteFilter.all => l10n.favoriteFilterAll,
        FavoriteFilter.video => l10n.favoriteFilterWorkouts,
        FavoriteFilter.article => l10n.favoriteFilterNutrition,
      };

  IconData _icon(FavoriteFilter filter) => switch (filter) {
    FavoriteFilter.all => Icons.apps_rounded,
    FavoriteFilter.video => Icons.fitness_center_rounded,
    FavoriteFilter.article => Icons.restaurant_rounded,
  };

  Future<void> _openFavorite(
    BuildContext context,
    WidgetRef ref,
    FavoriteItem item,
  ) async {
    if (item.id.isEmpty) return;

    try {
      if (item.type == FavoriteType.video) {
        final json = await ref
            .read(workoutRepositoryProvider)
            .fetchWorkoutById(item.id);
        if (!context.mounted) return;
        context.push(
          AppRoutes.workoutCategoryDetail,
          extra: CategoryDetailData.fromWorkoutJson(json),
        );
        return;
      }

      final json = await ref
          .read(nutritionRepositoryProvider)
          .fetchRecipeById(item.id);
      if (!context.mounted) return;
      context.push(AppRoutes.mealDetail, extra: MealDetail.fromJson(json));
    } catch (_) {
      // A deleted or unavailable favorite cannot be opened.
    }
  }
}

class _FilterPill extends StatelessWidget {
  const _FilterPill({
    required this.label,
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final ext = Theme.of(context).extension<AppThemeExtension>()!;
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          gradient:
              selected
                  ? const LinearGradient(
                    colors: [AppColors.seedLime, AppColors.electricOrange],
                  )
                  : null,
          color: selected ? null : ext.glassFill,
          borderRadius: BorderRadius.circular(999),
          border: Border.all(
            color: selected ? Colors.transparent : ext.glassBorder,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 15,
              color: selected ? AppColors.seedInk : ext.textMuted,
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                color: selected ? AppColors.seedInk : ext.textPrimary,
                fontWeight: FontWeight.w800,
                fontSize: 13,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FavoriteCard extends StatefulWidget {
  const _FavoriteCard({
    required this.item,
    required this.onOpen,
    required this.onUnfavorite,
  });
  final FavoriteItem item;
  final VoidCallback onOpen;
  final VoidCallback onUnfavorite;

  @override
  State<_FavoriteCard> createState() => _FavoriteCardState();
}

class _FavoriteCardState extends State<_FavoriteCard> {
  // Every item reaching this card came from the user's real favorites, so
  // it always starts favorited — tapping the star unfavorites it for real
  // (see [FilteredFavorites.remove]) rather than toggling local-only state.
  bool _favorited = true;

  @override
  Widget build(BuildContext context) {
    final ext = Theme.of(context).extension<AppThemeExtension>()!;
    final item = widget.item;
    final isWorkout = item.type == FavoriteType.video;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: widget.onOpen,
        borderRadius: BorderRadius.circular(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 84,
              height: 84,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: SmartImage(item.image),
                  ),
                  Positioned(
                    top: 6,
                    right: 6,
                    child: GestureDetector(
                      onTap: () {
                        setState(() => _favorited = !_favorited);
                        if (!_favorited) widget.onUnfavorite();
                      },
                      child: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 220),
                        transitionBuilder:
                            (child, animation) =>
                                ScaleTransition(scale: animation, child: child),
                        child: Container(
                          key: ValueKey(_favorited),
                          width: 26,
                          height: 26,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.black.withValues(alpha: 0.4),
                          ),
                          child: Icon(
                            _favorited
                                ? Icons.star_rounded
                                : Icons.star_border_rounded,
                            color:
                                _favorited ? AppColors.seedLime : Colors.white,
                            size: 15,
                          ),
                        ),
                      ),
                    ),
                  ),
                  if (isWorkout)
                    Positioned(
                      bottom: 6,
                      left: 6,
                      child: Container(
                        width: 26,
                        height: 26,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: LinearGradient(
                            colors: [
                              AppColors.seedLime,
                              AppColors.electricOrange,
                            ],
                          ),
                        ),
                        child: const Icon(
                          Icons.play_arrow_rounded,
                          color: AppColors.seedInk,
                          size: 15,
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
                children: [
                  _CategoryTag(isWorkout: isWorkout),
                  const SizedBox(height: 8),
                  Text(
                    item.title,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w800,
                      color: ext.textPrimary,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (item.text != null) ...[
                    const SizedBox(height: 6),
                    Text(
                      item.text!,
                      style: TextStyle(fontSize: 12, color: ext.textMuted),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 12,
                    runSpacing: 6,
                    children: [
                      if (item.duration != null)
                        _MetaChip(
                          icon: Icons.timer_outlined,
                          label: item.duration!,
                        ),
                      if (item.calories != null)
                        _MetaChip(
                          icon: Icons.local_fire_department_outlined,
                          label: item.calories!,
                          color: AppColors.electricOrange,
                        ),
                      if (item.exercises != null)
                        _MetaChip(
                          icon: Icons.repeat_rounded,
                          label: item.exercises!,
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

class _CategoryTag extends StatelessWidget {
  const _CategoryTag({required this.isWorkout});
  final bool isWorkout;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final color = isWorkout ? AppColors.seedLime : AppColors.aquaBlue;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.14),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Text(
        isWorkout ? l10n.favoriteTagWorkout : l10n.favoriteTagNutrition,
        style: TextStyle(
          color: color,
          fontSize: 10,
          fontWeight: FontWeight.w900,
          letterSpacing: 0.4,
        ),
      ),
    );
  }
}

class _MetaChip extends StatelessWidget {
  const _MetaChip({required this.icon, required this.label, this.color});
  final IconData icon;
  final String label;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final ext = Theme.of(context).extension<AppThemeExtension>()!;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 13, color: color ?? ext.textMuted),
        const SizedBox(width: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 11,
            color: ext.textMuted,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

class _FavoriteEmptyState extends StatelessWidget {
  const _FavoriteEmptyState({required this.filter});
  final FavoriteFilter filter;

  @override
  Widget build(BuildContext context) {
    final ext = Theme.of(context).extension<AppThemeExtension>()!;
    final l10n = AppLocalizations.of(context);
    final showingNutrition = filter == FavoriteFilter.article;
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 88,
            height: 88,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: [
                  AppColors.seedViolet.withValues(alpha: 0.18),
                  AppColors.electricOrange.withValues(alpha: 0.12),
                ],
              ),
              border: Border.all(color: ext.glassBorder),
            ),
            child: const Icon(
              Icons.star_border_rounded,
              color: AppColors.seedLime,
              size: 40,
            ),
          ),
          const SizedBox(height: 20),
          Text(
            l10n.favoriteEmptyTitle,
            style: TextStyle(
              color: ext.textPrimary,
              fontSize: 18,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: Text(
              l10n.favoriteEmptyBody,
              textAlign: TextAlign.center,
              style: TextStyle(color: ext.textMuted, fontSize: 13, height: 1.5),
            ),
          ),
          const SizedBox(height: 22),
          InkWell(
            onTap:
                () => context.go(
                  showingNutrition ? AppRoutes.nutrition : AppRoutes.workout,
                ),
            borderRadius: BorderRadius.circular(20),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 12),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [AppColors.seedLime, AppColors.electricOrange],
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                showingNutrition
                    ? l10n.favoriteBrowseNutrition
                    : l10n.favoriteBrowseWorkouts,
                style: const TextStyle(
                  color: AppColors.seedInk,
                  fontWeight: FontWeight.w800,
                  fontSize: 14,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
