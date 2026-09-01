import 'package:fitness_app/core/theme/app_spacing.dart';
import 'package:fitness_app/core/theme/app_theme_extension.dart';
import 'package:fitness_app/core/widgets/pressable_scale.dart';
import 'package:fitness_app/core/widgets/smart_image.dart';
import 'package:flutter/material.dart';

import 'workout_info_chip.dart';

/// Premium immersive hero card for a featured/recommended workout: full-
/// bleed image, gradient scrim, a gradient category badge, a floating
/// favorite toggle, duration/calories/difficulty chips, and a "Start
/// Workout" CTA. Replaces the old hero `Stack` that was duplicated inline
/// in the recommended-workout page.
class WorkoutHeroCard extends StatefulWidget {
  const WorkoutHeroCard({
    super.key,
    required this.image,
    required this.categoryLabel,
    required this.duration,
    required this.calories,
    required this.difficulty,
    required this.ctaLabel,
    this.onTap,
    this.height = 320,
  });

  final String image;
  final String categoryLabel;
  final String duration;
  final String calories;
  final String difficulty;
  final String ctaLabel;
  final VoidCallback? onTap;
  final double height;

  @override
  State<WorkoutHeroCard> createState() => _WorkoutHeroCardState();
}

class _WorkoutHeroCardState extends State<WorkoutHeroCard> {
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
          width: double.infinity,
          height: widget.height,
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppRadius.card + 6),
            border: Border.all(color: Colors.white.withValues(alpha: 0.12)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.32),
                blurRadius: 32,
                offset: const Offset(0, 18),
              ),
            ],
          ),
          child: Stack(
            fit: StackFit.expand,
            children: [
              SmartImage(widget.image),
              Positioned.fill(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.transparent,
                        Colors.transparent,
                        Colors.black.withValues(alpha: 0.88),
                      ],
                      stops: const [0, 0.42, 1],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                ),
              ),
              PositionedDirectional(
                top: 16,
                start: 16,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    gradient: ext.accentGradient,
                    borderRadius: BorderRadius.circular(999),
                    boxShadow: [
                      BoxShadow(
                        color: ext.accentGlow.withValues(alpha: 0.3),
                        blurRadius: 18,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Text(
                    widget.categoryLabel,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w900,
                      color: ext.onAccent,
                      letterSpacing: 0.3,
                    ),
                  ),
                ),
              ),
              PositionedDirectional(
                top: 14,
                end: 14,
                child: GestureDetector(
                  onTap: () => setState(() => _isFavorite = !_isFavorite),
                  child: Container(
                    width: 42,
                    height: 42,
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.36),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.2),
                      ),
                    ),
                    child: Icon(
                      _isFavorite
                          ? Icons.star_rounded
                          : Icons.star_border_rounded,
                      color: _isFavorite ? ext.accentGlow : Colors.white,
                      size: 22,
                    ),
                  ),
                ),
              ),
              PositionedDirectional(
                start: 18,
                end: 18,
                bottom: widget.onTap != null ? 82 : 20,
                child: Wrap(
                  spacing: 10,
                  runSpacing: 8,
                  children: [
                    WorkoutInfoChip(
                      icon: Icons.timer_outlined,
                      label: widget.duration,
                    ),
                    WorkoutInfoChip(
                      icon: Icons.local_fire_department_rounded,
                      label: widget.calories,
                      iconColor: theme.colorScheme.secondary,
                    ),
                    WorkoutInfoChip(
                      icon: Icons.speed_rounded,
                      label: widget.difficulty,
                      background: difficultyColor.withValues(alpha: 0.28),
                      iconColor: difficultyColor,
                      textColor: Colors.white,
                    ),
                  ],
                ),
              ),
              if (widget.onTap != null)
                PositionedDirectional(
                  start: 18,
                  end: 18,
                  bottom: 18,
                  child: SizedBox(
                    height: 50,
                    child: ElevatedButton.icon(
                      onPressed: widget.onTap,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.black,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(999),
                        ),
                      ),
                      icon: const Icon(Icons.play_arrow_rounded, size: 22),
                      label: Text(
                        widget.ctaLabel,
                        style: const TextStyle(
                          fontWeight: FontWeight.w800,
                          fontSize: 15,
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
