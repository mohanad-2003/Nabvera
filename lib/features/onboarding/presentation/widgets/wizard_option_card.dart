import 'package:nabvera/core/theme/app_spacing.dart';
import 'package:nabvera/core/theme/app_theme_extension.dart';
import 'package:flutter/material.dart';

/// A flat, borderless selectable row for the setup wizard's choice steps
/// (goal, activity level, equipment, time) — an icon, a label, and a short
/// one-line hint sitting directly on the wizard's background (no boxed
/// card), separated from the next option by a hairline via
/// [WizardOptionList] — same flat, on-page treatment as Create Routine's
/// `ExerciseListTile`.
///
/// The selected state is never color-only: the icon fills solid with the
/// brand gradient, the label switches weight, *and* a check/radio glyph
/// appears, so it still reads clearly for a color-blind user or in
/// grayscale.
class WizardOptionCard extends StatelessWidget {
  const WizardOptionCard({
    super.key,
    required this.icon,
    required this.label,
    required this.hint,
    required this.isSelected,
    required this.onTap,
    this.multiSelect = false,
  });

  final IconData icon;
  final String label;
  final String hint;
  final bool isSelected;
  final VoidCallback onTap;

  /// Renders a square checkbox glyph instead of a round radio glyph — a
  /// purely visual cue that this step allows more than one selection
  /// (equipment), matching the platform convention for checkbox vs. radio.
  final bool multiSelect;

  @override
  Widget build(BuildContext context) {
    final ext = Theme.of(context).extension<AppThemeExtension>()!;

    return Semantics(
      button: true,
      selected: isSelected,
      label: '$label. $hint',
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
          child: Row(
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: isSelected ? ext.accentGradient : null,
                  color: isSelected ? null : ext.glassFill,
                ),
                child: Icon(
                  icon,
                  size: 22,
                  color: isSelected ? ext.onAccent : ext.textMuted,
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      label,
                      style: TextStyle(
                        color: ext.textPrimary,
                        fontSize: 16,
                        fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      hint,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(color: ext.textMuted, fontSize: 12.5),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              _SelectionGlyph(
                isSelected: isSelected,
                multiSelect: multiSelect,
                ext: ext,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Hairline-separated list of [WizardOptionCard]s — the flat replacement
/// for a column of boxed cards.
class WizardOptionList extends StatelessWidget {
  const WizardOptionList({super.key, required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final ext = Theme.of(context).extension<AppThemeExtension>()!;
    return Column(
      children: [
        for (var i = 0; i < children.length; i++) ...[
          if (i > 0) Divider(height: 1, color: ext.glassBorder),
          children[i],
        ],
      ],
    );
  }
}

class _SelectionGlyph extends StatelessWidget {
  const _SelectionGlyph({
    required this.isSelected,
    required this.multiSelect,
    required this.ext,
  });

  final bool isSelected;
  final bool multiSelect;
  final AppThemeExtension ext;

  @override
  Widget build(BuildContext context) {
    final shape = multiSelect ? BoxShape.rectangle : BoxShape.circle;
    return Container(
      width: 24,
      height: 24,
      decoration: BoxDecoration(
        shape: shape,
        borderRadius: multiSelect ? BorderRadius.circular(6) : null,
        color: isSelected ? ext.onAccent : Colors.transparent,
        border: Border.all(
          color: isSelected ? ext.onAccent : ext.textMuted,
          width: 2,
        ),
      ),
      child:
          isSelected
              ? Icon(Icons.check_rounded, size: 15, color: ext.accentGlow)
              : null,
    );
  }
}
