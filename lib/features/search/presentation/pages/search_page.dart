import 'package:nabvera/core/localization/generated/app_localizations.dart';
import 'package:nabvera/core/routing/app_routes.dart';
import 'package:nabvera/core/theme/app_theme_extension.dart';
import 'package:nabvera/core/widgets/premium_scaffold.dart';
import 'package:nabvera/core/widgets/smart_image.dart';
import 'package:nabvera/features/nutrition/data/nutrition_repository.dart';
import 'package:nabvera/features/nutrition/domain/nutrition_models.dart';
import 'package:nabvera/features/search/domain/search_models.dart';
import 'package:nabvera/features/search/presentation/providers/search_controller.dart';
import 'package:nabvera/features/workout/data/workout_repository.dart';
import 'package:nabvera/features/workout/domain/exercise_detail_models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

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
    final tab = ref.watch(searchTabControllerProvider);
    final featured = ref.watch(searchFeaturedWorkoutsProvider);
    final results = ref.watch(searchAllResultsProvider);
    final ext = Theme.of(context).extension<AppThemeExtension>()!;
    final l10n = AppLocalizations.of(context);

    return PremiumScaffold(
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 760),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  if (context.canPop())
                    _SearchHeaderButton(
                      isBack: true,
                      onTap: () => context.pop(),
                    ),
                  if (context.canPop()) const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      l10n.navSearch,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(
                        context,
                      ).textTheme.headlineSmall?.copyWith(
                        color: ext.textPrimary,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                  _SearchHeaderButton(
                    icon: Icons.notifications_none_rounded,
                    onTap: () => context.push(AppRoutes.notifications),
                  ),
                  const SizedBox(width: 4),
                  _SearchHeaderButton(
                    icon: Icons.person_outline_rounded,
                    onTap: () => context.go(AppRoutes.profile),
                  ),
                ],
              ),
              const SizedBox(height: 18),
              _SearchField(),
              const SizedBox(height: 18),
              SizedBox(
                height: 42,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: SearchTab.values.length,
                  separatorBuilder: (_, _) => const SizedBox(width: 10),
                  itemBuilder: (context, index) {
                    final t = SearchTab.values[index];
                    return _SearchTabPill(
                      label: _label(l10n, t),
                      selected: tab == t,
                      onTap:
                          () => ref
                              .read(searchTabControllerProvider.notifier)
                              .select(t),
                    );
                  },
                ),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: switch (tab) {
                  SearchTab.all => _AllResultsSection(
                    featured: featured,
                    results: results,
                    onTap: (item) => _openResult(context, ref, item),
                  ),
                  SearchTab.workoutSuggestions => _SuggestionsSection(
                    title: l10n.searchWorkoutSuggestions,
                    icon: Icons.fitness_center_rounded,
                    suggestions: const [
                      'Circuit',
                      'Split',
                      'Challenge',
                      'Legs',
                      'Cardio',
                    ],
                    onTap: (s) {
                      ref
                          .read(searchQueryControllerProvider.notifier)
                          .update(s);
                      ref
                          .read(searchTabControllerProvider.notifier)
                          .select(SearchTab.all);
                    },
                  ),
                  SearchTab.nutritionSuggestions => _SuggestionsSection(
                    title: l10n.searchNutritionSuggestions,
                    icon: Icons.restaurant_rounded,
                    suggestions: const [
                      'Breakfast',
                      'Yogurt',
                      'Vegetarian',
                      'Smoothie',
                      'Chicken',
                    ],
                    onTap: (s) {
                      ref
                          .read(searchQueryControllerProvider.notifier)
                          .update(s);
                      ref
                          .read(searchTabControllerProvider.notifier)
                          .select(SearchTab.all);
                    },
                  ),
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _label(AppLocalizations l10n, SearchTab tab) => switch (tab) {
    SearchTab.all => l10n.searchTabAll,
    SearchTab.workoutSuggestions => l10n.searchTabWorkout,
    SearchTab.nutritionSuggestions => l10n.searchTabNutrition,
  };
}

/// Flat header action: a full-size tap target without a surrounding card.
class _SearchHeaderButton extends StatelessWidget {
  const _SearchHeaderButton({
    required this.onTap,
    this.icon,
    this.isBack = false,
  }) : assert(isBack || icon != null);

