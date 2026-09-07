import 'package:nabvera/core/localization/generated/app_localizations.dart';
import 'package:nabvera/core/theme/app_spacing.dart';
import 'package:nabvera/core/theme/app_theme_extension.dart';
import 'package:flutter/material.dart';

/// A large, touch-friendly numeric picker for the age/height/weight steps:
/// a big live value + unit, +/- stepper buttons for precise single-unit
/// adjustments, and a scrollable wheel for fast large jumps — all backed
/// by the same [min]/[max] bounds, so a value coming out of this widget is
/// always within range by construction (there is no free-text entry path
/// that could produce an out-of-bounds or empty value).
class WizardValueStepper extends StatefulWidget {
  const WizardValueStepper({
    super.key,
    required this.value,
    required this.min,
    required this.max,
    required this.unit,
    required this.onChanged,
    required this.semanticLabel,
  });

  final int value;
  final int min;
  final int max;
  final String unit;
  final ValueChanged<int> onChanged;

  /// Read by a screen reader in place of the raw "$value $unit" — lets
  /// callers say e.g. "Age: 28 years" instead of a bare number.
  final String semanticLabel;

  @override
  State<WizardValueStepper> createState() => _WizardValueStepperState();
}

class _WizardValueStepperState extends State<WizardValueStepper> {
  late final FixedExtentScrollController _wheelController =
      FixedExtentScrollController(initialItem: widget.value - widget.min);

  @override
  void didUpdateWidget(WizardValueStepper oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Keep the wheel in sync when the value changes from outside (e.g. a
    // +/- tap, or the controller was pre-filled from an existing profile)
    // without fighting the wheel's own drag-driven updates.
    final targetItem = widget.value - widget.min;
    if (oldWidget.value != widget.value &&
        _wheelController.hasClients &&
        _wheelController.selectedItem != targetItem) {
      _wheelController.animateToItem(
        targetItem,
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  void dispose() {
    _wheelController.dispose();
    super.dispose();
  }

  void _step(int delta) {
    final next = (widget.value + delta).clamp(widget.min, widget.max);
    if (next != widget.value) widget.onChanged(next);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final ext = theme.extension<AppThemeExtension>()!;
    final l10n = AppLocalizations.of(context);

    return Column(
      children: [
        Semantics(
          label: widget.semanticLabel,
          excludeSemantics: true,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _StepperButton(
                icon: Icons.remove_rounded,
                onTap: widget.value > widget.min ? () => _step(-1) : null,
                semanticLabel: l10n.actionDecrease,
              ),
              SizedBox(
                width: 150,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '${widget.value}',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 56,
                        fontWeight: FontWeight.w900,
                        color: ext.textPrimary,
                        height: 1,
                      ),
                    ),
                    Text(
                      widget.unit,
                      style: TextStyle(
                        color: ext.textMuted,
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
              _StepperButton(
                icon: Icons.add_rounded,
                onTap: widget.value < widget.max ? () => _step(1) : null,
                semanticLabel: l10n.actionIncrease,
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.lg),
        ExcludeSemantics(
          child: SizedBox(
            height: 88,
            child: Stack(
              alignment: Alignment.center,
              children: [
                // A thin hairline above/below the selected value instead of
                // a boxed background — the wheel sits directly on the
                // wizard's own background.
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Divider(height: 1, color: ext.glassBorder),
                    const SizedBox(height: 40),
                    Divider(height: 1, color: ext.glassBorder),
                  ],
                ),
                ListWheelScrollView.useDelegate(
                  controller: _wheelController,
                  itemExtent: 64,
                  perspective: 0.003,
                  diameterRatio: 1.6,
                  physics: const FixedExtentScrollPhysics(),
                  onSelectedItemChanged:
                      (index) => widget.onChanged(widget.min + index),
                  childDelegate: ListWheelChildBuilderDelegate(
                    childCount: widget.max - widget.min + 1,
                    builder: (context, index) {
                      final optionValue = widget.min + index;
                      final isSelected = optionValue == widget.value;
                      return Center(
                        child: Text(
                          '$optionValue',
                          style: TextStyle(
                            fontSize: isSelected ? 22 : 16,
                            fontWeight:
                                isSelected ? FontWeight.w800 : FontWeight.w500,
                            color: isSelected ? ext.textPrimary : ext.textMuted,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _StepperButton extends StatelessWidget {
  const _StepperButton({
    required this.icon,
    required this.onTap,
    required this.semanticLabel,
  });

  final IconData icon;
  final VoidCallback? onTap;
  final String semanticLabel;

  @override
  Widget build(BuildContext context) {
    final ext = Theme.of(context).extension<AppThemeExtension>()!;
    final enabled = onTap != null;

    return Semantics(
      button: true,
      label: semanticLabel,
      child: SizedBox(
        width: 48,
        height: 48,
        child: DecoratedBox(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: ext.glassFill,
            border: Border.all(color: ext.glassBorder),
          ),
          child: IconButton(
            onPressed: onTap,
            icon: Icon(
              icon,
              color: enabled ? ext.textPrimary : ext.textMuted,
            ),
          ),
        ),
      ),
    );
  }
}
