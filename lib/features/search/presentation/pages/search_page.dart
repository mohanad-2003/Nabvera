import 'package:nabvera/core/localization/generated/app_localizations.dart';
import 'package:nabvera/core/routing/app_routes.dart';
import 'package:nabvera/core/theme/app_radius_shadows.dart';
import 'package:nabvera/core/theme/app_spacing.dart';
import 'package:nabvera/core/theme/app_theme_extension.dart';
import 'package:nabvera/core/widgets/premium_scaffold.dart';
import 'package:nabvera/core/widgets/smart_image.dart';
import 'package:nabvera/features/nutrition/data/nutrition_repository.dart';
import 'package:nabvera/features/nutrition/domain/nutrition_models.dart';
import 'package:nabvera/features/search/domain/search_models.dart';
import 'package:nabvera/features/search/presentation/providers/search_controller.dart';
import 'package:nabvera/features/workout/data/workout_repository.dart';
import 'package:nabvera/features/workout/domain/exercise_detail_models.dart';
import 'package:nabvera/features/workout/presentation/widgets/workout_surface.dart'
    show WorkoutPill, WorkoutPillAppearance;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// One merged suggestion chip — tapping it fills the query and, for a
/// typed term, pre-selects the matching results filter so the first
/// frame of results is already narrowed to what the chip promised.
class _Suggestion {
  const _Suggestion(this.label, this.type);
  final String label;
  final SearchResultType type;
}

/// Opens the real workout/recipe a [SearchResultItem] points to — same
/// fetch-by-id-then-push pattern as Home's `_openWorkout`/Nutrition's
/// `_openRecipe`, so a search result is never a dead tap.
Future<void> _openResult(
  BuildContext context,
  WidgetRef ref,
  SearchResultItem item,
) async {
  if (item.id.isEmpty) return;
  try {
    switch (item.type) {
      case SearchResultType.workout:
        final json = await ref
            .read(workoutRepositoryProvider)
            .fetchWorkoutById(item.id);
        if (!context.mounted) return;
        context.push(
          AppRoutes.workoutCategoryDetail,
          extra: CategoryDetailData.fromWorkoutJson(json),
        );
      case SearchResultType.nutrition:
        final json = await ref
            .read(nutritionRepositoryProvider)
            .fetchRecipeById(item.id);
        if (!context.mounted) return;
        context.push(AppRoutes.mealDetail, extra: MealDetail.fromJson(json));
    }
  } catch (_) {
    // Backend unreachable / item deleted since the search ran — silently
    // do nothing, matching Home/Nutrition's own handling of this.
  }
}

class SearchPage extends ConsumerWidget {
  const SearchPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final query = ref.watch(searchQueryControllerProvider);
    final tab = ref.watch(searchTabControllerProvider);
    final featured = ref.watch(searchFeaturedWorkoutsProvider);
    final results = ref.watch(searchAllResultsProvider);
    final l10n = AppLocalizations.of(context);

    final visibleItems =
        tab == SearchTab.all
            ? results.items
            : results.items
                .where(
                  (item) =>
                      item.type ==
                      (tab == SearchTab.workouts
                          ? SearchResultType.workout
                          : SearchResultType.nutrition),
                )
                .toList();

