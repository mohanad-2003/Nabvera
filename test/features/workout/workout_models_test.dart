import 'package:nabvera/core/localization/generated/app_localizations.dart';
import 'package:nabvera/core/localization/generated/app_localizations_en.dart';
import 'package:nabvera/features/workout/domain/workout_models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

/// Pumps an otherwise-empty app under [languageCode] and hands back a
/// [BuildContext] with a real `Localizations` ancestor, so
/// `Localizations.localeOf(context)` inside the `localizedName(context)`
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
  group('WorkoutListItem — fromJson + localizedName', () {
    test('fromJson parses both title and titleAr from a /api/workouts document', () {
      final item = WorkoutListItem.fromJson({
        '_id': 'w1',
        'title': 'Upper Body Power',
        'titleAr': 'قوة الجزء العلوي',
        'coverImageUrl': 'cover.png',
        'durationMinutes': 35,
        'estimatedCalories': 320,
      }, isFavorite: false);
      expect(item.name, 'Upper Body Power');
      expect(item.nameAr, 'قوة الجزء العلوي');
    });

    test('fromJson defaults titleAr to empty when the backend omits it', () {
      final item = WorkoutListItem.fromJson({
        '_id': 'w2',
        'title': 'Full Body HIIT',
      }, isFavorite: false);
      expect(item.nameAr, '');
    });

    testWidgets('localizedName shows nameAr under Arabic when set', (tester) async {
      const item = WorkoutListItem(
        image: 'assets/workout.png',
        name: 'Upper Body Power',
        nameAr: 'قوة الجزء العلوي',
      );
      final context = await _contextFor(tester, 'ar');
      expect(item.localizedName(context), 'قوة الجزء العلوي');
    });

    testWidgets('localizedName falls back to English under Arabic when nameAr is empty', (tester) async {
      const item = WorkoutListItem(image: 'assets/workout.png', name: 'Full Body HIIT');
      final context = await _contextFor(tester, 'ar');
      expect(item.localizedName(context), 'Full Body HIIT');
    });

    testWidgets('localizedName shows English under an English locale regardless of nameAr', (tester) async {
      const item = WorkoutListItem(
        image: 'assets/workout.png',
        name: 'Upper Body Power',
        nameAr: 'قوة الجزء العلوي',
      );
      final context = await _contextFor(tester, 'en');
      expect(item.localizedName(context), 'Upper Body Power');
    });
  });

  group('RoutineExercise — fromJson + localizedName', () {
    test('fromJson parses both name and nameAr from a /api/exercises document', () {
      final entry = RoutineExercise.fromJson({
        '_id': 'e1',
        'name': 'Push Up',
        'nameAr': 'ضغط',
        'muscleGroup': 'chest',
      });
      expect(entry.name, 'Push Up');
      expect(entry.nameAr, 'ضغط');
      expect(entry.muscleGroup, MuscleGroup.chest);
    });

    testWidgets('localizedName falls back to English under Arabic when nameAr is empty', (tester) async {
      const entry = RoutineExercise(
        id: 'e2',
        image: 'assets/workout.png',
        name: 'Squat',
        muscleGroup: MuscleGroup.legs,
        time: '3 sets',
      );
      final context = await _contextFor(tester, 'ar');
      expect(entry.localizedName(context), 'Squat');
    });
  });

  group('PopularExerciseItem — localizedName + difficulty', () {
    testWidgets('localizedName shows nameAr under Arabic when set', (tester) async {
      const item = PopularExerciseItem(
        image: 'assets/workout.png',
        name: 'Push Up',
        nameAr: 'ضغط',
        time: '3 sets',
        calories: '50 Kcal',
      );
      final context = await _contextFor(tester, 'ar');
      expect(item.localizedName(context), 'ضغط');
    });

    test('difficulty defaults to the raw backend value "beginner", not a formatted English label', () {
      const item = PopularExerciseItem(
        image: 'assets/workout.png',
        name: 'Push Up',
        time: '3 sets',
        calories: '50 Kcal',
      );
      expect(item.difficulty, 'beginner');
    });
  });

  group('exerciseDifficultyLabel', () {
    final l10n = AppLocalizationsEn();

    test('maps every raw backend value to its localized label', () {
      expect(exerciseDifficultyLabel(l10n, 'beginner'), l10n.workoutLevelBeginner);
      expect(exerciseDifficultyLabel(l10n, 'intermediate'), l10n.workoutLevelIntermediate);
      expect(exerciseDifficultyLabel(l10n, 'advanced'), l10n.workoutLevelAdvanced);
    });

    test('defaults an unrecognized or missing value to beginner', () {
      expect(exerciseDifficultyLabel(l10n, null), l10n.workoutLevelBeginner);
      expect(exerciseDifficultyLabel(l10n, 'made_up'), l10n.workoutLevelBeginner);
    });
  });
}
