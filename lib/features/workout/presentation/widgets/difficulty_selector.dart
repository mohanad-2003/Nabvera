import 'workout_surface.dart';
import 'package:nabvera/features/workout/domain/workout_models.dart';
import 'package:flutter/material.dart';

/// Row of selectable difficulty pills (Beginner / Intermediate / Advanced)
/// used in the routine info card.
class DifficultySelector extends StatelessWidget {
  const DifficultySelector({
    super.key,
    required this.selected,
    required this.onChanged,
    required this.labelBuilder,
  });

  final WorkoutLevel? selected;
  final ValueChanged<WorkoutLevel> onChanged;
  final String Function(WorkoutLevel level) labelBuilder;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        for (final level in WorkoutLevel.values) ...[
          if (level != WorkoutLevel.values.first) const SizedBox(width: 8),
          Expanded(
            child: WorkoutPill(
              label: labelBuilder(level),
              selected: selected == level,
              onTap: () => onChanged(level),
            ),
          ),
        ],
      ],
    );
  }
}
