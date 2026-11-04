import 'package:flutter/material.dart';
import 'package:nabvera/core/localization/generated/app_localizations.dart';
import 'package:nabvera/core/theme/app_spacing.dart';
import 'package:nabvera/core/theme/app_theme_extension.dart';
import 'package:nabvera/core/widgets/pressable_scale.dart';
import 'package:nabvera/core/widgets/smart_image.dart';
import 'package:nabvera/features/workout/domain/workout_models.dart';

/// A workout row rendered as a soft glass card: thumbnail, name, meta chips,
/// favorite toggle and a trailing affordance — an intrinsic-height row so
/// metadata wraps instead of clipping on small phones.
class WorkoutListCard extends StatelessWidget {
  const WorkoutListCard({
    super.key,
    required this.item,
    required this.onToggleFavorite,
    this.onTap,
    this.height = 117,
    this.progressFraction,
  });
  final WorkoutListItem item;
  final VoidCallback onToggleFavorite;
  final VoidCallback? onTap;
  final double height;

  /// 0..1 completion of the real in-progress session for this workout (see
  /// `WorkoutProgressEntry`) — null when this workout has no active
  /// session, which hides the ring entirely (today's unchanged look).
  final double? progressFraction;

  // Presentation-only covers keyed by the original backend title, so Arabic
  // localization and navigation still use the unchanged workout data.
  static const _programCovers = <String, String>{
    'arm day': 'assets/workout_covers/arm_day.png',
    'post-workout cooldown stretch':
        'assets/workout_covers/post_workout_stretch.png',
    'full body stretch & recover': 'assets/workout_covers/stretch_recover.png',
    'morning yoga flow': 'assets/workout_covers/morning_yoga.png',
    'full body starter': 'assets/workout_covers/full_body_starter.png',
    'chest day': 'assets/workout_covers/chest_day.png',
    'chest day (advanced)': 'assets/workout_covers/chest_day.png',
    'upper body strength': 'assets/workout_covers/chest_day.png',
    'back day': 'assets/workout_covers/back_day.png',
    'back day (advanced)': 'assets/workout_covers/back_day.png',
    'pull day': 'assets/workout_covers/back_day.png',
    'shoulder day': 'assets/workout_covers/shoulder_day.png',
    'shoulder day (advanced)': 'assets/workout_covers/shoulder_day.png',
    'arm day (advanced)': 'assets/workout_covers/arm_day.png',
    'lower body strength': 'assets/workout_covers/lower_body_strength.png',
    'iron legs': 'assets/workout_covers/lower_body_strength.png',
    'cardio burnout': 'assets/workout_covers/cardio_burnout.png',
    'circuit conditioning': 'assets/workout_covers/circuit_conditioning.png',
    'yoga for strength & balance':
        'assets/workout_covers/yoga_strength_balance.png',
  };

  @override
  Widget build(BuildContext context) {
    final ext = Theme.of(context).extension<AppThemeExtension>()!;
    return PressableScale(
      enabled: onTap != null,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(AppRadius.card),
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: height),
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: ext.glassFill,
                borderRadius: BorderRadius.circular(AppRadius.card),
                border: Border.all(color: ext.glassBorder),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Stack(
                    clipBehavior: Clip.none,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(14),
                        child: SmartImage(
                          _programCovers[item.name.trim().toLowerCase()] ??
                              item.image,
                          width: 76,
                          height: 88,
                        ),
                      ),
                      if (progressFraction case final fraction?)
                        PositionedDirectional(
                          bottom: -4,
                          end: -4,
                          child: Container(
                            width: 24,
                            height: 24,
                            padding: const EdgeInsets.all(3),
                            decoration: BoxDecoration(
                              color: ext.glassFill,
                              shape: BoxShape.circle,
                              border: Border.all(color: ext.glassBorder),
                            ),
                            child: CircularProgressIndicator(
                              value: fraction,
                              strokeWidth: 2.5,
                              color: ext.accentGlow,
                              backgroundColor: ext.glassBorder,
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          item.localizedName(context),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: ext.textPrimary,
                            fontWeight: FontWeight.w800,
                            fontSize: 15.5,
                            height: 1.2,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Wrap(
                          spacing: 8,
                          runSpacing: 6,
                          children: [
                            if (item.localizedTime(context) case final time?)
                              _MetaChip(
                                icon: Icons.schedule_rounded,
                                label: time,
                                ext: ext,
                              ),
                            if (item.localizedCalories(context)
                                case final calories?)
                              _MetaChip(
                                icon: Icons.local_fire_department_rounded,
                                label: calories,
                                ext: ext,
                              ),
                            if (item.localizedExercises(context)
                                case final exercises?)
                              _MetaChip(
                                icon: Icons.fitness_center_rounded,
                                label: exercises,
                                ext: ext,
                              ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    visualDensity: VisualDensity.compact,
                    onPressed: onToggleFavorite,
                    tooltip: AppLocalizations.of(context).favoriteTitle,
                    icon: Icon(
                      item.isFavorite
                          ? Icons.star_rounded
                          : Icons.star_border_rounded,
                      color: item.isFavorite ? ext.accentGlow : ext.textMuted,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _MetaChip extends StatelessWidget {
  const _MetaChip({required this.icon, required this.label, required this.ext});

  final IconData icon;
  final String label;
  final AppThemeExtension ext;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: ext.accentGlow.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(AppRadius.pill),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: ext.accentGlow),
          const SizedBox(width: 4),
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: ext.textMuted,
              fontSize: 11.5,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
