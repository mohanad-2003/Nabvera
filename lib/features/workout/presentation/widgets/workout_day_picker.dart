import 'package:nabvera/core/theme/app_theme_extension.dart';
import 'package:nabvera/features/workout/domain/workout_models.dart';
import 'package:flutter/material.dart';

/// Weekly day picker with flat, compact options. Unselected days blend into
/// the page instead of creating seven white cards; selection uses a compact
/// rounded rectangle that remains easy to spot and tap.
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
                  constraints: const BoxConstraints(
                    minHeight: 44,
                    maxWidth: 58,
                  ),
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
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeOut,
        width: double.infinity,
        height: 44,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: selected ? ext.accentGlow : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color:
                selected
                    ? ext.accentGlow
                    : ext.glassBorder.withValues(alpha: .45),
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
