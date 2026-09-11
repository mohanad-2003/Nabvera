import 'package:nabvera/core/localization/generated/app_localizations.dart';
import 'package:nabvera/features/workout/domain/exercise_detail_models.dart';
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
  group('ExerciseDetailData.localizedTitle', () {
    testWidgets('shows titleAr under Arabic when set', (tester) async {
      const data = ExerciseDetailData(
        headerTitle: 'Workout',
        heroImage: 'assets/workout.png',
        title: 'Push Up',
        titleAr: 'ضغط',
      );
      final context = await _contextFor(tester, 'ar');
      expect(data.localizedTitle(context), 'ضغط');
    });

    testWidgets('falls back to English under Arabic when titleAr is empty', (tester) async {
      const data = ExerciseDetailData(
        headerTitle: 'Workout',
        heroImage: 'assets/workout.png',
        title: 'Push Up',
      );
      final context = await _contextFor(tester, 'ar');
      expect(data.localizedTitle(context), 'Push Up');
    });
  });

  group('RoundExerciseItem.localizedName', () {
    testWidgets('shows nameAr under Arabic when set', (tester) async {
      const item = RoundExerciseItem(
        name: 'Push Up',
        nameAr: 'ضغط',
        time: '3 sets',
        reps: '12x Reps',
        accent: Colors.orange,
      );
      final context = await _contextFor(tester, 'ar');
      expect(item.localizedName(context), 'ضغط');
    });

    testWidgets('falls back to English under Arabic when nameAr is empty', (tester) async {
      const item = RoundExerciseItem(
        name: 'Push Up',
        time: '3 sets',
        reps: '12x Reps',
        accent: Colors.orange,
      );
      final context = await _contextFor(tester, 'ar');
      expect(item.localizedName(context), 'Push Up');
    });
  });

  group('CategoryDetailData.fromWorkoutJson + localizedHeroLabel', () {
    final withTranslation = CategoryDetailData.fromWorkoutJson({
      '_id': 'w1',
      'title': 'Upper Body Power',
      'titleAr': 'قوة الجزء العلوي',
      'coverImageUrl': 'cover.png',
      'difficulty': 'intermediate',
      'durationMinutes': 35,
      'estimatedCalories': 320,
      'exercises': [
        {
          'sets': 3,
          'reps': 12,
          'exercise': {
            '_id': 'e1',
            'name': 'Push Up',
            'nameAr': 'ضغط',
            'muscleGroup': 'chest',
            'imageUrl': 'push_up.png',
          },
        },
      ],
    });
    final withoutTranslation = CategoryDetailData.fromWorkoutJson({
      '_id': 'w2',
      'title': 'Full Body HIIT',
      'exercises': const [],
    });

    test('parses heroLabelAr from the workout document', () {
      expect(withTranslation.heroLabelAr, 'قوة الجزء العلوي');
      expect(withoutTranslation.heroLabelAr, '');
    });

    test('parses each round exercise\'s nameAr, and threads it into its ExerciseDetailData', () {
      final round = withTranslation.rounds.single.items.single;
      expect(round.nameAr, 'ضغط');
      expect(round.exerciseDetail!.titleAr, 'ضغط');
    });

    testWidgets('localizedHeroLabel shows heroLabelAr under Arabic when set', (tester) async {
      final context = await _contextFor(tester, 'ar');
      expect(withTranslation.localizedHeroLabel(context), 'قوة الجزء العلوي');
    });

    testWidgets('localizedHeroLabel falls back to English under Arabic when untranslated', (tester) async {
      final context = await _contextFor(tester, 'ar');
      expect(withoutTranslation.localizedHeroLabel(context), 'Full Body HIIT');
    });
  });
}