    return PremiumScaffold(
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 760),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _SearchHeader(query: query),
              const SizedBox(height: 16),
              if (query.isEmpty)
                Expanded(
                  child: _DiscoverSection(
                    featured: featured,
                    onTapFeatured: (item) => _openResult(context, ref, item),
                    onTapSuggestion: (s) {
                      ref
                          .read(searchQueryControllerProvider.notifier)
                          .update(s.label);
                      ref
                          .read(searchTabControllerProvider.notifier)
                          .select(
                            s.type == SearchResultType.workout
                                ? SearchTab.workouts
                                : SearchTab.nutrition,
                          );
                    },
                  ),
                )
              else ...[
                Row(
                  children: [
                    WorkoutPill(
                      label: l10n.searchTabAll,
                      selected: tab == SearchTab.all,
                      appearance: WorkoutPillAppearance.filter,
                      onTap:
                          () => ref
                              .read(searchTabControllerProvider.notifier)
                              .select(SearchTab.all),
                    ),
                    const SizedBox(width: 8),
                    WorkoutPill(
                      label: l10n.searchTabWorkout,
                      selected: tab == SearchTab.workouts,
                      appearance: WorkoutPillAppearance.filter,
                      onTap:
                          () => ref
                              .read(searchTabControllerProvider.notifier)
                              .select(SearchTab.workouts),
                    ),
                    const SizedBox(width: 8),
                    WorkoutPill(
                      label: l10n.searchTabNutrition,
                      selected: tab == SearchTab.nutrition,
                      appearance: WorkoutPillAppearance.filter,
                      onTap:
                          () => ref
                              .read(searchTabControllerProvider.notifier)
                              .select(SearchTab.nutrition),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: _ResultsSection(
                    results: results,
                    items: visibleItems,
                    onTap: (item) => _openResult(context, ref, item),
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

/// Back button (when there's somewhere to go back to) plus the search
/// field itself — no separate page title. The field is the page's one
/// job, so it's the largest, first thing on screen instead of competing
/// with a headline above it.
class _SearchHeader extends StatelessWidget {
  const _SearchHeader({required this.query});

  final String query;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (context.canPop())
          Padding(
            padding: const EdgeInsets.only(bottom: 4),
            child: _BackButton(onTap: () => context.pop()),
          ),
        const _SearchField(),
      ],
    );
  }
}

class _BackButton extends StatelessWidget {
  const _BackButton({required this.onTap});
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final ext = Theme.of(context).extension<AppThemeExtension>()!;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: SizedBox.square(
        dimension: 40,
        child: IconTheme(
          data: IconThemeData(color: ext.textPrimary, size: 20),
          child: const BackButtonIcon(),
        ),
      ),
    );
  }
}

/// The search box — a clear (×) button appears once there's text to clear,
/// autofocuses so typing can start immediately, and its border/icon glow
/// amber while focused so the one field on this page visibly announces
/// when it's ready for input.
class _SearchField extends ConsumerStatefulWidget {
  const _SearchField();

  @override
  ConsumerState<_SearchField> createState() => _SearchFieldState();
}

class _SearchFieldState extends ConsumerState<_SearchField> {
  late final _controller = TextEditingController(
    text: ref.read(searchQueryControllerProvider),
  );
  final _focusNode = FocusNode();
  bool _focused = false;

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() {
      setState(() => _focused = _focusNode.hasFocus);
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ext = Theme.of(context).extension<AppThemeExtension>()!;
    final l10n = AppLocalizations.of(context);
    final hasText = ref.watch(
      searchQueryControllerProvider.select((q) => q.isNotEmpty),
    );
    ref.listen<String>(searchQueryControllerProvider, (previous, next) {
      if (_controller.text == next) return;
      _controller.value = TextEditingValue(
        text: next,
        selection: TextSelection.collapsed(offset: next.length),
      );
    });

    return AnimatedContainer(
      duration: const Duration(milliseconds: 180),
      height: 60,
      decoration: BoxDecoration(
        color: ext.glassFill,
        borderRadius: BorderRadius.circular(AppRadius.pill),
        border: Border.all(
          color: _focused ? ext.accentGlow : ext.glassBorder,
          width: _focused ? 1.6 : 1,
        ),
        boxShadow:
            _focused
                ? [
                  BoxShadow(
                    color: ext.accentGlow.withValues(alpha: 0.22),
                    blurRadius: 22,
                    spreadRadius: 1,
                  ),
                ]
                : AppShadows.floating(Theme.of(context).brightness),
      ),
      child: TextField(
        controller: _controller,
        focusNode: _focusNode,
        autofocus: true,
        onChanged:
            (value) =>
                ref.read(searchQueryControllerProvider.notifier).update(value),
        style: TextStyle(color: ext.textPrimary, fontWeight: FontWeight.w600),
        cursorColor: ext.accentGlow,
        decoration: InputDecoration(
          hintText: l10n.searchHint,
          hintStyle: TextStyle(color: ext.textMuted, fontSize: 14),
          prefixIcon: Icon(
            Icons.search_rounded,
            color: _focused ? ext.accentGlow : ext.textMuted,
          ),
          suffixIcon:
              hasText
                  ? IconButton(
                    icon: Icon(Icons.close_rounded, color: ext.textMuted),
                    onPressed: () {
                      _controller.clear();
                      ref
                          .read(searchQueryControllerProvider.notifier)
                          .update('');
                    },
                  )
                  : null,
          contentPadding: const EdgeInsets.symmetric(vertical: 16),
          border: InputBorder.none,
        ),
      ),
    );
  }
}

/// Shown while the query box is empty — two featured workouts to jump
/// straight into, plus a single merged cloud of quick-search terms
/// (workouts and meals together, each with its own icon) instead of the
/// old three-way tab split.
class _DiscoverSection extends StatelessWidget {
  const _DiscoverSection({
    required this.featured,
    required this.onTapFeatured,
    required this.onTapSuggestion,
  });