  final IconData? icon;
  final bool isBack;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final ext = Theme.of(context).extension<AppThemeExtension>()!;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: SizedBox.square(
        dimension: 44,
        child: IconTheme(
          data: IconThemeData(color: ext.textPrimary, size: 22),
          child: isBack ? const BackButtonIcon() : Icon(icon),
        ),
      ),
    );
  }
}

/// The search box itself — a clear (×) button appears once there's text to
/// clear, and the field autofocuses so a user landing here can start
/// typing immediately, the way a dedicated search screen should.
class _SearchField extends ConsumerStatefulWidget {
  @override
  ConsumerState<_SearchField> createState() => _SearchFieldState();
}

class _SearchFieldState extends ConsumerState<_SearchField> {
  late final _controller = TextEditingController(
    text: ref.read(searchQueryControllerProvider),
  );

  @override
  void dispose() {
    _controller.dispose();
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

    return Container(
      height: 54,
      decoration: BoxDecoration(
        // A faint tint of the page's own text color rather than
        // [AppThemeExtension.glassFill] (near-opaque white in light mode,
        // reading as a thick white card) — keeps the field visibly on top
        // of the page background without boxing it in.
        color: ext.textPrimary.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: ext.glassBorder),
      ),
      child: TextField(
        controller: _controller,
        autofocus: true,
        onChanged:
            (value) =>
                ref.read(searchQueryControllerProvider.notifier).update(value),
        style: TextStyle(color: ext.textPrimary),
        cursorColor: ext.accentGlow,
        decoration: InputDecoration(
          hintText: l10n.searchHint,
          hintStyle: TextStyle(color: ext.textMuted, fontSize: 14),
          prefixIcon: Icon(Icons.search_rounded, color: ext.textMuted),
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
          contentPadding: const EdgeInsets.symmetric(vertical: 14),
          border: InputBorder.none,
        ),
      ),
    );
  }
}

class _SearchTabPill extends StatelessWidget {
  const _SearchTabPill({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final ext = Theme.of(context).extension<AppThemeExtension>()!;
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 9),
        decoration: BoxDecoration(
          // Solid accentGlow rather than the fixed lime→orange gradient:
          // accentGlow already swaps to a deep, readable tone in light mode
          // (accentOnLight) instead of the washed-out neon the gradient
          // produced there, while staying the familiar lime in dark mode.
          color: selected ? ext.accentGlow : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: selected ? Colors.transparent : ext.glassBorder,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: selected ? ext.onAccentGlow : ext.textPrimary,
            fontWeight: FontWeight.w800,
            fontSize: 13,
          ),
        ),
      ),
    );
  }
}

class _AllResultsSection extends StatelessWidget {
  const _AllResultsSection({
    required this.featured,
    required this.results,
    required this.onTap,
  });

  final List<SearchResultItem> featured;
  final SearchResults results;
  final ValueChanged<SearchResultItem> onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    // "No results" only ever appears for a search that actually ran and
    // came back empty — never just because the query box is still empty
    // (that used to show under the featured strip on the very first
    // frame, before the user had typed anything at all).
    final showNoResultsMessage =
        results.hasSearched && !results.isLoading && results.items.isEmpty;

    if (featured.isEmpty && showNoResultsMessage) {
      return _SearchEmptyState(
        title: l10n.searchNoResultsTitle,
        body: l10n.searchNoResultsBody,
      );
    }
    if (featured.isEmpty && results.items.isEmpty && !results.isLoading) {
      return _SearchEmptyState(
        title: l10n.searchStartTypingTitle,
        body: l10n.searchStartTypingBody,
      );
    }

    return ListView(
      children: [
        if (featured.isNotEmpty) ...[
          LayoutBuilder(
            builder: (context, constraints) {
              final itemWidth =
                  (constraints.maxWidth * .72).clamp(220.0, 290.0).toDouble();
              return SizedBox(
                height: 238,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: featured.length,
                  separatorBuilder: (_, _) => const SizedBox(width: 14),
                  itemBuilder:
                      (context, index) => _FeaturedResult(
                        item: featured[index],
                        width: itemWidth,
                        onTap: () => onTap(featured[index]),
                      ),
                ),
              );
            },
          ),
          const SizedBox(height: 20),
        ],
        if (results.isLoading)
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 24),
            child: Center(child: CircularProgressIndicator()),
          )
        else if (showNoResultsMessage)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 24),
            child: _InlineEmptyMessage(
              title: l10n.searchNoResultsTitle,
              body: l10n.searchNoResultsBody,
            ),
          )
        else
          for (final item in results.items) ...[
            _ResultTile(item: item, onTap: () => onTap(item)),
            const Divider(height: 1),
          ],
      ],
    );
  }
}

