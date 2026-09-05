import 'package:nabvera/core/localization/generated/app_localizations.dart';
import 'package:nabvera/core/routing/app_routes.dart';
import 'package:nabvera/core/widgets/fade_slide_in.dart';
import 'package:nabvera/core/widgets/premium_scaffold.dart';
import 'package:nabvera/features/workout/domain/exercise_detail_models.dart';
import 'package:nabvera/features/workout/domain/workout_models.dart';
import 'package:nabvera/features/workout/presentation/providers/your_routine_controller.dart';
import 'package:nabvera/features/workout/presentation/widgets/workout_banner.dart';
import 'package:nabvera/features/workout/presentation/widgets/workout_card.dart';
import 'package:nabvera/features/workout/presentation/widgets/workout_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class YourRoutinePage extends ConsumerStatefulWidget {
  const YourRoutinePage({super.key});

  @override
  ConsumerState<YourRoutinePage> createState() => _YourRoutinePageState();
}

class _YourRoutinePageState extends ConsumerState<YourRoutinePage> {
  MuscleGroup _filter = MuscleGroup.all;

  String _categoryLabel(MuscleGroup group, AppLocalizations l10n) {
    switch (group) {
      case MuscleGroup.all:
        return l10n.workoutCategoryAll;
      case MuscleGroup.chest:
        return l10n.workoutCategoryChest;
      case MuscleGroup.back:
        return l10n.workoutCategoryBack;
      case MuscleGroup.legs:
        return l10n.workoutCategoryLegs;
      case MuscleGroup.arms:
        return l10n.workoutCategoryArms;
      case MuscleGroup.cardio:
        return l10n.workoutCategoryCardio;
      case MuscleGroup.strength:
        return l10n.workoutCategoryStrength;
    }
  }

  @override
  Widget build(BuildContext context) {
    final routine = ref.watch(yourRoutineControllerProvider);
    final controller = ref.read(yourRoutineControllerProvider.notifier);

    final l10n = AppLocalizations.of(context);

    final filtered =
        _filter == MuscleGroup.all
            ? routine
            : routine.where((item) => item.muscleGroup == _filter).toList();

    return PremiumScaffold(
      child: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: FadeSlideIn(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  WorkoutHeader(
                    title: l10n.workoutYourRoutineTitle,
                    subtitle: l10n.workoutYourRoutineSubtitle,
                    showProfileAction: true,
                  ),
                  const SizedBox(height: 16),
                  WorkoutBanner(
                    title: l10n.workoutBannerTitle,
                    body: l10n.workoutBannerBody,
                    ctaLabel: l10n.workoutBannerCta,
                    onTap: () {
                      if (filtered.isNotEmpty) {
                        final item = filtered.first;
                        context.push(
                          AppRoutes.exerciseDetail,
                          extra: ExerciseDetailData(
                            headerTitle: l10n.workoutYourRoutineTitle,
                            heroImage: item.image,
                            title: item.title,
                            duration: item.time,
                            reps: item.rep,
                            videoUrl: item.videoUrl,
                          ),
                        );
                      }
                    },
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    height: 40,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: MuscleGroup.values.length,
                      separatorBuilder: (_, __) => const SizedBox(width: 8),
                      itemBuilder: (context, index) {
                        final group = MuscleGroup.values[index];
                        return PremiumPill(
                          label: _categoryLabel(group, l10n),
                          selected: _filter == group,
                          onTap: () => setState(() => _filter = group),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
          SliverGrid(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 0.88,
            ),
            delegate: SliverChildBuilderDelegate((context, index) {
              final item = filtered[index];
              return WorkoutCard(
                image: item.image,
                title: item.title,
                time: item.time,
                reps: item.rep,
                isFavorite: item.isFavorite,
                onFavoriteTap:
                    () => controller.toggleFavorite(routine.indexOf(item)),
                actionIcon: Icons.play_arrow_rounded,
                onActionTap:
                    () => context.push(
                      AppRoutes.exerciseDetail,
                      extra: ExerciseDetailData(
                        headerTitle: l10n.workoutYourRoutineTitle,
                        heroImage: item.image,
                        title: item.title,
                        duration: item.time,
                        reps: item.rep,
                        videoUrl: item.videoUrl,
                      ),
                    ),
                onTap:
                    () => context.push(
                      AppRoutes.exerciseDetail,
                      extra: ExerciseDetailData(
                        headerTitle: l10n.workoutYourRoutineTitle,
                        heroImage: item.image,
                        title: item.title,
                        duration: item.time,
                        reps: item.rep,
                        videoUrl: item.videoUrl,
                      ),
                    ),
              );
            }, childCount: filtered.length),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 8)),
        ],
      ),
    );
  }
}
