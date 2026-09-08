import 'package:flutter/material.dart';

import 'app_colors.dart';
import 'app_spacing.dart';
import 'app_theme_extension.dart';
import 'app_typography.dart';

/// Builds the app's light/dark [ThemeData] from the shared brand seed colors.
abstract final class AppTheme {
  static ThemeData light() => _build(Brightness.light);
  static ThemeData dark() => _build(Brightness.dark);

  static ThemeData _build(Brightness brightness) {
    final isDark = brightness == Brightness.dark;

    final colorScheme = ColorScheme.fromSeed(
      seedColor: AppColors.seedInk,
      brightness: brightness,
      primary: isDark ? AppColors.seedLime : AppColors.seedInk,
      secondary: isDark ? AppColors.electricOrange : AppColors.seedViolet,
      surface: isDark ? AppColors.darkSurface : AppColors.lightSurface,
      surfaceContainerHighest:
          isDark ? AppColors.darkSurfaceVariant : AppColors.lightSurfaceVariant,
      outline: isDark ? AppColors.darkOutline : AppColors.lightOutline,
      error: isDark ? AppColors.danger : AppColors.dangerOnLight,
    );

    final textTheme = AppTypography.textTheme(colorScheme.onSurface);

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: colorScheme.surface,
      textTheme: textTheme,
      splashFactory: InkSparkle.splashFactory,
      appBarTheme: AppBarTheme(
        backgroundColor: colorScheme.surface,
        foregroundColor: colorScheme.onSurface,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: textTheme.titleLarge,
      ),
      // Material3's own SnackBarThemeData default assumes a dark
      // (inverse-surface) background regardless of app brightness, so its
      // default light-colored content text disappears against the light,
      // near-white background every SnackBar in this app actually uses in
      // light mode (backgroundColor: ext.cardColor) — this is the fix for
      // that, applied once here rather than patched at every call site.
      snackBarTheme: SnackBarThemeData(
        backgroundColor: isDark ? AppColors.graphite : Colors.white,
        contentTextStyle: TextStyle(
          color: isDark ? Colors.white : AppColors.seedInk,
          fontWeight: FontWeight.w600,
        ),
        actionTextColor: isDark ? AppColors.seedLime : AppColors.successOnLight,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.lg),
        ),
        elevation: isDark ? 0 : 6,
      ),
      cardTheme: CardThemeData(
        color:
            isDark ? AppColors.graphite : colorScheme.surfaceContainerHighest,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.lg),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: colorScheme.primary,
          foregroundColor: colorScheme.onPrimary,
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.xl,
            vertical: AppSpacing.md,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.pill),
          ),
          textStyle: textTheme.labelLarge?.copyWith(letterSpacing: 0.4),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: colorScheme.onSurface,
          side: BorderSide(color: colorScheme.outline),
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.xl,
            vertical: AppSpacing.md,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.pill),
          ),
          textStyle: textTheme.labelLarge,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor:
            isDark
                ? Colors.white.withValues(alpha: 0.08)
                : colorScheme.surfaceContainerHighest,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.md,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.lg),
          borderSide: BorderSide(
            color:
                isDark
                    ? Colors.white.withValues(alpha: 0.08)
                    : colorScheme.outline.withValues(alpha: 0.35),
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.lg),
          borderSide: BorderSide(
            color:
                isDark
                    ? Colors.white.withValues(alpha: 0.10)
                    : colorScheme.outline.withValues(alpha: 0.35),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.lg),
          borderSide: BorderSide(color: colorScheme.primary, width: 1.6),
        ),
        labelStyle: TextStyle(
          color: isDark ? Colors.white.withValues(alpha: 0.72) : null,
        ),
        hintStyle: TextStyle(
          color:
              isDark
                  ? Colors.white.withValues(alpha: 0.38)
                  : colorScheme.onSurfaceVariant,
        ),
        prefixIconColor:
            isDark
                ? Colors.white.withValues(alpha: 0.64)
                : colorScheme.onSurfaceVariant,
        suffixIconColor:
            isDark
                ? Colors.white.withValues(alpha: 0.64)
                : colorScheme.onSurfaceVariant,
      ),
      extensions: [
        AppThemeExtension(
          // Light mode uses a clean, near-opaque white for cards (elevated
          // above the warm gradient background) rather than a low-alpha
          // black overlay — the latter barely reads against a light
          // background and was the "weak contrast" light-mode problem.
          cardColor: isDark ? AppColors.graphite : Colors.white,
          cardBorderColor:
              isDark
                  ? Colors.white.withValues(alpha: 0.10)
                  : Colors.black.withValues(alpha: 0.06),
          cardShadow:
              isDark
                  ? const []
                  : [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.08),
                      blurRadius: 28,
                      offset: const Offset(0, 10),
                    ),
                  ],
          accentGradient: LinearGradient(
            colors: [AppColors.seedLime, AppColors.electricOrange],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          success: isDark ? AppColors.success : AppColors.successOnLight,
          warning: isDark ? AppColors.warning : AppColors.warningOnLight,
          danger: isDark ? AppColors.danger : AppColors.dangerOnLight,
          backgroundGradient:
              isDark
                  ? const LinearGradient(
                    colors: [
                      AppColors.midnight,
                      AppColors.seedInk,
                      AppColors.graphite,
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  )
                  : LinearGradient(
                    colors: [
                      AppColors.lightSurface,
                      AppColors.lightSurfaceVariant,
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
          // Frosted-white "glass" tier, distinct from the fully-opaque
          // cardColor above but still clearly defined against the warm
          // background gradient — replaces the old translucent-black fill
          // that nearly disappeared in light mode.
          glassFill:
              isDark
                  ? Colors.white.withValues(alpha: 0.08)
                  : Colors.white.withValues(alpha: 0.86),
          glassBorder:
              isDark
                  ? Colors.white.withValues(alpha: 0.10)
                  : Colors.black.withValues(alpha: 0.06),
          textPrimary: isDark ? Colors.white : AppColors.seedInk,
          textMuted:
              isDark
                  ? Colors.white.withValues(alpha: 0.62)
                  : AppColors.seedInk.withValues(alpha: 0.6),
          onAccent: AppColors.seedInk,
          accentGlow: isDark ? AppColors.seedLime : AppColors.accentOnLight,
          // Dark ink reads fine on bright lime (dark mode); light mode's
          // deeper olive accentGlow needs a light foreground instead.
          onAccentGlow: isDark ? AppColors.seedInk : Colors.white,
        ),
      ],
    );
  }
}
