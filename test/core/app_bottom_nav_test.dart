import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nabvera/core/localization/generated/app_localizations.dart';
import 'package:nabvera/core/theme/app_theme.dart';
import 'package:nabvera/core/widgets/app_bottom_nav.dart';

void main() {
  for (final locale in ['ar', 'en']) {
    for (final dark in [false, true]) {
      testWidgets('$locale, dark=$dark: all tabs keep their routing indices', (
        tester,
      ) async {
        tester.view.physicalSize = const Size(360, 780);
        tester.view.devicePixelRatio = 1;
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);
        final taps = <int>[];
        late AppLocalizations l10n;
        await tester.pumpWidget(
          MaterialApp(
            locale: Locale(locale),
            theme: dark ? AppTheme.dark() : AppTheme.light(),
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            home: Builder(
              builder: (context) {
                l10n = AppLocalizations.of(context);
                return Scaffold(
                  bottomNavigationBar: AppBottomNav(
                    currentIndex: 2,
                    onTap: taps.add,
                  ),
                );
              },
            ),
          ),
        );
        final labels = [
          l10n.navHome,
          l10n.navWorkout,
          l10n.navNutrition,
          l10n.navCommunity,
          l10n.navProfile,
        ];
        for (final label in labels) {
          await tester.tap(find.text(label));
          await tester.pumpAndSettle();
        }
        expect(taps, [0, 1, 2, 3, 4]);
        expect(tester.takeException(), isNull);
      });
    }
  }
}
