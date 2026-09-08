import 'package:flutter/material.dart';

/// Premium fitness palette used across the product surfaces.
abstract final class AppColors {
  static const Color seedInk = Color(0xFF080D12);
  static const Color seedLime = Color(0xFFBFFF3C);
  static const Color seedViolet = Color(0xFF6C5CE7);
  static const Color electricOrange = Color(0xFFFF7A1A);
  static const Color aquaBlue = Color(0xFF33D6FF);
  static const Color midnight = Color(0xFF0D141C);
  static const Color graphite = Color(0xFF141C24);
  static const Color glass = Color(0x1FFFFFFF);

  // A cool neutral base keeps the light theme clean and lets lime accents
  // remain readable without tinting every screen green.
  static const Color lightSurface = Color(0xFFF6F8FC);
  static const Color lightSurfaceVariant = Color(0xFFEAF0F6);
  static const Color lightOutline = Color(0xFFD3D9C7);

  // Dark surfaces deliberately avoid pure black per design-system requirements.
  static const Color darkSurface = Color(0xFF080D12);
  static const Color darkSurfaceVariant = Color(0xFF121A22);
  static const Color darkOutline = Color(0xFF2A3744);

  // Dark-mode semantic accents: bright/saturated so they read clearly
  // against the near-black surfaces.
  static const Color success = Color(0xFF4DFF8D);
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
  static const Color successOnLight = Color(0xFF1E8E5A);
  static const Color warningOnLight = Color(0xFF9A6400);
  static const Color dangerOnLight = Color(0xFFB3261E);

  /// Darker olive-green counterpart to [seedLime] for icons, labels, and
  /// progress indicators on the light background. The neon original stays
  /// reserved for dark surfaces where it has the intended contrast.
  static const Color accentOnLight = Color(0xFF527B13);
}
