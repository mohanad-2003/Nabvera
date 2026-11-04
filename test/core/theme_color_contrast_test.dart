import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nabvera/core/theme/app_theme.dart';
import 'package:nabvera/core/theme/app_theme_extension.dart';

double contrast(Color first, Color second) {
  final a = first.computeLuminance();
  final b = second.computeLuminance();
  return (a > b ? a + 0.05 : b + 0.05) / (a > b ? b + 0.05 : a + 0.05);
}

void main() {
  for (final theme in [AppTheme.light(), AppTheme.dark()]) {
    test(
      '${theme.brightness} secondary text and action labels remain readable',
      () {
        final ext = theme.extension<AppThemeExtension>()!;
        final backgrounds = [
          theme.colorScheme.surface,
          ext.cardColor,
          Color.alphaBlend(ext.glassFill, theme.colorScheme.surface),
          Color.alphaBlend(ext.glassFill, ext.cardColor),
          theme.colorScheme.surfaceContainerHighest,
        ];
        for (final background in backgrounds) {
          expect(
            contrast(ext.textMuted, background),
            greaterThanOrEqualTo(4.5),
          );
        }
        final gradient = ext.accentGradient as LinearGradient;
        for (final stop in gradient.colors) {
          expect(contrast(ext.onAccent, stop), greaterThanOrEqualTo(4.5));
        }
      },
    );
  }
}
