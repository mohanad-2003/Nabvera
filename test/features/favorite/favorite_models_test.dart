import 'package:nabvera/core/localization/generated/app_localizations.dart';
import 'package:nabvera/features/favorite/domain/favorite_models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

/// Pumps an otherwise-empty app under [languageCode] and hands back a
/// [BuildContext] with a real `Localizations` ancestor, so
/// `Localizations.localeOf(context)` inside `localizedTitle(context)`
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
  group('FavoriteItem.fromWorkoutJson / fromRecipeJson', () {
    test('fromWorkoutJson parses titleAr from a /api/workouts/:id document', () {
      final item = FavoriteItem.fromWorkoutJson({
        '_id': 'w1',
        'title': 'Upper Body Power',
        'titleAr': 'قوة الجزء العلوي',
      });
      expect(item.title, 'Upper Body Power');
      expect(item.titleAr, 'قوة الجزء العلوي');
      expect(item.type, FavoriteType.video);
    });

    test('fromRecipeJson parses titleAr from a /api/recipes/:id document', () {
      final item = FavoriteItem.fromRecipeJson({
        '_id': 'r1',
        'title': 'Carrot Orange Smoothie',
        'titleAr': 'سموذي الجزر والبرتقال',
      });
      expect(item.titleAr, 'سموذي الجزر والبرتقال');
      expect(item.type, FavoriteType.article);
    });

    test('titleAr defaults to empty when the backend omits it', () {
      final item = FavoriteItem.fromWorkoutJson({'_id': 'w2', 'title': 'Full Body HIIT'});
      expect(item.titleAr, '');
    });
  });

  group('FavoriteItem.localizedTitle', () {
    testWidgets('shows titleAr under Arabic when set', (tester) async {
      const item = FavoriteItem(
        id: 'w1',
        image: 'assets/workout.png',
        title: 'Upper Body Power',
        titleAr: 'قوة الجزء العلوي',
        type: FavoriteType.video,
      );
      final context = await _contextFor(tester, 'ar');
      expect(item.localizedTitle(context), 'قوة الجزء العلوي');
    });

    testWidgets('falls back to English under Arabic when titleAr is empty', (tester) async {
      const item = FavoriteItem(
        id: 'w2',
        image: 'assets/workout.png',
        title: 'Full Body HIIT',
        type: FavoriteType.video,
      );
      final context = await _contextFor(tester, 'ar');
      expect(item.localizedTitle(context), 'Full Body HIIT');
    });
  });
}
