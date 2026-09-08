import 'package:flutter/material.dart';

/// Custom design tokens not covered by [ThemeData] directly (card styling,
/// gradients, semantic status colors). Access via `Theme.of(context).extension<AppThemeExtension>()`.
@immutable
class AppThemeExtension extends ThemeExtension<AppThemeExtension> {
  const AppThemeExtension({
    required this.cardColor,
    required this.cardBorderColor,
    required this.cardShadow,
    required this.accentGradient,
    required this.success,
    required this.warning,
    required this.danger,
    required this.backgroundGradient,
    required this.glassFill,
    required this.glassBorder,
    required this.textPrimary,
    required this.textMuted,
    required this.onAccent,
    required this.accentGlow,
    required this.onAccentGlow,
  });

  final Color cardColor;
  final Color cardBorderColor;
  final List<BoxShadow> cardShadow;
  final Gradient accentGradient;
  final Color success;
  final Color warning;
  final Color danger;

  /// Full-bleed screen backdrop gradient (the "premium hero" background).
  final Gradient backgroundGradient;

  /// Translucent glass-card fill/border pair used by cards drawn directly
  /// over [backgroundGradient] (as opposed to [cardColor], which is an
  /// opaque surface for `CardTheme`).
  final Color glassFill;
  final Color glassBorder;

  /// Primary/secondary text color for content drawn over
  /// [backgroundGradient] or glass cards.
  final Color textPrimary;
  final Color textMuted;

  /// Foreground drawn on top of [accentGradient] (buttons, medallions,
  /// selected cards). The gradient uses fixed brand colors, so this stays
  /// the same in light and dark mode.
  final Color onAccent;

  /// Brand accent used for glows/badges paired with [accentGradient].
  final Color accentGlow;

  /// Foreground drawn on top of a solid [accentGlow] fill (e.g. a selected
  /// segmented-control pill). Unlike [onAccent] — fixed because
  /// [accentGradient] uses fixed brand colors — [accentGlow] itself swaps
  /// per mode (bright lime in dark, a deepened olive in light), so its
  /// foreground swaps too: dark ink reads fine on bright lime, but needs to
  /// flip to a light foreground on light mode's deeper accent.
  final Color onAccentGlow;

  @override
  AppThemeExtension copyWith({
    Color? cardColor,
    Color? cardBorderColor,
    List<BoxShadow>? cardShadow,
    Gradient? accentGradient,
    Color? success,
    Color? warning,
    Color? danger,
    Gradient? backgroundGradient,
    Color? glassFill,
    Color? glassBorder,
    Color? textPrimary,
    Color? textMuted,
    Color? onAccent,
    Color? accentGlow,
    Color? onAccentGlow,
  }) {
    return AppThemeExtension(
      cardColor: cardColor ?? this.cardColor,
      cardBorderColor: cardBorderColor ?? this.cardBorderColor,
      cardShadow: cardShadow ?? this.cardShadow,
      accentGradient: accentGradient ?? this.accentGradient,
      success: success ?? this.success,
      warning: warning ?? this.warning,
      danger: danger ?? this.danger,
      backgroundGradient: backgroundGradient ?? this.backgroundGradient,
      glassFill: glassFill ?? this.glassFill,
      glassBorder: glassBorder ?? this.glassBorder,
      textPrimary: textPrimary ?? this.textPrimary,
      textMuted: textMuted ?? this.textMuted,
      onAccent: onAccent ?? this.onAccent,
      accentGlow: accentGlow ?? this.accentGlow,
      onAccentGlow: onAccentGlow ?? this.onAccentGlow,
    );
  }

  @override
  AppThemeExtension lerp(ThemeExtension<AppThemeExtension>? other, double t) {
    if (other is! AppThemeExtension) return this;
    return AppThemeExtension(
      cardColor: Color.lerp(cardColor, other.cardColor, t)!,
      cardBorderColor: Color.lerp(cardBorderColor, other.cardBorderColor, t)!,
      cardShadow: t < 0.5 ? cardShadow : other.cardShadow,
      accentGradient: Gradient.lerp(accentGradient, other.accentGradient, t)!,
      success: Color.lerp(success, other.success, t)!,
      warning: Color.lerp(warning, other.warning, t)!,
      danger: Color.lerp(danger, other.danger, t)!,
      backgroundGradient:
          Gradient.lerp(backgroundGradient, other.backgroundGradient, t)!,
      glassFill: Color.lerp(glassFill, other.glassFill, t)!,
      glassBorder: Color.lerp(glassBorder, other.glassBorder, t)!,
      textPrimary: Color.lerp(textPrimary, other.textPrimary, t)!,
      textMuted: Color.lerp(textMuted, other.textMuted, t)!,
      onAccent: Color.lerp(onAccent, other.onAccent, t)!,
      accentGlow: Color.lerp(accentGlow, other.accentGlow, t)!,
      onAccentGlow: Color.lerp(onAccentGlow, other.onAccentGlow, t)!,
    );
  }
}
