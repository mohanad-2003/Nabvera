import 'package:nabvera/core/network/app_icons.dart';
import 'package:nabvera/core/widgets/smart_image.dart';
import 'package:nabvera/core/localization/generated/app_localizations.dart';
import 'package:nabvera/core/routing/app_routes.dart';
import 'package:nabvera/core/theme/app_colors.dart';
import 'package:nabvera/core/theme/app_theme_extension.dart';
import 'package:nabvera/core/widgets/premium_scaffold.dart';
import 'package:nabvera/features/search/domain/search_models.dart';
import 'package:nabvera/features/search/presentation/providers/search_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class SearchPage extends ConsumerWidget {
  const SearchPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tab = ref.watch(searchTabControllerProvider);
    final featured = ref.watch(searchFeaturedWorkoutsProvider);
    final allResults = ref.watch(searchAllResultsProvider);
    final ext = Theme.of(context).extension<AppThemeExtension>()!;
    final l10n = AppLocalizations.of(context);

    return PremiumScaffold(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              if (context.canPop())
                PremiumIconButton(
                  icon: Icons.arrow_back_ios_new_rounded,
                  onTap: () => context.pop(),
                ),
              const SizedBox(width: 12),
              Text(
                l10n.navSearch,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: ext.textPrimary,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const Spacer(),
              PremiumIconButton(
                icon: Icons.notifications_none_rounded,
                onTap: () => context.push(AppRoutes.notifications),
              ),
              const SizedBox(width: 10),
              PremiumIconButton(
                icon: Icons.person_outline_rounded,
                onTap: () => context.go(AppRoutes.profile),
              ),
            ],
          ),
          const SizedBox(height: 18),
          Container(
            height: 52,
            decoration: BoxDecoration(
              color: ext.glassFill,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: ext.glassBorder),
            ),
            child: TextField(
              onChanged:
                  (value) => ref
                      .read(searchQueryControllerProvider.notifier)
                      .update(value),
              style: TextStyle(color: ext.textPrimary),
              cursorColor: AppColors.seedLime,
              decoration: InputDecoration(
                hintText: l10n.searchHint,
                hintStyle: TextStyle(color: ext.textMuted, fontSize: 14),
                prefixIcon: Icon(Icons.search_rounded, color: ext.textMuted),
                contentPadding: const EdgeInsets.symmetric(vertical: 14),
                border: InputBorder.none,
              ),
            ),
          ),
          const SizedBox(height: 18),
          Row(
            children: [
              for (final t in SearchTab.values) ...[
                _SearchTabPill(
                  label: _label(l10n, t),
                  selected: tab == t,
                  onTap:
                      () => ref
                          .read(searchTabControllerProvider.notifier)
                          .select(t),
                ),
                const SizedBox(width: 10),
              ],
            ],
          ),
          const SizedBox(height: 20),
          Expanded(
            child: switch (tab) {
              SearchTab.all => _AllResultsSection(
                featured: featured,
                allResults: allResults,
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
              ),
            },
          ),
        ],
      ),
    );
  }

  String _label(AppLocalizations l10n, SearchTab tab) => switch (tab) {
    SearchTab.all => l10n.searchTabAll,
    SearchTab.workoutSuggestions => l10n.searchTabWorkout,
    SearchTab.nutritionSuggestions => l10n.searchTabNutrition,
  };
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
        child: Text(
          label,
          style: TextStyle(
            color: selected ? AppColors.seedInk : ext.textPrimary,
            fontWeight: FontWeight.w800,
            fontSize: 13,
          ),
        ),
      ),
    );
  }
}

class _AllResultsSection extends StatelessWidget {
  const _AllResultsSection({required this.featured, required this.allResults});
  final List<SearchResultItem> featured;
  final List<SearchResultItem> allResults;

  @override
  Widget build(BuildContext context) {
    if (featured.isEmpty && allResults.isEmpty) {
      return const _SearchEmptyState();
    }
    return Column(
      children: [
        if (featured.isNotEmpty) ...[
          SizedBox(
            height: 180,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: featured.length,
              separatorBuilder: (_, _) => const SizedBox(width: 10),
              itemBuilder:
                  (context, index) => _FeaturedCard(item: featured[index]),
            ),
          ),
          const SizedBox(height: 20),
        ],
        Expanded(
          child:
              allResults.isEmpty
                  ? const _SearchEmptyState()
                  : ListView.separated(
                    itemCount: allResults.length,
                    separatorBuilder: (_, _) => const SizedBox(height: 12),
                    itemBuilder:
                        (context, index) =>
                            _ResultCard(item: allResults[index]),
                  ),
        ),
      ],
    );
  }
}

