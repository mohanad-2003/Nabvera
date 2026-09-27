import 'package:nabvera/core/theme/app_theme_extension.dart';
import 'package:flutter/material.dart';

/// Standard text input styled from the app's [InputDecorationTheme].
class AppTextField extends StatelessWidget {
  const AppTextField({
    super.key,
    this.controller,
    this.label,
    this.hint,
    this.obscureText = false,
    this.keyboardType,
    this.validator,
    this.onChanged,
    this.prefixIcon,
    this.suffixIcon,
    this.flat = false,
    this.maxLines = 1,
    this.textDirection,
    this.enabled = true,
  });

  final TextEditingController? controller;
  final String? label;
  final String? hint;
  final bool obscureText;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;
  final ValueChanged<String>? onChanged;
  final IconData? prefixIcon;
  final Widget? suffixIcon;
  final bool flat;

  /// False for a field that's shown but not editable here (e.g. the
  /// account email, which is tied to sign-in and isn't part of the
  /// profile-update request) — greyed out rather than silently discarding
  /// whatever the user types into it.
  final bool enabled;

  /// Forces the typed text's direction regardless of the app's current
  /// locale — e.g. an Arabic-content field on an otherwise LTR (English)
  /// admin screen, so typed Arabic still flows right-to-left.
  final TextDirection? textDirection;

  /// Defaults to a single line, matching every prior call site. Pass a
  /// larger value (or `null` for unbounded) for multi-line fields like an
  /// Admin description/content editor.
  final int? maxLines;

  @override
  Widget build(BuildContext context) {
    final ext = Theme.of(context).extension<AppThemeExtension>()!;
    final border = OutlineInputBorder(
      borderRadius: BorderRadius.circular(16),
      borderSide: BorderSide(color: ext.glassBorder),
    );
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      validator: validator,
      onChanged: onChanged,
      maxLines: maxLines,
      textDirection: textDirection,
      enabled: enabled,
      style: Theme.of(
        context,
      ).textTheme.bodyLarge?.copyWith(color: enabled ? null : ext.textMuted),
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: prefixIcon != null ? Icon(prefixIcon) : null,
        suffixIcon: suffixIcon,
        filled: flat ? false : null,
        fillColor: flat ? Colors.transparent : null,
        border: flat ? border : null,
        enabledBorder: flat ? border : null,
        focusedBorder:
            flat
                ? border.copyWith(
                  borderSide: BorderSide(
                    color: Theme.of(context).colorScheme.primary,
                    width: 1.2,
                  ),
                )
                : null,
      ),
    );
  }
}
