import 'package:flutter/material.dart';

/// "Electric Blue" palette — a cool, deep navy-graphite base with electric
/// blue as the one primary accent, teal reserved for streaks/success states
/// only. Replaced the earlier "Graphite Amber" identity; kept the same field
/// names as that palette (`seedLime`, `electricOrange`, `aquaBlue`, ...) since
/// every call site already reads them by role (primary accent / gradient
/// partner / cool decorative accent) rather than by literal hue — only the
/// values below define the actual look.
abstract final class AppColors {
  static const Color seedInk = Color(0xFF0E1117);

  /// Primary accent — electric blue. Was amber.
  static const Color seedLime = Color(0xFF3D7BFF);

  /// Filled controls use a deeper blue to keep white labels readable.
  static const Color actionBlue = Color(0xFF2D67DB);
  static const Color seedViolet = Color(0xFF6C5CE7);

  /// Gradient partner for [seedLime] (buttons, hero badges) and the dark
  /// theme's ColorScheme.secondary — a deeper royal blue.
  static const Color electricOrange = Color(0xFF2B5FE0);

  /// Cool decorative accent (round-item variety colors, streak highlight)
  /// — teal.
  static const Color aquaBlue = Color(0xFF29D9C0);
  static const Color midnight = Color(0xFF0B0E14);
  static const Color graphite = Color(0xFF161B24);
  static const Color glass = Color(0x1FFFFFFF);

  // A cool neutral base — matches the navy-graphite dark base's own tint.
  static const Color lightSurface = Color(0xFFF4F6FB);
  static const Color lightSurfaceVariant = Color(0xFFE9EDF6);
  static const Color lightOutline = Color(0xFFD3DAE8);

  // Dark surfaces deliberately avoid pure black per design-system requirements.
  static const Color darkSurface = Color(0xFF0E1117);
  static const Color darkSurfaceVariant = Color(0xFF161B24);
  static const Color darkOutline = Color(0xFF262D3A);
  static const Color textMutedDark = Color(0xFFB4BDCD);
  static const Color textMutedLight = Color(0xFF5E697B);

  // Dark-mode semantic accents: bright/saturated so they read clearly
  // against the near-black surfaces.
  static const Color success = Color(0xFF29D9C0);
  static const Color warning = Color(0xFFFFB84D);
  static const Color danger = Color(0xFFFF4D67);

  /// Community notification accent (pink) — decorative icon-gradient use
  /// only, always paired with a white glyph, so no light/dark variant is
  /// needed the way text-foreground semantic colors require.
  static const Color communityPink = Color(0xFFFF5FA8);

  // Light-mode semantic accents: deepened versions of the same hues so
  // text/icons drawn in these colors — and white text drawn on top of a
  // filled button in these colors — meet accessible contrast against the
  // light, near-white surfaces (the dark-mode values above are too bright
  // for that role in Light Mode).
  static const Color successOnLight = Color(0xFF0E8C7B);
  static const Color warningOnLight = Color(0xFF9A6400);
  static const Color dangerOnLight = Color(0xFFB3261E);

  /// Darker royal-blue counterpart to [seedLime] for icons, labels, and
  /// progress indicators on the light background — the vivid dark-mode
  /// blue is too light/low-contrast for text on a near-white surface.
  static const Color accentOnLight = Color(0xFF1F55D6);
}
