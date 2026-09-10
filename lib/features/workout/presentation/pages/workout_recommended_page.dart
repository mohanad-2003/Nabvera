import 'package:nabvera/core/localization/generated/app_localizations.dart';
import 'package:nabvera/core/responsive/app_responsive.dart';
import 'package:nabvera/core/routing/app_routes.dart';
import 'package:nabvera/core/theme/app_spacing.dart';
import 'package:nabvera/core/theme/app_theme_extension.dart';
import 'package:nabvera/core/widgets/fade_slide_in.dart';
import 'package:nabvera/core/widgets/premium_scaffold.dart';
import 'package:nabvera/features/workout/domain/exercise_detail_models.dart';
import 'package:nabvera/features/workout/presentation/providers/popular_exercises_controller.dart';
import 'package:nabvera/features/workout/presentation/widgets/popular_workout_card.dart';
import 'package:nabvera/features/workout/presentation/widgets/workout_hero_card.dart';
import 'package:nabvera/features/workout/presentation/widgets/workout_surface.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class WorkoutRecommendedPage extends ConsumerWidget {
  const WorkoutRecommendedPage({super.key, this.featured});

  final ExerciseDetailData? featured;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final popular = ref.watch(popularExercisesProvider);
    final l10n = AppLocalizations.of(context);
    // Prefer the real, most-popular exercise for the hero card — the
    // hardcoded "Dumbbell Step Up" placeholder (local asset, fake stats)
    // only ever showed because this route never actually passed `featured`,
    // so every visit saw the same fake content regardless of real data.
    final firstPopular = popular.isEmpty ? null : popular.first;
    final featuredData =
        featured ??
        (firstPopular == null
            ? null
            : ExerciseDetailData(
              headerTitle: l10n.workoutRecommendationsTitle,
              heroImage: firstPopular.image,
              title: firstPopular.name,
              duration: firstPopular.time,
              reps: firstPopular.calories,
              level: firstPopular.difficulty,
              videoUrl: firstPopular.videoUrl,
            ));
    final heroHeight = context.responsive(
      compact: 260.0,
      standard: 320.0,
      medium: 360.0,
      expanded: 400.0,
    );

    return PremiumScaffold(
      padding: EdgeInsets.zero,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 10,
              ),
              child: _RecommendedTopBar(title: l10n.workoutRecommendationsTitle),
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
              child: FadeSlideIn(
                child:
                    featuredData == null
                        ? _HeroPlaceholder(height: heroHeight)
                        : WorkoutHeroCard(
                          image: featuredData.heroImage,
                          categoryLabel: featuredData.title,
                          duration: featuredData.duration,
                          calories: featuredData.reps,
                          difficulty: featuredData.level,
                          ctaLabel: l10n.workoutStartWorkout,
                          height: heroHeight,
                          onTap:
                              () => context.push(
                                AppRoutes.exerciseDetail,
                                extra: featuredData,
                              ),
                        ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  FadeSlideIn(
                    delay: const Duration(milliseconds: 90),
                    child: PremiumSectionHeader(title: l10n.workoutMostPopular),
                  ),
                  const SizedBox(height: 14),
                  FadeSlideIn(
                    delay: const Duration(milliseconds: 140),
                    child: GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate:
                          const SliverGridDelegateWithMaxCrossAxisExtent(
                            maxCrossAxisExtent: 220,
                            childAspectRatio: 0.8,
                            crossAxisSpacing: 14,
                            mainAxisSpacing: 20,
                          ),
                      itemCount: popular.length,
                      itemBuilder: (context, index) {
                        final item = popular[index];
                        return PopularWorkoutCard(
                          image: item.image,
                          name: item.name,
                          duration: item.time,
                          calories: item.calories,
                          difficulty: item.difficulty,
                          onTap:
                              () => context.push(
                                AppRoutes.exerciseDetail,
                                extra: ExerciseDetailData(
                                  headerTitle: l10n.workoutRecommendationsTitle,
                                  heroImage: item.image,
                                  title: item.name,
                                  duration: item.time,
                                  reps: item.calories,
                                  level: item.difficulty,
                                  videoUrl: item.videoUrl,
                                ),
                              ),
                        );
                      },
                    ),
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

/// Shown in the hero card's place while the real popular-exercises request
/// is still in flight (or came back empty) — a plain glass block instead of
/// either an empty gap or (as before) a hardcoded fake exercise card.
class _HeroPlaceholder extends StatelessWidget {
  const _HeroPlaceholder({required this.height});

  final double height;

  @override
  Widget build(BuildContext context) {
    final ext = Theme.of(context).extension<AppThemeExtension>()!;
    return Container(
      width: double.infinity,
      height: height,
      decoration: BoxDecoration(
        color: ext.glassFill,
        borderRadius: BorderRadius.circular(AppRadius.card + 6),
        border: Border.all(color: ext.glassBorder),
      ),
      alignment: Alignment.center,
      child: SizedBox(
        width: 28,
        height: 28,
        child: CircularProgressIndicator(
          strokeWidth: 2.5,
          color: ext.accentGlow,
        ),
      ),
    );
  }
}

/// Bespoke header for this screen: a bare (unboxed) back button, the full
/// (never-truncated) title, and bare search/notification icons — plain
/// icons directly on the page background rather than [PremiumIconButton]'s
/// glass pill, per this screen's flatter look.
class _RecommendedTopBar extends StatelessWidget {
  const _RecommendedTopBar({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    final ext = Theme.of(context).extension<AppThemeExtension>()!;

    return Row(
      children: [
        if (context.canPop())
          WorkoutBackButton(
            onTap: () => context.pop(),
          ),
        if (context.canPop()) const SizedBox(width: 6),
        Expanded(
          child: Text(
            title,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              color: ext.textPrimary,
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
        _BareIconButton(
          icon: Icons.search_rounded,
          onTap: () => context.push(AppRoutes.search),
        ),
        _BareIconButton(
          icon: Icons.notifications_none_rounded,
          onTap: () => context.push(AppRoutes.notifications),
        ),
      ],
    );
  }
}

/// A plain, unboxed icon button — no glass fill/border behind it, just the
/// icon itself with a tap target and ripple.
class _BareIconButton extends StatelessWidget {
  const _BareIconButton({required this.icon, required this.onTap});

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final ext = Theme.of(context).extension<AppThemeExtension>()!;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Icon(icon, color: ext.textPrimary, size: 22),
      ),
    );
  }
}
