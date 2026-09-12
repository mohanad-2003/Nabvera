import 'package:nabvera/core/localization/generated/app_localizations.dart';
import 'package:nabvera/features/home/presentation/providers/home_dashboard_controller.dart';
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
  group('MuscleGroupRecovery.listFromJson', () {
    test('parses each group\'s status correctly', () {
      final list = MuscleGroupRecovery.listFromJson({
        'chest': {'status': 'needs_recovery', 'lastTrainedAt': '2026-01-01T00:00:00.000Z'},
        'legs': {'status': 'ready', 'lastTrainedAt': null},
      });

      final chest = list.firstWhere((g) => g.group == 'chest');
      final legs = list.firstWhere((g) => g.group == 'legs');
      expect(chest.status, RecoveryStatus.needsRecovery);
      expect(legs.status, RecoveryStatus.ready);
    });

    test('returns an empty list for null input', () {
      expect(MuscleGroupRecovery.listFromJson(null), isEmpty);
    });

    test('treats a missing/unrecognized status as ready (never blocks by default)', () {
      final list = MuscleGroupRecovery.listFromJson({
        'core': <String, dynamic>{},
      });
      expect(list.single.status, RecoveryStatus.ready);
    });
  });

  group('AlternativeWorkoutSuggestion.fromJson', () {
    test('parses a full alternative document', () {
      final alt = AlternativeWorkoutSuggestion.fromJson({
        'workout': {'_id': 'w1', 'title': 'Leg Day'},
        'reasonCode': 'muscle_recovery_alternative',
      });
      expect(alt, isNotNull);
      expect(alt!.id, 'w1');
      expect(alt.title, 'Leg Day');
      expect(alt.reasonCode, 'muscle_recovery_alternative');
    });

    test('returns null for a null or workout-less document', () {
      expect(AlternativeWorkoutSuggestion.fromJson(null), isNull);
      expect(AlternativeWorkoutSuggestion.fromJson({'reasonCode': 'x'}), isNull);
    });

    test('parses titleAr from the nested workout document', () {
      final alt = AlternativeWorkoutSuggestion.fromJson({
        'workout': {'_id': 'w1', 'title': 'Leg Day', 'titleAr': 'يوم الأرجل'},
        'reasonCode': 'muscle_recovery_alternative',
      });
      expect(alt!.titleAr, 'يوم الأرجل');
    });
  });

  group('AlternativeWorkoutSuggestion.localizedTitle', () {
    const translated = AlternativeWorkoutSuggestion(
      id: 'w1',
      title: 'Leg Day',
      titleAr: 'يوم الأرجل',
      reasonCode: 'muscle_recovery_alternative',
    );
    const untranslated = AlternativeWorkoutSuggestion(
      id: 'w2',
      title: 'Arm Day',
      reasonCode: 'muscle_recovery_alternative',
    );

    testWidgets('shows titleAr under Arabic when set', (tester) async {
      final context = await _contextFor(tester, 'ar');
      expect(translated.localizedTitle(context), 'يوم الأرجل');
    });

    testWidgets('falls back to English under Arabic when titleAr is empty', (tester) async {
      final context = await _contextFor(tester, 'ar');
      expect(untranslated.localizedTitle(context), 'Arm Day');
    });

    testWidgets('shows English under an English locale regardless of titleAr', (tester) async {
      final context = await _contextFor(tester, 'en');
      expect(translated.localizedTitle(context), 'Leg Day');
    });
  });

  group('HomeFeaturedWorkout.localizedTitle', () {
    const translated = HomeFeaturedWorkout(
      id: 'w1',
      title: 'Upper Body Power',
      titleAr: 'قوة الجزء العلوي',
      durationMinutes: 40,
      estimatedCalories: 350,
      difficulty: 'intermediate',
      exerciseCount: 6,
      reasonCode: 'on_track',
      recoveryMap: [],
    );
    const untranslated = HomeFeaturedWorkout(
      id: 'w2',
      title: 'Lower Body Strength',
      durationMinutes: 35,
      estimatedCalories: 300,
      difficulty: 'beginner',
      exerciseCount: 5,
      reasonCode: 'on_track',
      recoveryMap: [],
    );

    testWidgets('shows titleAr under Arabic when set', (tester) async {
      final context = await _contextFor(tester, 'ar');
      expect(translated.localizedTitle(context), 'قوة الجزء العلوي');
    });

    testWidgets('falls back to English under Arabic when titleAr is empty', (tester) async {
      final context = await _contextFor(tester, 'ar');
      expect(untranslated.localizedTitle(context), 'Lower Body Strength');
    });

    testWidgets('shows English under an English locale regardless of titleAr', (tester) async {
      final context = await _contextFor(tester, 'en');
      expect(translated.localizedTitle(context), 'Upper Body Power');
    });
  });
}
