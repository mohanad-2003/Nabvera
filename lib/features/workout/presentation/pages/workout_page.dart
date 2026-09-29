import 'dart:math' as math;

import 'package:nabvera/features/workout/presentation/providers/workout_request_providers.dart';
import 'package:nabvera/features/workout/presentation/widgets/workout_surface.dart';
import 'package:nabvera/core/network/app_icons.dart';
import 'package:nabvera/core/localization/generated/app_localizations.dart';
import 'package:nabvera/core/routing/app_routes.dart';
import 'package:nabvera/core/theme/app_spacing.dart';
import 'package:nabvera/core/theme/app_theme_extension.dart';
import 'package:nabvera/core/widgets/featured_card.dart';
import 'package:nabvera/core/widgets/premium_scaffold.dart';
import 'package:nabvera/core/widgets/pressable_scale.dart';
import 'package:nabvera/core/widgets/smart_image.dart';
import 'package:nabvera/features/workout/data/workout_repository.dart';
import 'package:nabvera/features/workout/domain/exercise_detail_models.dart';
import 'package:nabvera/features/workout/domain/workout_models.dart';
import 'package:nabvera/features/workout/domain/workout_progress_entry.dart';
import 'package:nabvera/features/workout/presentation/providers/workout_controller.dart';
import 'package:nabvera/features/workout/presentation/providers/workout_active_session_provider.dart';
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
    final progress = ref.watch(workoutActiveSessionProvider);
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
                if (progress != null && !progress.isComplete) ...[
                  _ContinueWorkoutCard(
                    entry: progress,
                    onTap: () => _openWorkout(context, ref, progress.workoutId),
                  ),
                  SizedBox(height: spacing),
                ],
                // Was a level row plus a separate category row (and before
                // that, a level row plus two more rows each under their own
                // "Iron Training"/"General Fitness" label) — three stacked
                // filter rows before a single workout was visible. Now one
                // scrollable row: level chips, a thin divider, then every
                // category value ("All" first), equipment-heavy ones next.
                // Both filters still write to the same two providers as
                // before, just laid out together instead of stacked.
                SizedBox(
                  height: 36,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount:
                        WorkoutLevel.values.length +
                        1 +
                        _kAllCategories.length +
                        1,
                    separatorBuilder: (_, _) => const SizedBox(width: 8),
                    itemBuilder: (context, index) {
                      if (index < WorkoutLevel.values.length) {
                        final tabLevel = WorkoutLevel.values[index];
                        return WorkoutPill(
                          label: _label(l10n, tabLevel),
                          selected: tabLevel == level,
                          appearance: WorkoutPillAppearance.filter,
                          onTap:
                              () => ref
                                  .read(workoutTabProvider.notifier)
                                  .select(tabLevel),
                        );
                      }
                      if (index == WorkoutLevel.values.length) {
                        return Center(
                          child: Container(
                            width: 1,
                            height: 18,
                            color: ext.glassBorder,
                          ),
                        );
                      }
                      final categoryIndex =
                          index - WorkoutLevel.values.length - 1;
                      final value =
                          categoryIndex == 0
                              ? null
                              : _kAllCategories[categoryIndex - 1];
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
                if (items.isNotEmpty) ...[
                  SizedBox(height: spacing),
                  PremiumSectionHeader(title: l10n.workoutFeaturedTitle),
                  SizedBox(height: compact ? 8 : 12),
                  _WorkoutHeroCarousel(
                    items: items,
                    level: level,
                    height: heroHeight,
                    onOpen: (id) => _openWorkout(context, ref, id),
                  ),
                ],
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
                  progressFraction:
                      progress != null &&
                              !progress.isComplete &&
                              progress.workoutId == items[index].id
                          ? progress.fraction
                          : null,
                ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 8)),
        ],
      ),
    );
  }

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

/// The "continue where you left off" card — shown above the filters when
/// [WorkoutLocalProgress] has a real, locally-tracked in-progress session
/// (see `WorkoutProgressEntry`; never a fabricated percentage).
class _ContinueWorkoutCard extends StatelessWidget {
  const _ContinueWorkoutCard({required this.entry, required this.onTap});

  final WorkoutProgressEntry entry;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final ext = Theme.of(context).extension<AppThemeExtension>()!;
    final l10n = AppLocalizations.of(context);
    final languageCode = Localizations.localeOf(context).languageCode;
    final remaining = entry.totalSets - entry.completedSets;

