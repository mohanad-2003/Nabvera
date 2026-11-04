import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nabvera/core/localization/generated/app_localizations.dart';
import 'package:nabvera/features/workout/presentation/widgets/workout_detail_labels.dart';

void main() {
  for (final language in ['ar', 'en']) {
    testWidgets('detail labels follow $language and preserve unknown content', (
      tester,
    ) async {
      late BuildContext context;
      await tester.pumpWidget(
        MaterialApp(
          locale: Locale(language),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: Builder(
            builder: (value) {
              context = value;
              return const SizedBox.shrink();
            },
          ),
        ),
      );
      final l10n = AppLocalizations.of(context);
      expect(
        workoutDetailLabel(context, 'Beginner'),
        l10n.workoutLevelBeginner,
      );
      expect(
        workoutDetailLabel(context, 'Advanced'),
        l10n.workoutLevelAdvanced,
      );
      expect(
        workoutDetailLabel(context, 'Exercises'),
        l10n.createRoutineSummaryExercises,
      );
      expect(
        workoutDetailLabel(context, 'Round 2'),
        l10n.workoutRoundNumber(2),
      );
      expect(
        workoutDetailLabel(context, '35 Minutes'),
        '35 ${l10n.homeUnitMin}',
      );
      expect(
        workoutDetailLabel(context, '280 Kcal'),
        '280 ${l10n.homeUnitKcal}',
      );
      expect(
        workoutDetailLabel(context, '3 sets'),
        '3 ${l10n.createRoutineSetsLabel}',
      );
      expect(
        workoutDetailLabel(context, '10x Reps'),
        '10 ${l10n.workoutRepsLabel}',
      );
      expect(
        workoutDetailLabel(context, '30 seconds'),
        language == 'ar' ? '30 ثانية' : '30 seconds',
      );
      // Timed holds and custom labels must never become repetitions/sets.
      expect(workoutDetailLabel(context, '00:30'), '00:30');
      expect(workoutDetailLabel(context, 'Custom exercise'), 'Custom exercise');
      expect(workoutDetailLabel(context, '— Minutes'), '— ${l10n.homeUnitMin}');
    });
  }
}