class _SearchEmptyState extends StatelessWidget {
  const _SearchEmptyState();

  @override
  Widget build(BuildContext context) {
    final ext = Theme.of(context).extension<AppThemeExtension>()!;
    final l10n = AppLocalizations.of(context);
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: ext.glassFill,
              border: Border.all(color: ext.glassBorder),
            ),
            child: Icon(
              Icons.search_off_rounded,
              color: ext.textMuted,
              size: 32,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            l10n.searchNoResultsTitle,
            style: TextStyle(
              color: ext.textPrimary,
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            l10n.searchNoResultsBody,
            textAlign: TextAlign.center,
            style: TextStyle(color: ext.textMuted, fontSize: 13),
          ),
        ],
      ),
    );
  }
}

class _SuggestionsSection extends StatelessWidget {
  const _SuggestionsSection({
    required this.title,
    required this.icon,
    required this.suggestions,
  });
  final String title;
  final IconData icon;
  final List<String> suggestions;

  @override
  Widget build(BuildContext context) {
    final ext = Theme.of(context).extension<AppThemeExtension>()!;
    return ListView(
      children: [
        Text(
          title,
          style: const TextStyle(
            color: AppColors.seedLime,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 15),
        for (final s in suggestions)
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Container(
              height: 50,
              padding: const EdgeInsets.symmetric(horizontal: 15),
              decoration: BoxDecoration(
                color: ext.glassFill,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: ext.glassBorder),
              ),
              child: Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [AppColors.seedLime, AppColors.electricOrange],
                      ),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(icon, color: AppColors.seedInk, size: 20),
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: Text(
                      s,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: ext.textPrimary,
                      ),
                    ),
                  ),
                  Icon(
                    Icons.north_west_rounded,
                    color: ext.textMuted,
                    size: 18,
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}

class _FeaturedCard extends StatelessWidget {
  const _FeaturedCard({required this.item});
  final SearchResultItem item;

  @override
  Widget build(BuildContext context) {
    final ext = Theme.of(context).extension<AppThemeExtension>()!;
    return Container(
      width: 198,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: ext.glassFill,
        border: Border.all(color: ext.glassBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Stack(
              clipBehavior: Clip.none,
              alignment: Alignment.center,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: SmartImage(
                    item.image,
                    width: double.infinity,
                    height: double.infinity,
                  ),
                ),
                const Positioned(
                  top: 8,
                  right: 8,
                  child: Icon(Icons.star, color: AppColors.seedLime),
                ),
                Positioned(
                  bottom: -15,
                  right: 8,
                  child: Container(
                    width: 32,
                    height: 32,
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [AppColors.seedLime, AppColors.electricOrange],
                      ),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.play_arrow_rounded,
                      color: AppColors.seedInk,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.name,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.seedLime,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    SmartImage(AppIcons.time, width: 9, height: 9),
                    const SizedBox(width: 4),
                    Flexible(
                      child: Text(
                        item.time,
                        style: TextStyle(fontSize: 12, color: ext.textMuted),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 10),
                    SmartImage(AppIcons.calories, width: 9, height: 9),
                    const SizedBox(width: 4),
                    Flexible(
                      child: Text(
                        item.calories,
                        style: TextStyle(fontSize: 12, color: ext.textMuted),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ResultCard extends StatelessWidget {
  const _ResultCard({required this.item});
  final SearchResultItem item;

  @override
  Widget build(BuildContext context) {
    final ext = Theme.of(context).extension<AppThemeExtension>()!;
    return Container(
      height: 100,
      decoration: BoxDecoration(
        color: ext.glassFill,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: ext.glassBorder),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Flexible(
                    child: Text(
                      item.name,
                      style: TextStyle(
                        color: ext.textPrimary,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(height: 6),
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
                          item.time,
                          style: TextStyle(fontSize: 12, color: ext.textMuted),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 12),
                      const Icon(
                        Icons.local_fire_department_outlined,
                        size: 14,
                        color: AppColors.seedLime,
                      ),
                      const SizedBox(width: 4),
                      Flexible(
                        child: Text(
                          item.calories,
                          style: TextStyle(fontSize: 12, color: ext.textMuted),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  if (item.exercises != null) ...[
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
                            item.exercises!,
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
          ),
          Expanded(
            flex: 1,
            child: ClipRRect(
              borderRadius: const BorderRadius.horizontal(
                right: Radius.circular(20),
              ),
              child: SmartImage(
                item.image,
                width: double.infinity,
                height: double.infinity,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
