/// Centralized 4pt spacing scale. Never hardcode raw padding/margin numbers.
abstract final class AppSpacing {
  static const double xs = 4;
  static const double sm = 8;
  static const double md = 12;
  static const double lg = 16;

  /// The 20pt step between [lg] and [xl] — named for its value rather than
  /// slotted into the xs/sm/md/lg/xl mnemonic sequence, since renaming the
  /// existing tokens to make room would touch every call site that already
  /// uses them. Used by Admin surfaces, which follow the design system's
  /// full 4/8/12/16/20/24/32 spacing scale.
  static const double s20 = 20;
  static const double xl = 24;
  static const double xxl = 32;
  static const double xxxl = 48;
}

/// Centralized corner-radius scale.
abstract final class AppRadius {
  static const double sm = 8;
  static const double md = 12;
  static const double lg = 16;

  /// Standard radius for every large content card (featured cards, glass
  /// cards, list items) — one value across all tabs per the design system.
  static const double card = 20;
  static const double xl = 24;

  /// Larger surfaces (Admin content cards, big bottom sheets) — the 28/32
  /// step of the design system's radius scale, one notch past [xl].
  static const double xxl = 28;
  static const double xxxl = 32;
  static const double pill = 999;
}
