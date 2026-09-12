import 'package:nabvera/core/localization/generated/app_localizations.dart';
import 'package:nabvera/features/home/domain/home_models.dart';
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
  group('RecommendedWorkout.localizedTitle', () {
    const translated = RecommendedWorkout(
      title: 'Upper Body Power',
      titleAr: 'قوة الجزء العلوي',
      image: 'assets/workout.png',
      duration: '35 Minutes',
      calories: '320 Kcal',
    );
    const untranslated = RecommendedWorkout(
      title: 'Full Body HIIT',
      image: 'assets/workout.png',
      duration: '25 Minutes',
      calories: '280 Kcal',
    );

    testWidgets('shows the English title under an English locale', (tester) async {
      final context = await _contextFor(tester, 'en');
      expect(translated.localizedTitle(context), 'Upper Body Power');
    });

    testWidgets('shows titleAr under an Arabic locale when it is set', (tester) async {
      final context = await _contextFor(tester, 'ar');
      expect(translated.localizedTitle(context), 'قوة الجزء العلوي');
    });

    testWidgets('falls back to the English title under Arabic when titleAr is empty', (tester) async {
      final context = await _contextFor(tester, 'ar');
      expect(untranslated.localizedTitle(context), 'Full Body HIIT');
    });
  });

  group('ArticleTip.localized* — Arabic translation with English fallback', () {
    // Constructed directly (not via fromJson) so each field's role in the
    // getters under test is unambiguous — fromJson maps `description` to
    // the raw `title` (see its own doc comment: "Same as [description]"),
    // which would otherwise make a naive JSON-based fixture misleading here.
    const translated = ArticleTip(
      image: 'assets/workout.png',
      description: 'Beginner Supplement Guide',
      title: 'Beginner Supplement Guide',
      body: 'What actually helps, in full.',
      paragraphs: ['Paragraph one.', 'Paragraph two.'],
      titleAr: 'دليل المكملات الغذائية للمبتدئين',
      descriptionAr: 'اللي فعلًا بينفع.',
      paragraphsAr: ['فقرة واحد.', 'فقرة اثنين.'],
    );
    const untranslated = ArticleTip(
      image: 'assets/workout.png',
      description: 'Why Rest Days Matter',
      title: 'Why Rest Days Matter',
      body: 'The science behind resting well.',
      paragraphs: ['Paragraph one.'],
    );

    testWidgets('localizedTitle/localizedDescription/localizedBody/localizedParagraphs return Arabic when translated', (tester) async {
      final context = await _contextFor(tester, 'ar');
      expect(translated.localizedTitle(context), 'دليل المكملات الغذائية للمبتدئين');
      // descriptionAr does double duty for both the card blurb and the
      // detail page's body — there is no separate bodyAr field.
      expect(translated.localizedDescription(context), 'اللي فعلًا بينفع.');
      expect(translated.localizedBody(context), 'اللي فعلًا بينفع.');
      expect(translated.localizedParagraphs(context), ['فقرة واحد.', 'فقرة اثنين.']);
    });

    testWidgets('fall back to English under Arabic when the article has no translation', (tester) async {
      final context = await _contextFor(tester, 'ar');
      expect(untranslated.localizedTitle(context), 'Why Rest Days Matter');
      expect(untranslated.localizedDescription(context), 'Why Rest Days Matter');
      expect(untranslated.localizedBody(context), 'The science behind resting well.');
      expect(untranslated.localizedParagraphs(context), ['Paragraph one.']);
    });

    testWidgets('always show English under an English locale, translated or not', (tester) async {
      final context = await _contextFor(tester, 'en');
      expect(translated.localizedTitle(context), 'Beginner Supplement Guide');
      expect(untranslated.localizedTitle(context), 'Why Rest Days Matter');
    });
  });
}
