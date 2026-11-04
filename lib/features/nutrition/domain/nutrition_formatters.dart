import 'package:intl/intl.dart';

import '../../../core/localization/generated/app_localizations.dart';
import 'nutrition_models.dart';

// Digits stay Western ('en') on purpose: the rest of the app interpolates raw
// ints into Arabic strings, so a locale-specific digit set here would mix
// two numeral systems on one screen.
final NumberFormat _decimal = NumberFormat('#,##0.##', 'en');

String formatNutritionNumber(num value) => _decimal.format(value);

/// Text for a macro's intake line. Returns null when the API sent no consumed
/// value — callers show a dash, never a 0 that never happened.
String? macroIntakeText(AppLocalizations l10n, MacroIntake macro) {
  final consumed = macro.consumed;
  if (consumed == null) return null;
  if (macro.hasGoal) {
    return l10n.nutritionMacroGramsProgress(
      formatNutritionNumber(consumed),
      formatNutritionNumber(macro.goal!),
    );
  }
  return l10n.nutritionMacroGramsValue(formatNutritionNumber(consumed));
}

/// "1.5 / 2 L" or "750 / 2000 ml", from the raw API millilitres. Null when
/// the raw consumed value is missing, so callers fall back to the existing
/// cup units rather than inventing an exact amount.
String? waterIntakeText(AppLocalizations l10n, num? consumedMl, num? goalMl) {
  if (consumedMl == null) return null;
  final hasGoal = goalMl != null && goalMl > 0;
  final useLiters = (hasGoal ? goalMl : consumedMl) >= 1000;

  String liters(num ml) => formatNutritionNumber(ml / 1000);
  String millis(num ml) => formatNutritionNumber(ml.round());

  if (hasGoal) {
    return useLiters
        ? l10n.nutritionWaterProgressL(liters(consumedMl), liters(goalMl))
        : l10n.nutritionWaterProgressMl(millis(consumedMl), millis(goalMl));
  }
  return useLiters
      ? l10n.nutritionWaterAmountL(liters(consumedMl))
      : l10n.nutritionWaterAmountMl(millis(consumedMl));
}
