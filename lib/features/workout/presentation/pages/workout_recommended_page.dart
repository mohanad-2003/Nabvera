import 'package:nabvera/core/localization/generated/app_localizations.dart';
import 'package:nabvera/core/responsive/app_responsive.dart';
import 'package:nabvera/core/routing/app_routes.dart';
import 'package:nabvera/core/theme/app_theme_extension.dart';
import 'package:nabvera/core/widgets/fade_slide_in.dart';
import 'package:nabvera/core/widgets/premium_scaffold.dart';
import 'package:nabvera/features/workout/domain/exercise_detail_models.dart';
import 'package:nabvera/features/workout/presentation/providers/popular_exercises_controller.dart';
import 'package:nabvera/features/workout/presentation/widgets/popular_workout_card.dart';
import 'package:nabvera/features/workout/presentation/widgets/workout_hero_card.dart';
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
    final featuredData =
        featured ??
        ExerciseDetailData(
          headerTitle: l10n.workoutRecommendationsTitle,
          heroImage: 'assets/dum.png',
          title: 'Dumbbell Step Up',
          duration: '12 Minute',
          reps: '120 Kcal',
        );
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
                child: WorkoutHeroCard(
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

/// Bespoke header for this screen: a glass back button, the full
/// (never-truncated) title, and glass search/notification actions —
/// reuses [PremiumIconButton] for the consistent rounded/glassmorphism
/// look already established across the app.
class _RecommendedTopBar extends StatelessWidget {
  const _RecommendedTopBar({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    final ext = Theme.of(context).extension<AppThemeExtension>()!;

    return Row(
      children: [
        if (context.canPop())
          PremiumIconButton(
            icon: Icons.arrow_back_ios_new_rounded,
            onTap: () => context.pop(),
          ),
        if (context.canPop()) const SizedBox(width: 12),
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
        const SizedBox(width: 10),
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
    );
  }
}
