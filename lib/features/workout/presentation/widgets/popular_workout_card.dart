import 'package:fitness_app/core/theme/app_spacing.dart';
import 'package:fitness_app/core/theme/app_theme_extension.dart';
import 'package:fitness_app/core/widgets/pressable_scale.dart';
import 'package:fitness_app/core/widgets/smart_image.dart';
import 'package:flutter/material.dart';

import 'workout_info_chip.dart';

/// Premium grid card for the "Most Popular" workout list: image with a
/// difficulty badge and favorite toggle, a floating gradient play button,
/// then title + duration/calories underneath. Replaces the old bare-bones
/// card that only showed a title, a static star, and a plain play circle.
class PopularWorkoutCard extends StatefulWidget {
  const PopularWorkoutCard({
    super.key,
    required this.image,
    required this.name,
    required this.duration,
    required this.calories,
    this.difficulty = 'Easy',
    this.onTap,
    this.imageHeight = 116,
  });

  final String image;
  final String name;
  final String duration;
  final String calories;
  final String difficulty;
  final VoidCallback? onTap;
  final double imageHeight;

  @override
  State<PopularWorkoutCard> createState() => _PopularWorkoutCardState();
}

class _PopularWorkoutCardState extends State<PopularWorkoutCard> {
  bool _isFavorite = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final ext = theme.extension<AppThemeExtension>()!;
    final difficultyColor = workoutDifficultyColor(widget.difficulty, ext);

    return PressableScale(
      enabled: widget.onTap != null,
      child: GestureDetector(
        onTap: widget.onTap,
        child: Container(
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            color: ext.glassFill,
            borderRadius: BorderRadius.circular(AppRadius.card),
            border: Border.all(color: ext.glassBorder),
            boxShadow:
                theme.brightness == Brightness.dark
                    ? const []
                    : [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.08),
                        blurRadius: 18,
                        offset: const Offset(0, 10),
                      ),
                    ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                height: widget.imageHeight,
                width: double.infinity,
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Positioned.fill(
                      child: SmartImage(widget.image),
                    ),
                    Positioned.fill(
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Colors.transparent,
                              Colors.black.withValues(alpha: 0.35),
                            ],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                          ),
                        ),
                      ),
                    ),
                    PositionedDirectional(
                      top: 8,
                      start: 8,
                      child: WorkoutInfoChip(
                        icon: Icons.speed_rounded,
                        label: widget.difficulty,
                        background: difficultyColor.withValues(alpha: 0.85),
                      ),
                    ),
                    PositionedDirectional(
                      top: 6,
                      end: 6,
                      child: GestureDetector(
                        onTap: () => setState(() => _isFavorite = !_isFavorite),
                        child: Container(
                          width: 30,
                          height: 30,
                          decoration: BoxDecoration(
                            color: Colors.black.withValues(alpha: 0.36),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            _isFavorite
                                ? Icons.star_rounded
                                : Icons.star_border_rounded,
                            color: _isFavorite ? ext.accentGlow : Colors.white,
                            size: 16,
                          ),
                        ),
                      ),
                    ),
                    PositionedDirectional(
                      bottom: -16,
                      end: 10,
                      child: Container(
                        width: 38,
                        height: 38,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: ext.accentGradient,
                          boxShadow: [
                            BoxShadow(
                              color: ext.accentGlow.withValues(alpha: 0.35),
                              blurRadius: 14,
                              offset: const Offset(0, 6),
                            ),
                          ],
                        ),
                        child: Icon(
                          Icons.play_arrow_rounded,
                          color: ext.onAccent,
                          size: 20,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(12, 20, 12, 14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      widget.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 13,
                        color: ext.textPrimary,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(
                          Icons.timer_outlined,
                          size: 13,
                          color: ext.textMuted,
                        ),
                        const SizedBox(width: 4),
                        Flexible(
                          child: Text(
                            widget.duration,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 11,
                              color: ext.textMuted,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Icon(
                          Icons.local_fire_department_rounded,
                          size: 13,
                          color: theme.colorScheme.secondary,
                        ),
                        const SizedBox(width: 4),
                        Flexible(
                          child: Text(
                            widget.calories,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 11,
                              color: ext.textMuted,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