  final List<SearchResultItem> featured;
  final ValueChanged<SearchResultItem> onTapFeatured;
  final ValueChanged<_Suggestion> onTapSuggestion;

  static const _suggestionKeys = [
    ('searchSuggestionCircuit', SearchResultType.workout),
    ('searchSuggestionSplit', SearchResultType.workout),
    ('searchSuggestionChallenge', SearchResultType.workout),
    ('searchSuggestionLegs', SearchResultType.workout),
    ('searchSuggestionCardio', SearchResultType.workout),
    ('searchSuggestionBreakfast', SearchResultType.nutrition),
    ('searchSuggestionYogurt', SearchResultType.nutrition),
    ('searchSuggestionVegetarian', SearchResultType.nutrition),
    ('searchSuggestionSmoothie', SearchResultType.nutrition),
    ('searchSuggestionChicken', SearchResultType.nutrition),
  ];

  @override
  Widget build(BuildContext context) {
    final ext = Theme.of(context).extension<AppThemeExtension>()!;
    final l10n = AppLocalizations.of(context);
    final suggestions = [
      for (final (key, type) in _suggestionKeys)
        _Suggestion(_suggestionLabel(l10n, key), type),
    ];

    return ListView(
      children: [
        if (featured.isNotEmpty) ...[
          Text(
            l10n.searchPopularNow,
            style: TextStyle(
              color: ext.textPrimary,
              fontSize: 17,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 12),
          LayoutBuilder(
            builder: (context, constraints) {
              final itemWidth =
                  (constraints.maxWidth * .72).clamp(220.0, 290.0).toDouble();
              return SizedBox(
                height: 220,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: featured.length,
                  separatorBuilder: (_, _) => const SizedBox(width: 14),
                  itemBuilder:
                      (context, index) => _FeaturedResult(
                        item: featured[index],
                        width: itemWidth,
                        onTap: () => onTapFeatured(featured[index]),
                      ),
                ),
              );
            },
          ),
          const SizedBox(height: 28),
        ],
        Text(
          l10n.searchTrySearching,
          style: TextStyle(
            color: ext.textPrimary,
            fontSize: 17,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: [
            for (final s in suggestions)
              _SuggestionChip(suggestion: s, onTap: () => onTapSuggestion(s)),
          ],
        ),
      ],
    );
  }

  static String _suggestionLabel(AppLocalizations l10n, String key) =>
      switch (key) {
        'searchSuggestionCircuit' => l10n.searchSuggestionCircuit,
        'searchSuggestionSplit' => l10n.searchSuggestionSplit,
        'searchSuggestionChallenge' => l10n.searchSuggestionChallenge,
        'searchSuggestionLegs' => l10n.searchSuggestionLegs,
        'searchSuggestionCardio' => l10n.searchSuggestionCardio,
        'searchSuggestionBreakfast' => l10n.searchSuggestionBreakfast,
        'searchSuggestionYogurt' => l10n.searchSuggestionYogurt,
        'searchSuggestionVegetarian' => l10n.searchSuggestionVegetarian,
        'searchSuggestionSmoothie' => l10n.searchSuggestionSmoothie,
        'searchSuggestionChicken' => l10n.searchSuggestionChicken,
        _ => key,
      };
}

class _SuggestionChip extends StatelessWidget {
  const _SuggestionChip({required this.suggestion, required this.onTap});