    return PressableScale(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadius.card),
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                ext.accentGlow.withValues(alpha: 0.16),
                ext.glassFill,
              ],
              begin: AlignmentDirectional.centerStart,
              end: AlignmentDirectional.centerEnd,
            ),
            borderRadius: BorderRadius.circular(AppRadius.card),
            border: Border.all(color: ext.glassBorder),
          ),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(14),
                child: SmartImage(entry.image, width: 58, height: 58),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      l10n.workoutContinueLabel,
                      style: TextStyle(
                        color: ext.accentGlow,
                        fontWeight: FontWeight.w800,
                        fontSize: 11,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      entry.localizedTitle(languageCode),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: ext.textPrimary,
                        fontWeight: FontWeight.w800,
                        fontSize: 14.5,
                      ),
                    ),
                    const SizedBox(height: 8),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(999),
                      child: LinearProgressIndicator(
                        value: entry.fraction,
                        minHeight: 6,
                        backgroundColor: ext.glassBorder,
                        valueColor: AlwaysStoppedAnimation(ext.accentGlow),
                      ),
                    ),
                  ],
                ),
              ),
              if (remaining > 0) ...[
                const SizedBox(width: 10),
                Text(
                  l10n.workoutContinueRemaining(remaining),
                  style: TextStyle(
                    color: ext.textMuted,
                    fontWeight: FontWeight.w700,
                    fontSize: 11,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

/// A swipeable carousel of up to 3 featured workouts, each an existing
/// [FeaturedCard] with a real, backend-persisted favorite toggle (same
/// `toggleFavorite` call the list below already uses). Falls back to a
/// single static card with no swipe affordance when there's only one item.
class _WorkoutHeroCarousel extends StatefulWidget {
  const _WorkoutHeroCarousel({
    required this.items,
    required this.level,
    required this.height,
    required this.onOpen,
  });

  final List<WorkoutListItem> items;
  final WorkoutLevel level;
  final double height;
  final void Function(String workoutId) onOpen;

  @override
  State<_WorkoutHeroCarousel> createState() => _WorkoutHeroCarouselState();
}

class _WorkoutHeroCarouselState extends State<_WorkoutHeroCarousel> {
  late final PageController _controller = PageController();
  int _page = 0;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final count = math.min(widget.items.length, 3);

    Widget cardFor(int index) {
      final item = widget.items[index];
      return Consumer(
        builder: (context, ref, _) {
          return FeaturedCard(
            image: item.image,
            badge: _label(l10n, widget.level),
            title: item.localizedName(context),
            metas: [
              if (item.localizedTime(context) case final time?)
                FeaturedCardMeta(icon: AppIcons.time, label: time),
              if (item.localizedCalories(context) case final calories?)
                FeaturedCardMeta(icon: AppIcons.calories, label: calories),
              if (item.localizedExercises(context) case final exercises?)
                FeaturedCardMeta(icon: AppIcons.workout, label: exercises),
            ],
            ctaLabel: l10n.workoutStartWorkout,
            height: widget.height,
            isFavorite: item.isFavorite,
            onFavoriteTap:
                () => ref
                    .read(workoutListByLevelProvider(widget.level).notifier)
                    .toggleFavorite(index),
            onTap: () => widget.onOpen(item.id),
          );
        },
      );
    }

    if (count < 2) {
      return cardFor(0);
    }

    return Column(
      children: [
        SizedBox(
          height: widget.height,
          child: PageView.builder(
            controller: _controller,
            itemCount: count,
            onPageChanged: (page) => setState(() => _page = page),
            itemBuilder: (context, index) => cardFor(index),
          ),
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            for (var i = 0; i < count; i++) ...[
              if (i != 0) const SizedBox(width: 6),
              _CarouselDot(active: i == _page),
            ],
          ],
        ),
      ],
    );
  }
}

class _CarouselDot extends StatelessWidget {
  const _CarouselDot({required this.active});

  final bool active;

  @override
  Widget build(BuildContext context) {
    final ext = Theme.of(context).extension<AppThemeExtension>()!;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      width: active ? 16 : 6,
      height: 6,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(999),
        gradient: active ? ext.accentGradient : null,
        color: active ? null : ext.glassBorder,
      ),
    );
  }
}

