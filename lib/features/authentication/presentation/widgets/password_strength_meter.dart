import 'package:flutter/material.dart';
import 'package:nabvera/core/localization/generated/app_localizations.dart';
import 'package:nabvera/core/theme/app_theme_extension.dart';

enum _Strength { empty, weak, medium, strong }

/// Live password strength bar + rule hint, driven straight off the same
/// [TextEditingController] the field already uses — purely a visual aid,
/// the actual `Validators.password` rule (8+ characters) is unchanged.
class PasswordStrengthMeter extends StatelessWidget {
  const PasswordStrengthMeter({super.key, required this.controller});

  final TextEditingController controller;

  _Strength _strengthOf(String value) {
    if (value.isEmpty) return _Strength.empty;
    var score = 0;
    if (value.length >= 8) score++;
    if (value.length >= 12) score++;
    if (RegExp(r'[A-Z]').hasMatch(value) && RegExp(r'[a-z]').hasMatch(value)) {
      score++;
    }
    if (RegExp(r'[0-9]').hasMatch(value)) score++;
    if (RegExp(r'[^A-Za-z0-9]').hasMatch(value)) score++;
    if (score <= 1) return _Strength.weak;
    if (score <= 3) return _Strength.medium;
    return _Strength.strong;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final ext = theme.extension<AppThemeExtension>()!;
    final l10n = AppLocalizations.of(context);

    return ValueListenableBuilder<TextEditingValue>(
      valueListenable: controller,
      builder: (context, value, _) {
        final strength = _strengthOf(value.text);
        final ruleMet = value.text.length >= 8;

        final (label, color, factor) = switch (strength) {
          _Strength.empty => ('', ext.textMuted, 0.0),
          _Strength.weak => (l10n.passwordStrengthWeak, ext.danger, 1 / 3),
          _Strength.medium => (l10n.passwordStrengthMedium, ext.warning, 2 / 3),
          _Strength.strong => (l10n.passwordStrengthStrong, ext.success, 1.0),
        };

        return Padding(
          padding: const EdgeInsets.only(top: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              LayoutBuilder(
                builder: (context, constraints) {
                  return Stack(
                    children: [
                      Container(
                        height: 5,
                        decoration: BoxDecoration(
                          color: ext.glassBorder,
                          borderRadius: BorderRadius.circular(999),
                        ),
                      ),
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 260),
                        curve: Curves.easeOut,
                        height: 5,
                        width: constraints.maxWidth * factor,
                        decoration: BoxDecoration(
                          color: color,
                          borderRadius: BorderRadius.circular(999),
                        ),
                      ),
                    ],
                  );
                },
              ),
              if (strength != _Strength.empty) ...[
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(
                      ruleMet
                          ? Icons.check_circle_rounded
                          : Icons.circle_outlined,
                      size: 14,
                      color: ruleMet ? ext.success : ext.textMuted,
                    ),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        l10n.validationPasswordTooShort,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: ruleMet ? ext.success : ext.textMuted,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      label,
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: color,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        );
      },
    );
  }
}
