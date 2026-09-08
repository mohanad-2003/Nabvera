import 'package:nabvera/core/theme/app_theme_extension.dart';
import 'package:nabvera/core/widgets/smart_image.dart';
import 'package:flutter/material.dart';

/// Flat row for the "My Routine" reorderable list: thumbnail, name,
/// editable sets/reps steppers, remove action, and a drag handle. No card
/// box/border/shadow — rows are separated by a hairline divider drawn by
/// the parent list.
class SelectedExerciseItem extends StatelessWidget {
  const SelectedExerciseItem({
    super.key,
    required this.image,
    required this.name,
    required this.sets,
    required this.reps,
    required this.setsLabel,
    required this.repsLabel,
    required this.onSetsChanged,
    required this.onRepsChanged,
    required this.onRemove,
    this.dragHandle,
  });

  final String image;
  final String name;
  final int sets;
  final int reps;
  final String setsLabel;
  final String repsLabel;
  final ValueChanged<int> onSetsChanged;
  final ValueChanged<int> onRepsChanged;
  final VoidCallback onRemove;
  final Widget? dragHandle;

  @override
  Widget build(BuildContext context) {
    final ext = Theme.of(context).extension<AppThemeExtension>()!;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          if (dragHandle != null) ...[dragHandle!, const SizedBox(width: 6)],
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: SmartImage(image, width: 50, height: 50),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: ext.textPrimary,
                    fontWeight: FontWeight.w800,
                    fontSize: 13.5,
                  ),
                ),
                const SizedBox(height: 6),
                Wrap(
                  spacing: 8,
                  runSpacing: 6,
                  children: [
                    _Stepper(
                      label: setsLabel,
                      value: sets,
                      onChanged: onSetsChanged,
                      ext: ext,
                    ),
                    _Stepper(
                      label: repsLabel,
                      value: reps,
                      onChanged: onRepsChanged,
                      ext: ext,
                    ),
                  ],
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: onRemove,
            icon: Icon(Icons.close_rounded, color: ext.danger, size: 20),
          ),
        ],
      ),
    );
  }
}

class _Stepper extends StatelessWidget {
  const _Stepper({
    required this.label,
    required this.value,
    required this.onChanged,
    required this.ext,
  });

  final String label;
  final int value;
  final ValueChanged<int> onChanged;
  final AppThemeExtension ext;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: ext.glassFill,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: ext.glassBorder),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _StepButton(icon: Icons.remove_rounded, onTap: () => onChanged(-1)),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 56),
            child: Text(
              '$value $label',
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: ext.textMuted,
                fontSize: 10.5,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          _StepButton(icon: Icons.add_rounded, onTap: () => onChanged(1)),
        ],
      ),
    );
  }
}

class _StepButton extends StatelessWidget {
  const _StepButton({required this.icon, required this.onTap});

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(4),
        child: Icon(
          icon,
          size: 13,
          color: Theme.of(context).extension<AppThemeExtension>()!.accentGlow,
        ),
      ),
    );
  }
}
