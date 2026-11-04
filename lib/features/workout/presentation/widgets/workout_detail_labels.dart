import 'package:flutter/widgets.dart';
import 'package:nabvera/core/localization/generated/app_localizations.dart';

/// Localizes known legacy display labels without changing session data.
/// Unknown content and timer values are preserved verbatim.
String workoutDetailLabel(BuildContext context, String value) {
  final l10n = AppLocalizations.of(context);
  final ar = Localizations.localeOf(context).languageCode == 'ar';
  final key = value.trim().toLowerCase();
  final label = switch (key) {
    'beginner' => l10n.workoutLevelBeginner,
    'intermediate' => l10n.workoutLevelIntermediate,
    'advanced' || 'advance' => l10n.workoutLevelAdvanced,
    'workout' => l10n.workoutTitle,
    'exercises' => l10n.createRoutineSummaryExercises,
    'chest' => l10n.muscleGroupChest,
    'back' => l10n.muscleGroupBack,
    'legs' => l10n.muscleGroupLegs,
    'shoulders' => l10n.muscleGroupShoulders,
    'arms' => l10n.muscleGroupArms,
    'core' => l10n.muscleGroupCore,
    'full body' => l10n.muscleGroupFullBody,
    'cardio' => l10n.muscleGroupCardio,
    'bodyweight' => ar ? 'وزن الجسم' : 'Bodyweight',
    'dumbbell' || 'dumbbells' => l10n.onboardingEquipmentDumbbell,
    'barbell' => l10n.onboardingEquipmentBarbell,
    'kettlebell' => l10n.onboardingEquipmentKettlebell,
    'machine' || 'machines' => l10n.onboardingEquipmentMachine,
    _ => null,
  };
  if (label != null) return label;

  final round = RegExp(r'^round\s+(\d+)$').firstMatch(key);
  if (round != null) {
    return l10n.workoutRoundNumber(int.parse(round.group(1)!));
  }
  final quantity = RegExp(
    r'^(\d+(?:\.\d+)?|—)\s*(?:x\s*)?(minutes?|mins?|kcal|sets?|reps?|seconds?|secs?)$',
  ).firstMatch(key);
  if (quantity == null) return value;
  final number = quantity.group(1)!;
  final unit = quantity.group(2)!;
  if (unit.startsWith('min')) return '$number ${l10n.homeUnitMin}';
  if (unit == 'kcal') return '$number ${l10n.homeUnitKcal}';
  if (unit.startsWith('set')) {
    return '$number ${l10n.createRoutineSetsLabel}';
  }
  if (unit.startsWith('rep')) return '$number ${l10n.workoutRepsLabel}';
  return ar ? '$number ثانية' : '$number seconds';
}
