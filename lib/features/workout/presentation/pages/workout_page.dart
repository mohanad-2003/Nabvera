import 'package:nabvera/features/workout/presentation/providers/workout_request_providers.dart';
import 'package:nabvera/features/workout/presentation/widgets/workout_surface.dart';
import 'package:nabvera/core/network/app_icons.dart';
import 'package:nabvera/core/localization/generated/app_localizations.dart';
import 'package:nabvera/core/routing/app_routes.dart';
import 'package:nabvera/core/theme/app_spacing.dart';
import 'package:nabvera/core/theme/app_theme_extension.dart';
import 'package:nabvera/core/widgets/featured_card.dart';
import 'package:nabvera/core/widgets/premium_scaffold.dart';
import 'package:nabvera/features/workout/data/workout_repository.dart';
import 'package:nabvera/features/workout/domain/exercise_detail_models.dart';
import 'package:nabvera/features/workout/domain/workout_models.dart';
import 'package:nabvera/features/workout/presentation/providers/workout_controller.dart';
import 'package:nabvera/features/workout/presentation/widgets/workout_header.dart';
import 'package:nabvera/features/workout/presentation/widgets/workout_list_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// `Workout.category`'s raw backend values, grouped into the two labeled
/// rows the category chips render as — "Iron Training" (equipment-heavy
/// strength work) vs "General Fitness" (everything else). Purely a
/// display grouping: both rows write to the same
/// [WorkoutCategoryFilter]/`?category=` value, so there's only ever one
/// classification system, not two competing ones.
const _kIronCategories = <String>['strength'];
const _kFitnessCategories = <String>[
  'cardio',
  'yoga',
  'hiit',
  'stretching',
  'full_body',
];
const _kAllCategories = <String>[..._kIronCategories, ..._kFitnessCategories];

class WorkoutPage extends ConsumerWidget {
  const WorkoutPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final level = ref.watch(workoutTabProvider);
    final category = ref.watch(workoutCategoryFilterProvider);
    final items = ref.watch(workoutListByLevelProvider(level));
    final request = ref.watch(
      workoutRequestProvider((level: level, category: category)),
    );
    final ext = Theme.of(context).extension<AppThemeExtension>()!;
    final l10n = AppLocalizations.of(context);
    final compact = MediaQuery.sizeOf(context).height < 720;
    final spacing = compact ? 8.0 : 12.0;
    // Sized so the header, chips, buttons, hero, section title, and at
    // least the first workout card or two all land within the first
    // viewport on typical phones — CustomScrollView still lets the page
    // scroll naturally for the rest, and on unusually short viewports,
    // rather than overflowing.
    final heroHeight = compact ? 210.0 : 240.0;
    final listCardHeight = compact ? 104.0 : 117.0;