  final _Suggestion suggestion;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final ext = Theme.of(context).extension<AppThemeExtension>()!;
    final icon =
        suggestion.type == SearchResultType.workout
            ? Icons.fitness_center_rounded
            : Icons.restaurant_rounded;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadius.pill),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: BoxDecoration(
            color: ext.glassFill,
            borderRadius: BorderRadius.circular(AppRadius.pill),
            border: Border.all(color: ext.glassBorder),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 15, color: ext.accentGlow),
              const SizedBox(width: 7),
              Text(
                suggestion.label,
                style: TextStyle(
                  color: ext.textPrimary,
                  fontWeight: FontWeight.w700,
                  fontSize: 13,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ResultsSection extends StatelessWidget {
  const _ResultsSection({
    required this.results,
    required this.items,
    required this.onTap,
  });

  final SearchResults results;
  final List<SearchResultItem> items;
  final ValueChanged<SearchResultItem> onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final showNoResultsMessage =
        results.hasSearched && !results.isLoading && results.items.isEmpty;

    if (results.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (showNoResultsMessage) {
      return _InlineEmptyMessage(
        title: l10n.searchNoResultsTitle,
        body: l10n.searchNoResultsBody,
      );
    }

    return ListView.separated(
      itemCount: items.length,
      separatorBuilder: (_, _) => const SizedBox(height: AppSpacing.md),
      itemBuilder:
          (context, index) =>
              _ResultTile(item: items[index], onTap: () => onTap(items[index])),
    );
  }
}

class _InlineEmptyMessage extends StatelessWidget {
  const _InlineEmptyMessage({required this.title, required this.body});

  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    final ext = Theme.of(context).extension<AppThemeExtension>()!;
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.search_off_rounded, color: ext.textMuted, size: 40),
          const SizedBox(height: 16),
          Text(
            title,
            style: TextStyle(
              color: ext.textPrimary,
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            body,
            textAlign: TextAlign.center,
            style: TextStyle(color: ext.textMuted, fontSize: 13),
          ),
        ],
      ),
    );
  }
}

