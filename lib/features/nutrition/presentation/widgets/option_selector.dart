import 'package:fitness_app/core/theme/app_theme_extension.dart';
import 'package:fitness_app/core/widgets/selectable_option_card.dart';
import 'package:flutter/material.dart';

/// Redesigned radio-style option list, previously duplicated six times
/// across the meal-plan wizard with fragile `MediaQuery.width` math for
/// sizing. Full-width choices (`itemWidthFraction >= 1`) reuse the shared,
/// premium [SelectableOptionCard]; compact multi-choice groups render as a
/// wrapping row of pill chips that size to their content.
class OptionSelector extends StatelessWidget {
  const OptionSelector({
    super.key,
    required this.options,
    required this.selected,
    required this.onSelected,
    this.itemWidthFraction = 0.5,
  });

  final List<String> options;
  final String selected;
  final ValueChanged<String> onSelected;

  /// Kept for call-site compatibility: >= 1 renders full-width rows,
  /// anything smaller renders a wrap of compact chips.
  final double itemWidthFraction;

  @override
  Widget build(BuildContext context) {
    if (itemWidthFraction >= 1) {
      return Column(
        children: [
          for (final option in options) ...[
            SelectableOptionCard(
              label: option,
              isSelected: option == selected,
              onTap: () => onSelected(option),
            ),
            if (option != options.last) const SizedBox(height: 12),
          ],
        ],
      );
    }

    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: [
        for (final option in options)
          _OptionChip(
            label: option,
            selected: option == selected,
            onTap: () => onSelected(option),
          ),
      ],
    );
  }
}

class _OptionChip extends StatelessWidget {
  const _OptionChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final ext = Theme.of(context).extension<AppThemeExtension>()!;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeOut,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          gradient: selected ? ext.accentGradient : null,
          color: selected ? null : ext.glassFill,
          borderRadius: BorderRadius.circular(999),
          border: Border.all(
            color: selected ? Colors.transparent : ext.glassBorder,
          ),
          boxShadow: [
            if (selected)
              BoxShadow(
                color: ext.accentGlow.withValues(alpha: 0.24),
                blurRadius: 16,
                offset: const Offset(0, 8),
              ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (selected) ...[
              Icon(Icons.check_rounded, size: 16, color: ext.onAccent),
              const SizedBox(width: 6),
            ],
            Text(
              label,
              style: TextStyle(
                color: selected ? ext.onAccent : ext.textPrimary,
                fontWeight: FontWeight.w700,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
