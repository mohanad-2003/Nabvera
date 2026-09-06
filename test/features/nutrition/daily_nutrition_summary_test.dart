import 'package:nabvera/features/nutrition/domain/nutrition_models.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('DailyNutritionSummary.fromEntry', () {
    test('parses calories/macros/water from a full backend document', () {
      final summary = DailyNutritionSummary.fromEntry({
        'calorieGoal': 2200,
        'caloriesConsumed': 1100,
        'proteinGoalG': 150,
        'proteinConsumedG': 75,
        'carbsGoalG': 250,
        'carbsConsumedG': 125,
        'fatGoalG': 70,
        'fatConsumedG': 35,
        'waterGoalMl': 2000,
        'waterConsumedMl': 500,
      });

      expect(summary.consumedCalories, 1100);
      expect(summary.goalCalories, 2200);
      expect(summary.proteinFraction, 0.5);
      expect(summary.carbsFraction, 0.5);
      expect(summary.fatFraction, 0.5);
      expect(summary.waterIntake, '2 / 8 cups');
    });

    test('this is exactly the logic behind logging water: a fresh entry with more waterConsumedMl bumps the cup count', () {
      final before = DailyNutritionSummary.fromEntry({'waterGoalMl': 2000, 'waterConsumedMl': 500});
      final after = DailyNutritionSummary.fromEntry({'waterGoalMl': 2000, 'waterConsumedMl': 750});

      expect(before.waterIntake, '2 / 8 cups');
      expect(after.waterIntake, '3 / 8 cups');
    });

    test('defaults to a 2000ml/8-cup goal and 0 consumed when the field is missing', () {
      final summary = DailyNutritionSummary.fromEntry({});
      expect(summary.waterIntake, '0 / 8 cups');
    });

    test('macro fractions never exceed 1 even if consumed is above goal', () {
      final summary = DailyNutritionSummary.fromEntry({
        'proteinGoalG': 100,
        'proteinConsumedG': 250,
      });
      expect(summary.proteinFraction, 1.0);
    });

    test('preserves a 0 calorieGoal as-is rather than substituting a default (the card itself guards the division)', () {
      final summary = DailyNutritionSummary.fromEntry({'calorieGoal': 0, 'caloriesConsumed': 100});
      expect(summary.goalCalories, 0);
      expect(summary.consumedCalories, 100);
    });
  });
}
