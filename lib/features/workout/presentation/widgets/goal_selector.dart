import 'workout_surface.dart';
import 'package:nabvera/features/workout/domain/workout_models.dart';
import 'package:flutter/material.dart';

/// Wrap of selectable goal pills (Muscle Gain / Fat Loss / Strength /
/// Endurance) used in the routine info card.
class GoalSelector extends StatelessWidget {
  const GoalSelector({
    super.key,
    required this.selected,
    required this.onChanged,
    required this.labelBuilder,
  });

  final RoutineGoal? selected;
  final ValueChanged<RoutineGoal> onChanged;
  final String Function(RoutineGoal goal) labelBuilder;

  @override
  Widget build(BuildContext context) {
    const spacing = 8.0;
    return LayoutBuilder(
      builder: (context, constraints) {
        // 2 pills/row on narrow cards (phones), 4/row once the card is wide
        // enough (tablets, or a phone in landscape) to fit them cleanly.
        final columns = constraints.maxWidth >= 460 ? 4 : 2;
        final itemWidth =
            (constraints.maxWidth - spacing * (columns - 1)) / columns;
        return Wrap(
          spacing: spacing,
          runSpacing: spacing,
          children: [
            for (final goal in RoutineGoal.values)
              SizedBox(
                width: itemWidth,
                child: WorkoutPill(
                  label: labelBuilder(goal),
                  selected: selected == goal,
                  onTap: () => onChanged(goal),
                ),
              ),
          ],
        );
      },
    );
  }
}
