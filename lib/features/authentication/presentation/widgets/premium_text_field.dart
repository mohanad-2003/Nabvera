import 'package:flutter/material.dart';
import 'package:nabvera/core/theme/app_theme_extension.dart';

/// Auth-flow text field: rounded 20px filled background, an animated
/// glow/border on focus, and a colored prefix icon that lights up while
/// active. Scoped to the authentication screens so the shared app-wide
/// [AppTextField] (used across the rest of the app) is untouched.
class PremiumTextField extends StatefulWidget {
  const PremiumTextField({
    super.key,
    this.controller,
    this.label,
    this.hint,
    this.obscureText = false,
    this.keyboardType,
    this.textInputAction,
    this.validator,
    this.onChanged,
    this.prefixIcon,
    this.suffixIcon,
    this.errorText,
    this.transparent = false,
  });

  final TextEditingController? controller;
  final String? label;
  final String? hint;
  final bool obscureText;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final String? Function(String?)? validator;
  final ValueChanged<String>? onChanged;
  final IconData? prefixIcon;
  final Widget? suffixIcon;

  /// A server/auth error to show under the field right now (e.g. "No
  /// account found with that email"), independent of form validation —
  /// cleared by the caller once the user edits the field again.
  final String? errorText;

  /// No fill color, no shadow — just a light border that thickens and
  /// tints on focus. Used where the login/signup forms sit directly on the
  /// page background instead of inside a card.
  final bool transparent;

  @override
  State<PremiumTextField> createState() => _PremiumTextFieldState();
}

class _PremiumTextFieldState extends State<PremiumTextField> {
  final _focusNode = FocusNode();
  bool _focused = false;

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(_handleFocusChange);
  }

  void _handleFocusChange() {
    setState(() => _focused = _focusNode.hasFocus);
  }

  @override
  void dispose() {
    _focusNode.removeListener(_handleFocusChange);
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final ext = theme.extension<AppThemeExtension>()!;
    final radius = BorderRadius.circular(widget.transparent ? 16 : 20);
    final isDark = theme.brightness == Brightness.dark;
    final baseBorderColor =
        widget.transparent
            ? ext.textMuted.withValues(alpha: 0.32)
            : ext.glassBorder;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 220),
      curve: Curves.easeOut,
      decoration: BoxDecoration(
        borderRadius: radius,
        boxShadow:
            _focused && !widget.transparent
                ? [
                  BoxShadow(
                    color: theme.colorScheme.primary.withValues(alpha: 0.20),
                    blurRadius: 22,
                    offset: const Offset(0, 10),
                  ),
                ]
                : const [],
      ),
      child: TextFormField(
        controller: widget.controller,
        focusNode: _focusNode,
        obscureText: widget.obscureText,
        keyboardType: widget.keyboardType,
        textInputAction: widget.textInputAction,
        validator: widget.validator,
        onChanged: widget.onChanged,
        style: theme.textTheme.bodyLarge,
        decoration: InputDecoration(
          labelText: widget.label,
          hintText: widget.hint,
          errorText: widget.errorText,
          filled: !widget.transparent,
          fillColor:
              widget.transparent
                  ? null
                  : (isDark
                      ? Colors.white.withValues(alpha: 0.06)
                      : Colors.white),
          prefixIcon:
              widget.prefixIcon != null
                  ? Icon(
                    widget.prefixIcon,
                    color: _focused ? theme.colorScheme.primary : ext.textMuted,
                  )
                  : null,
          suffixIcon: widget.suffixIcon,
          contentPadding: EdgeInsets.symmetric(
            horizontal: widget.transparent ? 16 : 18,
            vertical: 18,
          ),
          border: OutlineInputBorder(
            borderRadius: radius,
            borderSide: BorderSide(
              color: widget.transparent ? baseBorderColor : ext.glassBorder,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: radius,
            borderSide: BorderSide(
              color: widget.transparent ? baseBorderColor : ext.glassBorder,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: radius,
            borderSide: BorderSide(
              color: theme.colorScheme.primary,
              width: widget.transparent ? 1.6 : 1.8,
            ),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: radius,
            borderSide: BorderSide(color: theme.colorScheme.error, width: 1.4),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: radius,
            borderSide: BorderSide(color: theme.colorScheme.error, width: 1.8),
          ),
        ),
      ),
    );
  }
}

/// [PremiumTextField] with a built-in obscure/reveal toggle — the auth-flow
/// equivalent of the shared [AuthPasswordField], restyled to match.
class PremiumPasswordField extends StatefulWidget {
  const PremiumPasswordField({
    super.key,
    required this.controller,
    required this.label,
    required this.hint,
    required this.validator,
    this.onChanged,
    this.textInputAction,
    this.errorText,
    this.transparent = false,
  });

  final TextEditingController controller;
  final String label;
  final String hint;
  final String? Function(String?) validator;
  final ValueChanged<String>? onChanged;
  final TextInputAction? textInputAction;
  final String? errorText;
  final bool transparent;

  @override
  State<PremiumPasswordField> createState() => _PremiumPasswordFieldState();
}

class _PremiumPasswordFieldState extends State<PremiumPasswordField> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return PremiumTextField(
      controller: widget.controller,
      label: widget.label,
      hint: widget.hint,
      prefixIcon: Icons.lock_outline_rounded,
      obscureText: _obscureText,
      validator: widget.validator,
      onChanged: widget.onChanged,
      textInputAction: widget.textInputAction,
      errorText: widget.errorText,
      transparent: widget.transparent,
      suffixIcon: IconButton(
        onPressed: () => setState(() => _obscureText = !_obscureText),
        icon: Icon(
          _obscureText
              ? Icons.visibility_off_outlined
              : Icons.visibility_outlined,
        ),
      ),
    );
  }
}
