import 'package:nabvera/core/localization/generated/app_localizations.dart';
import 'package:nabvera/core/theme/app_spacing.dart';
import 'package:nabvera/core/theme/app_theme_extension.dart';
import 'package:nabvera/core/widgets/pressable_scale.dart';
import 'package:nabvera/core/widgets/smart_image.dart';
import 'package:nabvera/features/workout/domain/exercise_detail_models.dart';
import 'package:flutter/material.dart';

/// One exercise row during an active workout session — replaces
/// [RoundItemTile] once the user taps "Start Workout" (see
/// `CategoryDetailPage`). Adds a row of tappable set-completion pills below
/// the exercise name so a set can actually be checked off mid-session,
/// which the plain informational [RoundItemTile] has no way to do.
///
/// Tapping the leading image/name still opens [ExerciseDetailPage] (video,
/// instructions) exactly like before; tapping a pill only toggles that
/// set's completion and never navigates, so the two gestures don't fight
/// over the same row.
class SessionExerciseTile extends StatelessWidget {
  const SessionExerciseTile({
    super.key,
    required this.item,
    required this.completedSets,
    required this.onToggleSet,
    this.onOpenDetail,
  });

  final RoundExerciseItem item;

  /// Which of this exercise's sets (1-indexed) are already marked done.
  final Set<int> completedSets;

  /// Called with the 1-indexed set number that was tapped.
  final ValueChanged<int> onToggleSet;

  final VoidCallback? onOpenDetail;

  @override
  Widget build(BuildContext context) {
    final ext = Theme.of(context).extension<AppThemeExtension>()!;
    final l10n = AppLocalizations.of(context);
    final allDone = completedSets.length >= item.setsCount;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          PressableScale(
            enabled: onOpenDetail != null,
            child: InkWell(
              onTap: onOpenDetail,
              borderRadius: BorderRadius.circular(20),
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(14),
                    child:
                        item.exerciseDetail == null
                            ? Container(
                              width: 56,
                              height: 56,
                              color: ext.accentGlow.withValues(alpha: 0.12),
                              child: Icon(
                                Icons.fitness_center_rounded,
                                color: ext.accentGlow,
                              ),
                            )
                            : SmartImage(
                              item.exerciseDetail!.heroImage,
                              width: 56,
                              height: 56,
                            ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.localizedName(context),
                          style: TextStyle(
                            color: ext.textPrimary,
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                            // A finished exercise reads as done at a glance,
                            // same convention as a completed to-do item.
                            decoration:
                                allDone ? TextDecoration.lineThrough : null,
                            decorationColor: ext.textMuted,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 2),
                        Text(
                          l10n.workoutSetsProgress(
                            completedSets.length,
                            item.setsCount,
                          ),
                          style: TextStyle(
                            color: allDone ? ext.success : ext.textMuted,
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (allDone)
                    Icon(
                      Icons.check_circle_rounded,
                      color: ext.success,
                      size: 22,
                    ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              for (var setNumber = 1; setNumber <= item.setsCount; setNumber++) ...[
                if (setNumber > 1) const SizedBox(width: 8),
                _SetPill(
                  number: setNumber,
                  done: completedSets.contains(setNumber),
                  onTap: () => onToggleSet(setNumber),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}

class _SetPill extends StatelessWidget {
  const _SetPill({required this.number, required this.done, required this.onTap});

  final int number;
  final bool done;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final ext = Theme.of(context).extension<AppThemeExtension>()!;
    final color = done ? ext.success : ext.accentGlow;
    return PressableScale(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadius.pill),
        child: Container(
          width: 40,
          height: 32,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: color.withValues(alpha: done ? 0.18 : 0.10),
            borderRadius: BorderRadius.circular(AppRadius.pill),
            border: Border.all(color: color.withValues(alpha: done ? 0.7 : 0.35)),
          ),
          child:
              done
                  ? Icon(Icons.check_rounded, color: color, size: 18)
                  : Text(
                    '$number',
                    style: TextStyle(
                      color: color,
                      fontWeight: FontWeight.w800,
                      fontSize: 13,
                    ),
                  ),
        ),
      ),
    );
  }
}