class _SearchEmptyState extends StatelessWidget {
  const _SearchEmptyState({required this.title, required this.body});

  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    return Center(child: _InlineEmptyMessage(title: title, body: body));
  }
}

class _InlineEmptyMessage extends StatelessWidget {
  const _InlineEmptyMessage({required this.title, required this.body});

  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    final ext = Theme.of(context).extension<AppThemeExtension>()!;
    return Column(
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
    );
  }
}

class _SuggestionsSection extends StatelessWidget {
  const _SuggestionsSection({
    required this.title,
    required this.icon,
    required this.suggestions,
    required this.onTap,
  });
  final String title;
  final IconData icon;
  final List<String> suggestions;
  final ValueChanged<String> onTap;

  @override
  Widget build(BuildContext context) {
    final ext = Theme.of(context).extension<AppThemeExtension>()!;
    return ListView(
      children: [
        Text(
          title,
          style: TextStyle(
            color: ext.textPrimary,
            fontSize: 18,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 6),
        for (final s in suggestions) ...[
          const Divider(height: 1),
          InkWell(
            onTap: () => onTap(s),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 14),
              child: Row(
                children: [
                  Container(
                    width: 38,
                    height: 38,
                    decoration: BoxDecoration(
                      gradient: ext.accentGradient,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(icon, color: ext.onAccent, size: 18),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Text(
                      s,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: ext.textPrimary,
                      ),
                    ),
                  ),
                  Icon(
                    Icons.north_east_rounded,
                    color: ext.textMuted,
                    size: 16,
                  ),
                ],
              ),
            ),
          ),
        ],
      ],
    );
  }
}

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
      borderRadius: BorderRadius.circular(16),
      child: SizedBox(
        width: width,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Stack(
                clipBehavior: Clip.none,
                alignment: Alignment.center,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: SmartImage(
                      item.image,
                      width: double.infinity,
                      height: double.infinity,
                    ),
                  ),
                  PositionedDirectional(
                    top: 8,
                    end: 8,
                    child: Icon(Icons.star, color: ext.accentGlow),
                  ),
                  PositionedDirectional(
                    bottom: 10,
                    end: 10,
                    child: Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        gradient: ext.accentGradient,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.play_arrow_rounded,
                        color: ext.onAccent,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10, left: 2, right: 2),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.localizedName(context),
                    style: TextStyle(
                      fontSize: 14,
                      color: ext.textPrimary,
                      fontWeight: FontWeight.w800,
                    ),
                    maxLines: 2,
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
                        color: ext.textMuted,
                      ),
                      _SearchMeta(
                        icon: Icons.local_fire_department_outlined,
                        label: _calorieLabel(l10n, item),
                        color: ext.accentGlow,
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

/// Flat, hairline-separated result row — replaces the previous boxed
/// glass card, same on-background treatment as the rest of the app.
class _ResultTile extends StatelessWidget {
  const _ResultTile({required this.item, required this.onTap});
  final SearchResultItem item;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final ext = Theme.of(context).extension<AppThemeExtension>()!;
    final l10n = AppLocalizations.of(context);
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(14),
              child: SmartImage(item.image, width: 68, height: 68),
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
                        color: ext.textMuted,
                      ),
                      _SearchMeta(
                        icon: Icons.local_fire_department_outlined,
                        label: _calorieLabel(l10n, item),
                        color: ext.accentGlow,
                      ),
                    ],
                  ),
                  if (item.exerciseCount != null) ...[
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(
                          Icons.repeat_rounded,
                          size: 14,
                          color: ext.textMuted,
                        ),
                        const SizedBox(width: 4),
                        Flexible(
                          child: Text(
                            l10n.homeHeroExercises(item.exerciseCount!),
                            style: TextStyle(
                              fontSize: 12,
                              color: ext.textMuted,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
            Icon(Icons.chevron_right_rounded, color: ext.textMuted),
          ],
        ),
      ),
    );
  }
}

class _SearchMeta extends StatelessWidget {
  const _SearchMeta({
    required this.icon,
    required this.label,
    required this.color,
  });

  final IconData icon;
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14, color: color),
        const SizedBox(width: 4),
        Text(
          label,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontSize: 12,
            color: Theme.of(context).extension<AppThemeExtension>()!.textMuted,
          ),
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
