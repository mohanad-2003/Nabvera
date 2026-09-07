import 'package:flutter/material.dart';

import '../theme/app_theme_extension.dart';
import 'pressable_scale.dart';

/// Full-width filled call-to-action button with a built-in loading state.
/// Replaces the legacy `CustomButton` (lib/view/custm_button.dart), which
/// had a fixed 211x44 size and no loading/disabled handling.
class PrimaryButton extends StatelessWidget {
  const PrimaryButton({
    super.key,
    required this.label,
    this.onPressed,
    this.isLoading = false,
    this.showShadow = true,
    this.icon,
  });

  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;
  final IconData? icon;
  final bool showShadow;

  @override
  Widget build(BuildContext context) {
    final ext = Theme.of(context).extension<AppThemeExtension>()!;
    final disabled = onPressed == null || isLoading;
    final radius = BorderRadius.circular(999);
    return PressableScale(
      enabled: !disabled,
      child: SizedBox(
        width: double.infinity,
        height: 56,
        child: DecoratedBox(
          decoration: BoxDecoration(
            borderRadius: radius,
            gradient: disabled ? null : ext.accentGradient,
            boxShadow:
                disabled
                    || !showShadow ? const []
                    : [
                      BoxShadow(
                        color: ext.accentGlow.withValues(alpha: 0.28),
                        blurRadius: 24,
                        offset: const Offset(0, 12),
                      ),
                    ],
          ),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor:
                  disabled
                      ? Theme.of(context).disabledColor.withValues(alpha: 0.20)
                      : Colors.transparent,
              shadowColor: Colors.transparent,
              foregroundColor: ext.onAccent,
              shape: RoundedRectangleBorder(borderRadius: radius),
            ),
            onPressed: disabled ? null : onPressed,
            child:
                isLoading
                    ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2.4),
                    )
                    : Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (icon != null) ...[
                          Icon(icon, size: 20),
                          const SizedBox(width: 8),
                        ],
                        Text(label),
                      ],
                    ),
          ),
        ),
      ),
    );
  }
}
