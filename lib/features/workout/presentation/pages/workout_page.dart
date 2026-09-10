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

class WorkoutPage extends ConsumerWidget {
  const WorkoutPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final level = ref.watch(workoutTabProvider);
    final items = ref.watch(workoutListByLevelProvider(level));
    final request = ref.watch(workoutRequestProvider(level));
    final ext = Theme.of(context).extension<AppThemeExtension>()!;
    final l10n = AppLocalizations.of(context);
    final compact = MediaQuery.sizeOf(context).height < 720;
    final spacing = compact ? 10.0 : 14.0;
    // Sized so the header, chips, buttons, hero, section title, and at
    // least the first workout card or two all land within the first
    // viewport on typical phones — CustomScrollView still lets the page
    // scroll naturally for the rest, and on unusually short viewports,
    // rather than overflowing.
    final heroHeight = compact ? 200.0 : 230.0;
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
                const SizedBox(height: 6),
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
                  height: 40,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: WorkoutLevel.values.length,
                    separatorBuilder: (_, _) => const SizedBox(width: 10),
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
                    title: items.first.name,
                    metas: [
                      if (items.first.time != null)
                        FeaturedCardMeta(
                          icon: AppIcons.time,
                          label: items.first.time!,
                        ),
                      if (items.first.calories != null)
                        FeaturedCardMeta(
                          icon: AppIcons.calories,
                          label: items.first.calories!,
                        ),
                      FeaturedCardMeta(
                        icon: AppIcons.run,
                        label: _label(l10n, level),
                      ),
                    ],
                    ctaLabel: l10n.workoutStartWorkout,
                    height: heroHeight,
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
                  ref.invalidate(workoutRequestProvider(level));
                  ref.invalidate(workoutListByLevelProvider(level));
                },
              ),
            ),
          SliverList.separated(
            itemCount: items.length,
            separatorBuilder:
                (_, _) => Padding(
                  padding: EdgeInsets.symmetric(vertical: spacing / 2),
                  child: Divider(height: 1, color: ext.glassBorder),
                ),
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
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final ext = Theme.of(context).extension<AppThemeExtension>()!;
    final accent = ext.accentGlow;
    // Pill outline button (design-system button shape) rather than a flat
    // glass card, so these read as actions instead of content.
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppRadius.pill),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: compact ? 10 : 13),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppRadius.pill),
          border: Border.all(color: accent.withValues(alpha: 0.55), width: 1.3),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 18, color: accent),
            const SizedBox(width: 8),
            Flexible(
              child: Text(
                label,
                style: TextStyle(
                  color: ext.textPrimary,
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
