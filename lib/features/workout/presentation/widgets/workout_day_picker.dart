import 'package:nabvera/core/theme/app_theme_extension.dart';
import 'package:nabvera/features/workout/domain/workout_models.dart';
import 'package:flutter/material.dart';

/// Weekly day picker: 7 circular chips (Mon–Sun), neon-filled when selected.
/// Each chip fills an equal [Expanded] share of the available width and
/// stays circular via [AspectRatio], capped by [ConstrainedBox] so it
/// doesn't balloon on tablets; the label shrinks under large text scaling
/// via [FittedBox] instead of overflowing.
class WorkoutDayPicker extends StatelessWidget {
  const WorkoutDayPicker({
    super.key,
    required this.selectedDays,
    required this.onToggle,
    required this.shortLabelBuilder,
  });

  final Set<Weekday> selectedDays;
  final ValueChanged<Weekday> onToggle;
  final String Function(Weekday day) shortLabelBuilder;

  @override
  Widget build(BuildContext context) {
    final ext = Theme.of(context).extension<AppThemeExtension>()!;
    return Row(
      children: [
        for (final day in Weekday.values)
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 3),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 54),
                  child: AspectRatio(
                    aspectRatio: 1,
                    child: _DayChip(
                      label: shortLabelBuilder(day),
                      selected: selectedDays.contains(day),
                      onTap: () => onToggle(day),
                      ext: ext,
                    ),
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}

class _DayChip extends StatelessWidget {
  const _DayChip({
    required this.label,
    required this.selected,
    required this.onTap,
    required this.ext,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;
  final AppThemeExtension ext;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeOut,
        width: double.infinity,
        height: double.infinity,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: selected ? Theme.of(context).extension<AppThemeExtension>()!.accentGlow : ext.glassFill,
          shape: BoxShape.circle,
          border: Border.all(
            color: selected ? Colors.transparent : ext.glassBorder,
          ),

        ),
        child: Padding(
          padding: const EdgeInsets.all(4),
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              label,
              maxLines: 1,
              style: TextStyle(
                color: selected ? ext.onAccentGlow : ext.textMuted,
                fontWeight: FontWeight.w800,
                fontSize: 11.5,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