    return WorkoutScaffold(
      // The whole page is one CustomScrollView: the header/chips/buttons/
      // hero/section-title live in a single SliverToBoxAdapter, and the
      // workout list is a SliverList right below it. Because everything
      // shares one real scroll view, there's no fixed-viewport budget to
      // get wrong — the page simply scrolls for however much content there
      // is, which makes vertical overflow structurally impossible.
      child: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                WorkoutHeader(title: l10n.workoutTitle, showBack: false),
                const SizedBox(height: 4),
                Text(
                  l10n.workoutSubtitle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.copyWith(color: ext.textMuted),
                ),
                SizedBox(height: spacing),
                SizedBox(
                  height: 36,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: WorkoutLevel.values.length,
                    separatorBuilder: (_, _) => const SizedBox(width: 8),
                    itemBuilder: (context, index) {
                      final tabLevel = WorkoutLevel.values[index];
                      final isSelected = tabLevel == level;
                      return WorkoutPill(
                        label: _label(l10n, tabLevel),
                        selected: isSelected,
                        appearance: WorkoutPillAppearance.filter,
                        onTap:
                            () => ref
                                .read(workoutTabProvider.notifier)
                                .select(tabLevel),
                      );
                    },
                  ),
                ),
                SizedBox(height: spacing / 2),
                // Was level-only before, then a level row plus two more
                // rows (each under its own "Iron Training"/"General
                // Fitness" label) for Workout.category — three stacked
                // filter rows before a single workout was visible. Now one
                // scrollable row: "All" followed by every category value,
                // equipment-heavy ones first. Still one classification
                // system writing to the same filter, just without the
                // section labels and extra rows costing vertical space.
                SizedBox(
                  height: 34,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: _kAllCategories.length + 1,
                    separatorBuilder: (_, _) => const SizedBox(width: 8),
                    itemBuilder: (context, index) {
                      final value =
                          index == 0 ? null : _kAllCategories[index - 1];
                      return WorkoutPill(
                        label: _categoryLabel(l10n, value),
                        selected: value == category,
                        appearance: WorkoutPillAppearance.filter,
                        onTap:
                            () => ref
                                .read(workoutCategoryFilterProvider.notifier)
                                .select(value),
                      );
                    },
                  ),
                ),
                SizedBox(height: spacing),
                Row(
                  children: [
                    Expanded(
                      child: _WorkoutActionButton(
                        icon: Icons.list_alt_rounded,
                        label: l10n.workoutYourRoutine,
                        compact: compact,
                        onTap: () => context.push(AppRoutes.yourRoutine),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: _WorkoutActionButton(
                        icon: Icons.add_circle_outline_rounded,
                        label: l10n.workoutCreateRoutine,
                        compact: compact,
                        // The one action that creates something new — a
                        // filled primary button, so the row reads as one
                        // primary + one secondary action instead of two
                        // visually identical outlined pills competing for
                        // attention.
                        filled: true,
                        onTap: () => context.push(AppRoutes.createRoutine),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: spacing),
                if (items.isNotEmpty)
                  FeaturedCard(
                    image: items.first.image,
                    badge: _label(l10n, level),
                    title: items.first.localizedName(context),
                    metas: [
                      if (items.first.localizedTime(context) case final time?)
                        FeaturedCardMeta(icon: AppIcons.time, label: time),
                      if (items.first.localizedCalories(context)
                          case final calories?)
                        FeaturedCardMeta(
                          icon: AppIcons.calories,
                          label: calories,
                        ),
                      if (items.first.localizedExercises(context)
                          case final exercises?)
                        FeaturedCardMeta(
                          icon: AppIcons.workout,
                          label: exercises,
                        ),
                    ],
                    ctaLabel: l10n.workoutStartWorkout,
                    height: heroHeight,
                    // Real, persisted favorite state (unlike this card's
                    // default cosmetic-only local toggle) — same
                    // `toggleFavorite` the list rows below already use, on
                    // this list's first (featured) item.
                    isFavorite: items.first.isFavorite,
                    onFavoriteTap:
                        () => ref
                            .read(workoutListByLevelProvider(level).notifier)
                            .toggleFavorite(0),
                    onTap: () => _openWorkout(context, ref, items.first.id),
                  ),
                SizedBox(height: spacing),
                PremiumSectionHeader(title: l10n.workoutTitle),
                SizedBox(height: compact ? 8 : 12),
              ],
            ),
          ),
          if (request.isLoading || request.hasError || items.isEmpty)
            SliverToBoxAdapter(
              child: WorkoutStatus(
                loading: request.isLoading,
                error: request.error,
                onRetry: () {
                  ref.invalidate(
                    workoutRequestProvider((level: level, category: category)),
                  );
                  ref.invalidate(workoutListByLevelProvider(level));
                },
              ),
            ),
          SliverList.separated(
            itemCount: items.length,
            separatorBuilder: (_, _) => SizedBox(height: spacing),
            itemBuilder:
                (context, index) => WorkoutListCard(
                  item: items[index],
                  height: listCardHeight,
                  onTap: () => _openWorkout(context, ref, items[index].id),
                  onToggleFavorite:
                      () => ref
                          .read(workoutListByLevelProvider(level).notifier)
                          .toggleFavorite(index),
                ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 8)),
        ],
      ),
    );
  }

  String _label(AppLocalizations l10n, WorkoutLevel level) => switch (level) {
    WorkoutLevel.beginner => l10n.workoutLevelBeginner,
    WorkoutLevel.intermediate => l10n.workoutLevelIntermediate,
    WorkoutLevel.advanced => l10n.workoutLevelAdvanced,
  };

  String _categoryLabel(AppLocalizations l10n, String? category) =>
      switch (category) {
        null => l10n.workoutCategoryAll,
        'strength' => l10n.workoutCategoryStrength,
        'cardio' => l10n.workoutCategoryCardio,
        'yoga' => l10n.workoutCategoryYoga,
        'hiit' => l10n.workoutCategoryHiit,
        'stretching' => l10n.workoutCategoryStretching,
        'full_body' => l10n.workoutCategoryFullBody,
        _ => category,
      };

  /// Fetches the full workout (with populated exercises) and opens it as a
  /// real [CategoryDetailData] — each round item then carries a real
  /// [ExerciseDetailData], video included, instead of the static curated
  /// content this screen used to always push regardless of which workout
  /// was tapped.
  Future<void> _openWorkout(
    BuildContext context,
    WidgetRef ref,
    String workoutId,
  ) async {
    if (workoutId.isEmpty) return;
    try {
      final json = await ref
          .read(workoutRepositoryProvider)
          .fetchWorkoutById(workoutId);
      if (!context.mounted) return;
      context.push(
        AppRoutes.workoutCategoryDetail,
        extra: CategoryDetailData.fromWorkoutJson(json),
      );
    } catch (_) {
      // Backend unreachable / workout deleted — silently do nothing rather
      // than fall back to unrelated curated content for this specific tap.
    }
  }
}

class _WorkoutActionButton extends StatelessWidget {
  const _WorkoutActionButton({
    required this.icon,
    required this.label,
    required this.onTap,
    this.compact = false,
    this.filled = false,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool compact;

  /// True for the row's one primary action — a solid accent-gradient pill
  /// instead of the outline every other call site here uses, so the pair
  /// reads as primary + secondary rather than two identical buttons.
  final bool filled;

  @override
  Widget build(BuildContext context) {
    final ext = Theme.of(context).extension<AppThemeExtension>()!;
    final accent = ext.accentGlow;
    final iconColor = filled ? ext.onAccent : accent;
    final textColor = filled ? ext.onAccent : ext.textPrimary;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppRadius.pill),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: compact ? 10 : 13),
        decoration: BoxDecoration(
          gradient: filled ? ext.accentGradient : null,
          borderRadius: BorderRadius.circular(AppRadius.pill),
          border:
              filled
                  ? null
                  : Border.all(
                    color: accent.withValues(alpha: 0.55),
                    width: 1.3,
                  ),
          boxShadow:
              filled
                  ? [
                    BoxShadow(
                      color: accent.withValues(alpha: 0.32),
                      blurRadius: 16,
                      offset: const Offset(0, 8),
                    ),
                  ]
                  : null,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 18, color: iconColor),
            const SizedBox(width: 8),
            Flexible(
              child: Text(
                label,
                style: TextStyle(
                  color: textColor,
                  fontWeight: FontWeight.w700,
                  fontSize: 13,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

