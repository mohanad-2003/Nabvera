import 'package:flutter/material.dart';

/// "Graphite Amber" palette — a neutral graphite base (no blue/green tint)
/// with amber as the one primary accent, teal reserved for streaks/success
/// states only. Replaced the earlier near-black/neon-lime identity; kept
/// the same field names as that palette (`seedLime`, `electricOrange`,
/// `aquaBlue`, ...) since every call site already reads them by role
/// (primary accent / gradient partner / cool decorative accent) rather
/// than by literal hue — only the values below define the actual look.
abstract final class AppColors {
  static const Color seedInk = Color(0xFF111213);

  /// Primary accent — amber. Was neon lime.
  static const Color seedLime = Color(0xFFFFB020);
  static const Color seedViolet = Color(0xFF6C5CE7);

  /// Gradient partner for [seedLime] (buttons, hero badges) and the dark
  /// theme's ColorScheme.secondary — a deeper burnt-amber, not orange.
  static const Color electricOrange = Color(0xFFE8951A);

  /// Cool decorative accent (round-item variety colors, streak highlight)
  /// — teal. Was a brighter cyan/"aqua".
  static const Color aquaBlue = Color(0xFF29D9C0);
  static const Color midnight = Color(0xFF17181A);
  static const Color graphite = Color(0xFF1A1B1B);
  static const Color glass = Color(0x1FFFFFFF);

  // A warm neutral base — matches the graphite dark base's own neutrality
  // instead of the old cool blue-tinted light surface.
  static const Color lightSurface = Color(0xFFF7F6F3);
  static const Color lightSurfaceVariant = Color(0xFFEFEDE7);
  static const Color lightOutline = Color(0xFFD9D6CE);

  // Dark surfaces deliberately avoid pure black per design-system requirements.
  static const Color darkSurface = Color(0xFF111213);
  static const Color darkSurfaceVariant = Color(0xFF1A1B1B);
  static const Color darkOutline = Color(0xFF2B2C2C);

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

  /// Darker bronze counterpart to [seedLime] (amber) for icons, labels, and
  /// progress indicators on the light background — the vivid dark-mode
  /// amber is too light/low-contrast for text on a near-white surface.
  static const Color accentOnLight = Color(0xFF8A5A00);
}
