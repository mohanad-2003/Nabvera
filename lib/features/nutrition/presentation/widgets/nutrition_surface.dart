import 'package:flutter/material.dart';
import 'package:nabvera/core/theme/app_spacing.dart';
import 'package:nabvera/core/theme/app_theme_extension.dart';

/// Minimum touch target on the Nutrition page (48dp).
const double kNutritionTapTarget = 48;

/// The one surface used by the Nutrition page's sections: theme card colour
/// with a hairline border and the theme's own (light-mode only) shadow, so it
/// reads correctly in both themes without stacking boxes.
class NutritionSurface extends StatelessWidget {
  const NutritionSurface({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(AppSpacing.lg),
    this.onTap,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final ext = Theme.of(context).extension<AppThemeExtension>()!;
    final radius = BorderRadius.circular(AppRadius.card);
    return DecoratedBox(
      decoration: BoxDecoration(
        color: ext.cardColor,
        borderRadius: radius,
        border: Border.all(color: ext.cardBorderColor),
        boxShadow: ext.cardShadow,
      ),
      child: Material(
        type: MaterialType.transparency,
        child: InkWell(
          onTap: onTap,
          borderRadius: radius,
          child: Padding(padding: padding, child: child),
        ),
      ),
    );
  }
}

/// Filled blue action button, at least [kNutritionTapTarget] tall.
class NutritionActionButton extends StatelessWidget {
  const NutritionActionButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.expand = false,
  });

  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final bool expand;

  @override
  Widget build(BuildContext context) {
    final ext = Theme.of(context).extension<AppThemeExtension>()!;
    final radius = BorderRadius.circular(AppRadius.pill);
    return ConstrainedBox(
      constraints: const BoxConstraints(minHeight: kNutritionTapTarget),
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: onPressed == null ? null : ext.accentGradient,
          color: onPressed == null ? ext.glassBorder : null,
          borderRadius: radius,
        ),
        child: Material(
          type: MaterialType.transparency,
          child: InkWell(
            onTap: onPressed,
            borderRadius: radius,
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.lg,
                vertical: AppSpacing.sm,
              ),
              child: Row(
                mainAxisSize: expand ? MainAxisSize.max : MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (icon != null) ...[
                    Icon(icon, size: 20, color: ext.onAccent),
                    const SizedBox(width: AppSpacing.sm),
                  ],
                  Flexible(
                    child: Text(
                      label,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.labelLarge?.copyWith(
                        color: ext.onAccent,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Rounded progress bar. [value] is expected in 0..1 (it is clamped here as a
/// last guard); the bar never claims progress for a null [value].
class NutritionProgressBar extends StatelessWidget {
  const NutritionProgressBar({
    super.key,
    required this.value,
    required this.color,
    this.height = 6,
  });

  final double? value;
  final Color color;
  final double height;

  @override
  Widget build(BuildContext context) {
    final ext = Theme.of(context).extension<AppThemeExtension>()!;
    return ClipRRect(
      borderRadius: BorderRadius.circular(AppRadius.pill),
      child: LinearProgressIndicator(
        value: (value ?? 0).clamp(0.0, 1.0),
        minHeight: height,
        backgroundColor: ext.glassBorder,
        valueColor: AlwaysStoppedAnimation<Color>(color),
      ),
    );
  }
}
