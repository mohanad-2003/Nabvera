import 'package:nabvera/core/localization/generated/app_localizations.dart';
import 'package:nabvera/features/nutrition/domain/nutrition_models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

/// Pumps an otherwise-empty app under [languageCode] and hands back a
/// [BuildContext] with a real `Localizations` ancestor, so
/// `Localizations.localeOf(context)` inside the `localizedX(context)`
/// getters under test resolves exactly as it would in the real app.
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
  group('MealItem — fromJson + localizedName/localizedSubtitle', () {
    test('fromJson parses titleAr/descriptionAr from a /api/recipes document', () {
      final item = MealItem.fromJson({
        '_id': 'r1',
        'title': 'Carrot Orange Smoothie',
        'titleAr': 'سموذي الجزر والبرتقال',
        'description': 'A quick, sweet start to the day.',
        'descriptionAr': 'بداية سريعة وحلوة لليوم.',
      });
      expect(item.name, 'Carrot Orange Smoothie');
      expect(item.nameAr, 'سموذي الجزر والبرتقال');
      expect(item.subtitle, 'A quick, sweet start to the day.');
      expect(item.subtitleAr, 'بداية سريعة وحلوة لليوم.');
    });

    testWidgets('shows nameAr/subtitleAr under Arabic when set', (tester) async {
      const item = MealItem(
        image: 'assets/workout.png',
        name: 'Carrot Orange Smoothie',
        nameAr: 'سموذي الجزر والبرتقال',
        subtitle: 'A quick, sweet start to the day.',
        subtitleAr: 'بداية سريعة وحلوة لليوم.',
        time: '10 Minutes',
        calories: '70 Cal',
      );
      final context = await _contextFor(tester, 'ar');
      expect(item.localizedName(context), 'سموذي الجزر والبرتقال');
      expect(item.localizedSubtitle(context), 'بداية سريعة وحلوة لليوم.');
    });

    testWidgets('falls back to English under Arabic when untranslated', (tester) async {
      const item = MealItem(
        image: 'assets/workout.png',
        name: 'Carrot Orange Smoothie',
        subtitle: 'A quick, sweet start to the day.',
        time: '10 Minutes',
        calories: '70 Cal',
      );
      final context = await _contextFor(tester, 'ar');
      expect(item.localizedName(context), 'Carrot Orange Smoothie');
      expect(item.localizedSubtitle(context), 'A quick, sweet start to the day.');
    });
  });

  group('MealDetail.localizedName', () {
    test('fromJson parses titleAr from a /api/recipes/:id document', () {
      final detail = MealDetail.fromJson({
        'title': 'Carrot Orange Smoothie',
        'titleAr': 'سموذي الجزر والبرتقال',
      });
      expect(detail.nameAr, 'سموذي الجزر والبرتقال');
    });

    testWidgets('falls back to English under Arabic when untranslated', (tester) async {
      const detail = MealDetail(
        image: 'assets/workout.png',
        name: 'Carrot Orange Smoothie',
        time: '10 Minutes',
        calories: '70 Cal',
      );
      final context = await _contextFor(tester, 'ar');
      expect(detail.localizedName(context), 'Carrot Orange Smoothie');
    });
  });
}
