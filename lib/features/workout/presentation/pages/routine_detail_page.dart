import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:nabvera/core/localization/generated/app_localizations.dart';
import 'package:nabvera/core/routing/app_routes.dart';
import 'package:nabvera/core/theme/app_theme_extension.dart';
import 'package:nabvera/core/widgets/smart_image.dart';
import 'package:nabvera/features/workout/domain/exercise_detail_models.dart';
import '../widgets/workout_surface.dart';

class RoutineSummary extends StatelessWidget {
  const RoutineSummary({super.key, required this.routine});
  final Map<String, dynamic> routine;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final ext = Theme.of(context).extension<AppThemeExtension>()!;
    final count = (routine['exercises'] as List? ?? const []).length;
    final difficulty = switch (routine['difficulty']) {
      'beginner' => l10n.workoutLevelBeginner,
      'intermediate' => l10n.workoutLevelIntermediate,
      'advanced' => l10n.workoutLevelAdvanced,
      _ => null,
    };
    final goal = switch (routine['goal']) {
      'gain_muscle' => l10n.routineGoalMuscleGain,
      'lose_weight' => l10n.routineGoalFatLoss,
      'keep_fit' => l10n.routineGoalStrength,
      'endurance' => l10n.routineGoalEndurance,
      _ => null,
    };
    return Wrap(
      spacing: 12,
      runSpacing: 8,
      children: [
        Text(
          '$count ${l10n.createRoutineSummaryExercises}',
          style: TextStyle(color: ext.textMuted),
        ),
        if (difficulty != null)
          Text(difficulty, style: TextStyle(color: ext.accentGlow)),
        if (goal != null) Text(goal, style: TextStyle(color: ext.textMuted)),
        if (routine['durationMinutes'] != null)
          Text(
            '${routine['durationMinutes']} ${l10n.createRoutineSummaryDuration}',
            style: TextStyle(color: ext.textMuted),
          ),
      ],
    );
  }
}

class RoutineDetailPage extends StatelessWidget {
  const RoutineDetailPage({super.key, required this.routine});
  final Map<String, dynamic> routine;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final ext = Theme.of(context).extension<AppThemeExtension>()!;
    // Sort a copy; never mutate the response used by the parent list.
    final entries = [...(routine['exercises'] as List? ?? const [])]..sort(
      (a, b) =>
          ((a['order'] as num?) ?? 0).compareTo((b['order'] as num?) ?? 0),
    );
    return WorkoutScaffold(
      child: ListView(
        children: [
          Align(
            alignment: AlignmentDirectional.centerStart,
            child: WorkoutBackButton(
              onTap: () => Navigator.of(context).pop(),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            routine['name'] as String? ?? '',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              color: ext.textPrimary,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 12),
          if (routine['description'] case final String description
              when description.isNotEmpty) ...[
            Text(description, style: TextStyle(color: ext.textMuted)),
            const SizedBox(height: 12),
          ],
          RoutineSummary(routine: routine),
          const SizedBox(height: 28),
          Text(
            l10n.createRoutineSummaryExercises,
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 12),
          if (entries.isEmpty) const WorkoutStatus(),
          for (var i = 0; i < entries.length; i++) ...[
            if (entries[i]['exercise'] case final Map<String, dynamic> exercise)
              ListTile(
                contentPadding: const EdgeInsets.symmetric(vertical: 12),
                leading: ClipRRect(
                  borderRadius: BorderRadius.circular(14),
                  child:
                      exercise['imageUrl'] is String
                          ? SmartImage(
                            exercise['imageUrl'] as String,
                            width: 56,
                            height: 56,
                          )
                          : SizedBox(
                            width: 56,
                            height: 56,
                            child: Icon(
                              Icons.fitness_center,
                              color: ext.accentGlow,
                            ),
                          ),
                ),
                title: Text('${i + 1}. ${exercise['name'] ?? ''}'),
                subtitle: Text(
                  [
                    if (entries[i]['sets'] != null)
                      '${entries[i]['sets']} ${l10n.createRoutineSetsLabel}',
                    if (entries[i]['reps'] != null)
                      '${entries[i]['reps']} ${l10n.createRoutineRepsLabel}',
                  ].join(' • '),
                ),
                trailing: Icon(
                  Icons.play_circle_outline_rounded,
                  color: ext.accentGlow,
                ),
                onTap:
                    () => context.push(
                      AppRoutes.exerciseDetail,
                      extra: ExerciseDetailData(
                        headerTitle: routine['name'] as String? ?? '',
                        heroImage: exercise['imageUrl'] as String? ?? '',
                        title: exercise['name'] as String? ?? '',
                        // Falls back to the generic tip (not blank text)
                        // for an exercise that has no description yet —
                        // an explicitly-passed '' bypasses the
                        // constructor's own default (see
                        // ExerciseDetailData.defaultDescription).
                        description:
                            (exercise['description'] as String?)
                                        ?.isNotEmpty ==
                                    true
                                ? exercise['description'] as String
                                : ExerciseDetailData.defaultDescription,
                        descriptionAr:
                            exercise['descriptionAr'] as String? ?? '',
                        duration:
                            entries[i]['sets'] == null
                                ? ''
                                : '${entries[i]['sets']} ${l10n.createRoutineSetsLabel}',
                        reps:
                            entries[i]['reps'] == null
                                ? ''
                                : '${entries[i]['reps']} ${l10n.createRoutineRepsLabel}',
                        muscleGroup: exercise['muscleGroup'] as String? ?? '',
                        equipment: exercise['equipment'] as String? ?? '',
                        level: exercise['difficulty'] as String? ?? '',
                        videoUrl: exercise['videoUrl'] as String?,
                      ),
                    ),
              )
            else
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: Text(
                  workoutCopy(
                    context,
                    'هذا التمرين غير متاح حاليًا.',
                    'This exercise is currently unavailable.',
                  ),
                  style: TextStyle(color: ext.textMuted),
                ),
              ),
            if (i < entries.length - 1)
              Divider(height: 1, thickness: .5, color: ext.glassBorder),
          ],
        ],
      ),
    );
  }
}
