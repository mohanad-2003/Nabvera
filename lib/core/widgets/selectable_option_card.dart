import 'package:fitness_app/core/theme/app_theme_extension.dart';
import 'package:flutter/material.dart';


/// A full-width selectable pill/card used across onboarding wizard steps
/// (goal, activity level, and similar single-choice pickers) — replaces the
/// near-duplicate `_GoalItem`/`_ActivityButton` implementations that only
/// differed by whether a trailing checkmark badge was shown and text
/// alignment.
class SelectableOptionCard extends StatelessWidget {
  const SelectableOptionCard({
    super.key,
    required this.label,
    required this.isSelected,
    required this.onTap,
    this.showCheckmark = false,
    this.centered = false,
  });

  final String label;
  final bool isSelected;
  final VoidCallback onTap;
  final bool showCheckmark;
  final bool centered;

  @override
  Widget build(BuildContext context) {
    final ext = Theme.of(context).extension<AppThemeExtension>()!;

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        width: double.infinity,
        padding: EdgeInsets.symmetric(
          vertical: centered ? 15 : 12,
          horizontal: 20,
        ),
        decoration: BoxDecoration(
          gradient: isSelected ? ext.accentGradient : null,
          color: isSelected ? null : ext.glassFill,
          borderRadius: BorderRadius.circular(30),
          border: Border.all(
            color: isSelected ? Colors.transparent : ext.glassBorder,
          ),
          boxShadow: [
            if (isSelected)
              BoxShadow(
                color: ext.accentGlow.withValues(alpha: 0.28),
                blurRadius: 18,
                offset: const Offset(0, 8),
              ),
          ],
        ),
        child:
            centered
                ? Center(child: _label(context, ext))
                : Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _label(context, ext),
                    if (showCheckmark)
                      Container(
                        width: 30,
                        height: 30,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: isSelected ? ext.onAccent : ext.textMuted,
                            width: 2,
                          ),
                          color:
                              isSelected ? ext.onAccent : Colors.transparent,
                        ),
                        child:
                            isSelected
                                ? Icon(
                                  Icons.check_rounded,
                                  color: ext.accentGlow,
                                  size: 18,
                                )
                                : null,
                      ),
                  ],
                ),
      ),
    );
  }

  Widget _label(BuildContext context, AppThemeExtension ext) => Text(
    label,
    style: TextStyle(
      color: isSelected ? ext.onAccent : ext.textPrimary,
      fontSize: centered ? 20 : 18,
      fontWeight: FontWeight.w800,
    ),
  );
}