/// A full-bleed photo card — name and meta sit directly on the image over
/// a bottom scrim (always dark regardless of theme, matching the workout
/// hero cards elsewhere) instead of in a separate text block below it, so
/// the whole card reads as one image rather than a photo plus a caption.
class _FeaturedResult extends StatelessWidget {
  const _FeaturedResult({
    required this.item,
    required this.width,
    required this.onTap,
  });
  final SearchResultItem item;
  final double width;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final ext = Theme.of(context).extension<AppThemeExtension>()!;
    final l10n = AppLocalizations.of(context);
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(22),
      child: SizedBox(
        width: width,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(22),
          child: Stack(
            fit: StackFit.expand,
            children: [
              SmartImage(
                item.image,
                width: double.infinity,
                height: double.infinity,
              ),
              const DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Color(0x00111213),
                      Color(0x00111213),
                      Color(0xCC111213),
                      Color(0xF2111213),
                    ],
                    stops: [0, 0.42, 0.78, 1],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
              ),
              PositionedDirectional(
                top: 12,
                start: 12,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 5,
                  ),
                  decoration: BoxDecoration(
                    gradient: ext.accentGradient,
                    borderRadius: BorderRadius.circular(AppRadius.pill),
                  ),
                  child: Text(
                    l10n.workoutMostPopular,
                    style: TextStyle(
                      color: ext.onAccent,
                      fontSize: 10.5,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 0.2,
                    ),
                  ),
                ),
              ),
              PositionedDirectional(
                top: 10,
                end: 10,
                child: Container(
                  width: 30,
                  height: 30,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.16),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.3),
                    ),
                  ),
                  child: const Icon(
                    Icons.play_arrow_rounded,
                    color: Colors.white,
                    size: 18,
                  ),
                ),
              ),
              PositionedDirectional(
                bottom: 12,
                start: 12,
                end: 12,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      item.localizedName(context),
                      style: const TextStyle(
                        fontSize: 15,
                        color: Colors.white,
                        fontWeight: FontWeight.w800,
                        height: 1.2,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 12,
                      runSpacing: 4,
                      children: [
                        _SearchMeta(
                          icon: Icons.timer_outlined,
                          label: _durationLabel(l10n, item),
                          color: Colors.white.withValues(alpha: 0.82),
                          labelColor: Colors.white.withValues(alpha: 0.82),
                        ),
                        _SearchMeta(
                          icon: Icons.local_fire_department_rounded,
                          label: _calorieLabel(l10n, item),
                          color: ext.accentGlow,
                          labelColor: Colors.white.withValues(alpha: 0.82),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Elevated result card — a soft glass surface with a floating shadow,
/// with a small type badge in the corner of the thumbnail so a mixed
/// "All" list stays scannable without a column of repeated labels.
class _ResultTile extends StatelessWidget {
  const _ResultTile({required this.item, required this.onTap});
  final SearchResultItem item;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final ext = Theme.of(context).extension<AppThemeExtension>()!;
    final l10n = AppLocalizations.of(context);
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadius.card),
        child: Container(
          padding: const EdgeInsets.all(AppSpacing.md),
          decoration: BoxDecoration(
            color: ext.glassFill,
            borderRadius: BorderRadius.circular(AppRadius.card),
            border: Border.all(color: ext.glassBorder),
            boxShadow: AppShadows.floating(Theme.of(context).brightness),
          ),
          child: Row(
            children: [
              Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(14),
                    child: SmartImage(item.image, width: 68, height: 68),
                  ),
                  PositionedDirectional(
                    bottom: -2,
                    end: -2,
                    child: Container(
                      width: 22,
                      height: 22,
                      decoration: BoxDecoration(
                        color: ext.cardColor,
                        shape: BoxShape.circle,
                        border: Border.all(color: ext.glassBorder),
                      ),
                      child: Icon(
                        item.type == SearchResultType.workout
                            ? Icons.fitness_center_rounded
                            : Icons.restaurant_rounded,
                        size: 12,
                        color: ext.accentGlow,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.localizedName(context),
                      style: TextStyle(
                        color: ext.textPrimary,
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 6),
                    Wrap(
                      spacing: 12,
                      runSpacing: 6,
                      children: [
                        _SearchMeta(
                          icon: Icons.timer_outlined,
                          label: _durationLabel(l10n, item),
                        ),
                        _SearchMeta(
                          icon: Icons.local_fire_department_outlined,
                          label: _calorieLabel(l10n, item),
                          color: ext.accentGlow,
                        ),
                        if (item.exerciseCount != null)
                          _SearchMeta(
                            icon: Icons.repeat_rounded,
                            label: l10n.homeHeroExercises(item.exerciseCount!),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
              Icon(
                Directionality.of(context) == TextDirection.rtl
                    ? Icons.chevron_left_rounded
                    : Icons.chevron_right_rounded,
                color: ext.textMuted,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SearchMeta extends StatelessWidget {
  const _SearchMeta({
    required this.icon,
    required this.label,
    this.color,
    this.labelColor,
  });

  final IconData icon;
  final String label;
  final Color? color;

  /// Overrides the label's own color — needed on [_FeaturedResult], where
  /// this sits on a dark photo scrim regardless of theme rather than on
  /// the normal card surface [AppThemeExtension.textMuted] assumes.
  final Color? labelColor;

  @override
  Widget build(BuildContext context) {
    final ext = Theme.of(context).extension<AppThemeExtension>()!;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14, color: color ?? ext.textMuted),
        const SizedBox(width: 4),
        Text(
          label,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(fontSize: 12, color: labelColor ?? ext.textMuted),
        ),
      ],
    );
  }
}

String _durationLabel(AppLocalizations l10n, SearchResultItem item) =>
    item.durationMinutes == null
        ? '—'
        : l10n.nutritionMinutesValue(item.durationMinutes!);

String _calorieLabel(AppLocalizations l10n, SearchResultItem item) =>
    item.calories == null ? '—' : l10n.nutritionCaloriesValue(item.calories!);
