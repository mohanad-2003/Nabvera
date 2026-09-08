import 'package:nabvera/core/theme/app_colors.dart';
import 'package:nabvera/features/workout/presentation/widgets/workout_surface.dart';
import 'package:nabvera/core/localization/generated/app_localizations.dart';
import 'package:nabvera/core/theme/app_theme_extension.dart';
import 'package:nabvera/core/widgets/primary_button.dart';
import 'package:nabvera/core/widgets/smart_image.dart';
import 'package:nabvera/features/workout/domain/exercise_detail_models.dart';
import 'package:nabvera/features/workout/presentation/widgets/exercise_video_player.dart';
import 'package:nabvera/features/workout/presentation/widgets/workout_header.dart';
import 'package:flutter/material.dart';

/// Generic exercise video/detail screen — replaces the legacy squat_page,
/// kettlball, video_advance, details_page, and details_dumple_setup, which
/// were the same layout copy-pasted with different hardcoded strings.
class ExerciseDetailPage extends StatefulWidget {
  const ExerciseDetailPage({super.key, required this.data});

  final ExerciseDetailData data;

  @override
  State<ExerciseDetailPage> createState() => _ExerciseDetailPageState();
}

class _ExerciseDetailPageState extends State<ExerciseDetailPage> {
  final _videoKey = GlobalKey<ExerciseVideoPlayerState>();
  final _scrollController = ScrollController();

  ExerciseDetailData get data => widget.data;

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _startWorkout(BuildContext context, AppLocalizations l10n) {
    if (data.videoUrl == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(l10n.workoutNoVideoAvailable)));
      return;
    }
    _scrollController.animateTo(
      0,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
    _videoKey.currentState?.play();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final ext = theme.extension<AppThemeExtension>()!;
    final l10n = AppLocalizations.of(context);

    return WorkoutScaffold(
      padding: EdgeInsets.zero,
      bottomBar: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 16),
          child: PrimaryButton(
            showShadow: false,
            label: l10n.workoutStartWorkout,
            icon: Icons.play_arrow_rounded,
            onPressed: () => _startWorkout(context, l10n),
          ),
        ),
      ),
      child: SingleChildScrollView(
        controller: _scrollController,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
              child: WorkoutHeader(title: data.headerTitle),
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: AspectRatio(
                aspectRatio: 16 / 10,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(24),
                      child:
                          data.videoUrl == null
                              ? Hero(
                                tag: data.heroImage,
                                child: SmartImage(data.heroImage),
                              )
                              : ExerciseVideoPlayer(
                                key: _videoKey,
                                videoUrl: data.videoUrl!,
                                poster: SmartImage(data.heroImage),
                              ),
                    ),
                    IgnorePointer(
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(24),
                          gradient: LinearGradient(
                            colors: [
                              AppColors.seedInk.withValues(alpha: 0),
                              AppColors.seedInk.withValues(alpha: 0),
                              AppColors.seedInk.withValues(alpha: 0.55),
                            ],
                            stops: const [0, 0.5, 1],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      left: 16,
                      bottom: 16,
                      right: 16,
                      child: Text(
                        data.title,
                        style: theme.textTheme.headlineSmall?.copyWith(
                          color: AppColors.lightSurface,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 22),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    workoutCopy(context, 'نظرة عامة', 'Overview'),
                    style: TextStyle(
                      color: ext.accentGlow,
                      fontSize: 13,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 0.3,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    data.description,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: ext.textMuted,
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 22),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: _InfoStat(
                          icon: Icons.fitness_center_rounded,
                          label: l10n.workoutMuscleGroupLabel,
                          value: data.muscleGroup,
                          ext: ext,
                        ),
                      ),
                      Expanded(
                        child: _InfoStat(
                          icon: Icons.trending_up_rounded,
                          label: l10n.workoutDifficultyLabel,
                          value: data.level,
                          ext: ext,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Divider(height: 1, color: ext.glassBorder),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: _InfoStat(
                          icon: Icons.timer_outlined,
                          label: data.duration,
                          value: data.reps,
                          ext: ext,
                        ),
                      ),
                      Expanded(
                        child: _InfoStat(
                          icon: Icons.handyman_outlined,
                          label: l10n.workoutEquipmentLabel,
                          value: data.equipment,
                          ext: ext,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

class _InfoStat extends StatelessWidget {
  const _InfoStat({
    required this.icon,
    required this.label,
    required this.value,
    required this.ext,
  });

  final IconData icon;
  final String label;
  final String value;
  final AppThemeExtension ext;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 38,
          height: 38,
          decoration: BoxDecoration(
            color: ext.accentGlow.withValues(alpha: 0.14),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: ext.accentGlow, size: 19),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                value,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: ext.textPrimary,
                  fontWeight: FontWeight.w800,
                  fontSize: 13.5,
                ),
              ),
              Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(color: ext.textMuted, fontSize: 11),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
