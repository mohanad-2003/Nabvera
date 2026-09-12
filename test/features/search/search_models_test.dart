import 'package:nabvera/core/localization/generated/app_localizations.dart';
import 'package:nabvera/features/search/domain/search_models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

/// Pumps an otherwise-empty app under [languageCode] and hands back a
/// [BuildContext] with a real `Localizations` ancestor, so
/// `Localizations.localeOf(context)` inside `localizedName(context)`
/// resolves exactly as it would in the real app.
Future<BuildContext> _contextFor(WidgetTester tester, String languageCode) async {
  late BuildContext ctx;
  await tester.pumpWidget(
    MaterialApp(
      locale: Locale(languageCode),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: Builder(
        builder: (context) {
          ctx = context;
          return const SizedBox.shrink();
        },
      ),
    ),
  );
  return ctx;
}

void main() {
  group('SearchResultItem.localizedName', () {
    testWidgets('shows nameAr under Arabic when set (a translated workout result)', (tester) async {
      const item = SearchResultItem(
        id: 'w1',
        image: 'assets/workout.png',
        name: 'Upper Body Power',
        nameAr: 'قوة الجزء العلوي',
        durationMinutes: 35,
        calories: 320,
        type: SearchResultType.workout,
      );
      final context = await _contextFor(tester, 'ar');
      expect(item.localizedName(context), 'قوة الجزء العلوي');
    });

    testWidgets('shows nameAr under Arabic when set (a translated recipe result)', (tester) async {
      const item = SearchResultItem(
        id: 'r1',
        image: 'assets/workout.png',
        name: 'Carrot Orange Smoothie',
        nameAr: 'سموذي الجزر والبرتقال',
        durationMinutes: 10,
        calories: 70,
        type: SearchResultType.nutrition,
      );
      final context = await _contextFor(tester, 'ar');
      expect(item.localizedName(context), 'سموذي الجزر والبرتقال');
    });

    testWidgets('falls back to English under Arabic when untranslated', (tester) async {
      const item = SearchResultItem(
        id: 'w2',
        image: 'assets/workout.png',
        name: 'Full Body HIIT',
        durationMinutes: 25,
        calories: 280,
        type: SearchResultType.workout,
      );
      final context = await _contextFor(tester, 'ar');
      expect(item.localizedName(context), 'Full Body HIIT');
    });

    testWidgets('shows English under an English locale regardless of nameAr', (tester) async {
      const item = SearchResultItem(
        id: 'w1',
        image: 'assets/workout.png',
        name: 'Upper Body Power',
        nameAr: 'قوة الجزء العلوي',
        durationMinutes: 35,
        calories: 320,
        type: SearchResultType.workout,
      );
      final context = await _contextFor(tester, 'en');
      expect(item.localizedName(context), 'Upper Body Power');
    });
  });
}
