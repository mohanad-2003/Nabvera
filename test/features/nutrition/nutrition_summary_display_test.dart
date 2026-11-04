import 'package:flutter_test/flutter_test.dart';
import 'package:nabvera/core/localization/generated/app_localizations_ar.dart';
import 'package:nabvera/core/localization/generated/app_localizations_en.dart';
import 'package:nabvera/features/nutrition/domain/nutrition_formatters.dart';
import 'package:nabvera/features/nutrition/domain/nutrition_models.dart';
import 'package:nabvera/features/nutrition/domain/nutrition_recipe_sections.dart';

MealItem _item(String id, {String name = 'Dish'}) => MealItem(
  id: id,
  image: 'assets/workout.png',
  name: name,
  time: '10 Minutes',
  calories: '200 Cal',
);

void main() {
  group('DailyNutritionSummary raw macro grams', () {
    test(
      'keeps the API grams as-is, not derived from the clamped fractions',
      () {
        final summary = DailyNutritionSummary.fromEntry({
          'proteinConsumedG': 180,
          'proteinGoalG': 120,
          'carbsConsumedG': 62.5,
          'carbsGoalG': 250,
          'fatConsumedG': 20,
          'fatGoalG': 70,
        });

        expect(summary.proteinConsumedG, 180);
        expect(summary.proteinGoalG, 120);
        expect(summary.carbsConsumedG, 62.5);
        expect(summary.fatGoalG, 70);
        // The fraction is clamped for the bar; the grams are not.
        expect(summary.proteinFraction, 1.0);
        expect(summary.protein.consumed, 180);
        expect(summary.protein.progress, 1.0);
      },
    );

    test('missing macros stay null rather than becoming a real 0', () {
      final summary = DailyNutritionSummary.fromEntry({
        'caloriesConsumed': 300,
      });

      expect(summary.proteinConsumedG, isNull);
      expect(summary.proteinGoalG, isNull);
      expect(summary.carbs.consumed, isNull);
      expect(summary.fat.progress, isNull);
      expect(summary.protein.hasGoal, isFalse);
    });

    test(
      'a zero or missing macro goal gives no progress and no divide-by-zero',
      () {
        final zero = DailyNutritionSummary.fromEntry({
          'proteinConsumedG': 40,
          'proteinGoalG': 0,
        });
        expect(zero.protein.hasGoal, isFalse);
        expect(zero.protein.progress, isNull);
        expect(zero.proteinFraction, 0);

        final missingGoal = DailyNutritionSummary.fromEntry({
          'carbsConsumedG': 90,
        });
        expect(missingGoal.carbsConsumedG, 90);
        expect(missingGoal.carbsFraction, 0);
      },
    );

    test('copyWith carries every new field through unchanged', () {
      final summary = DailyNutritionSummary.fromEntry({
        'calorieGoal': 2000,
        'caloriesConsumed': 500,
        'proteinConsumedG': 10,
        'proteinGoalG': 100,
        'carbsConsumedG': 20,
        'carbsGoalG': 200,
        'fatConsumedG': 5,
        'fatGoalG': 50,
        'waterConsumedMl': 750,
        'waterGoalMl': 2500,
      });

      final copy = summary.copyWith(isLoading: true, loadFailed: false);

      expect(copy.isLoading, isTrue);
      expect(copy.proteinConsumedG, 10);
      expect(copy.proteinGoalG, 100);
      expect(copy.carbsConsumedG, 20);
      expect(copy.carbsGoalG, 200);
      expect(copy.fatConsumedG, 5);
      expect(copy.fatGoalG, 50);
      expect(copy.waterConsumedMl, 750);
      expect(copy.waterGoalMl, 2500);
    });

    test(
      'existing call sites that never pass the new fields still compile and default to null',
      () {
        const summary = DailyNutritionSummary(
          consumedCalories: 1,
          goalCalories: 2,
          proteinFraction: 0,
          carbsFraction: 0,
          fatFraction: 0,
          waterIntake: '0 / 8 cups',
        );
        expect(summary.proteinConsumedG, isNull);
        expect(summary.waterConsumedMl, isNull);
        expect(summary.loadFailed, isFalse);
      },
    );
  });

  group('DailyNutritionSummary calories', () {
    test('under the goal: remaining is goal minus consumed', () {
      final s = DailyNutritionSummary.fromEntry({
        'calorieGoal': 2000,
        'caloriesConsumed': 760,
      });
      expect(s.hasCalorieGoal, isTrue);
      expect(s.isOverCalorieGoal, isFalse);
      expect(s.caloriesRemaining, 1240);
      expect(s.caloriesOverGoal, 0);
      expect(s.calorieProgress, closeTo(0.38, 1e-9));
    });

    test('exactly at the goal: nothing remaining and not over', () {
      final s = DailyNutritionSummary.fromEntry({
        'calorieGoal': 2000,
        'caloriesConsumed': 2000,
      });
      expect(s.caloriesRemaining, 0);
      expect(s.isOverCalorieGoal, isFalse);
      expect(s.calorieProgress, 1.0);
    });

    test(
      'over the goal: reports the overshoot, never a negative remainder, and keeps the real consumed value',
      () {
        final s = DailyNutritionSummary.fromEntry({
          'calorieGoal': 2000,
          'caloriesConsumed': 2350,
        });
        expect(s.isOverCalorieGoal, isTrue);
        expect(s.caloriesOverGoal, 350);
        expect(s.caloriesRemaining, 0);
        expect(s.consumedCalories, 2350);
        expect(s.calorieProgress, 1.0);
      },
    );

    test(
      'a zero goal means "no goal": no remaining, no progress, never "goal reached"',
      () {
        final s = DailyNutritionSummary.fromEntry({
          'calorieGoal': 0,
          'caloriesConsumed': 400,
        });
        expect(s.hasCalorieGoal, isFalse);
        expect(s.caloriesRemaining, isNull);
        expect(s.calorieProgress, isNull);
        expect(s.isOverCalorieGoal, isFalse);
        expect(s.caloriesOverGoal, 0);
        expect(s.consumedCalories, 400);
      },
    );

    test(
      'a missing goal keeps the previous 2000 default and is never a personal goal (Home reads the same field)',
      () {
        final s = DailyNutritionSummary.fromEntry({'caloriesConsumed': 100});
        expect(s.goalCalories, 2000);
        expect(s.hasPersonalGoal, isFalse);
      },
    );
  });

  group('DailyNutritionSummary water', () {
    test('keeps the raw ml next to the rounded cups', () {
      final s = DailyNutritionSummary.fromEntry({
        'waterConsumedMl': 400,
        'waterGoalMl': 2000,
      });
      expect(s.waterConsumedMl, 400);
      expect(s.waterGoalMl, 2000);
      expect(s.waterCupsConsumed, 2); // 1.6 cups, rounded for display only
      expect(s.waterProgress, closeTo(0.2, 1e-9));
    });

    test('raw ml are null when the API omits them', () {
      final s = DailyNutritionSummary.fromEntry({});
      expect(s.waterConsumedMl, isNull);
      expect(s.waterGoalMl, isNull);
      expect(s.waterProgress, isNull);
    });

    test(
      'progress is capped at 1 for the bar, but the raw amount is untouched',
      () {
        final s = DailyNutritionSummary.fromEntry({
          'waterConsumedMl': 3000,
          'waterGoalMl': 2000,
        });
        expect(s.waterProgress, 1.0);
        expect(s.waterConsumedMl, 3000);
      },
    );
  });

  group('nutrition formatters', () {
    final en = AppLocalizationsEn();
    final ar = AppLocalizationsAr();

    test('macro intake shows grams consumed / goal', () {
      expect(
        macroIntakeText(en, const MacroIntake(consumed: 75.5, goal: 150)),
        '75.5 / 150 g',
      );
      expect(
        macroIntakeText(ar, const MacroIntake(consumed: 75, goal: 150)),
        '75 / 150 غ',
      );
    });

    test('macro without a goal shows only what was eaten', () {
      expect(macroIntakeText(en, const MacroIntake(consumed: 40)), '40 g');
      expect(
        macroIntakeText(en, const MacroIntake(consumed: 40, goal: 0)),
        '40 g',
      );
    });

    test(
      'macro with no consumed value has no text (the UI shows a dash, not 0)',
      () {
        expect(macroIntakeText(en, const MacroIntake(goal: 150)), isNull);
        expect(macroIntakeText(en, const MacroIntake()), isNull);
      },
    );

    test('water uses litres once the goal reaches 1 L, millilitres below', () {
      expect(waterIntakeText(en, 750, 2000), '0.75 / 2 L');
      expect(waterIntakeText(ar, 1500, 2500), '1.5 / 2.5 لتر');
      expect(waterIntakeText(en, 250, 800), '250 / 800 ml');
      expect(waterIntakeText(ar, 250, 800), '250 / 800 مل');
    });

    test('water without a goal shows just the amount', () {
      expect(waterIntakeText(en, 500, null), '500 ml');
      expect(waterIntakeText(en, 1500, 0), '1.5 L');
    });

    test(
      'water without a raw consumed value gives null so callers keep the cup units',
      () {
        expect(waterIntakeText(en, null, 2000), isNull);
      },
    );
  });

  group('splitNutritionRecipes', () {
    test(
      'the first recommended recipe is today\'s; it is not repeated anywhere else',
      () {
        final sections = splitNutritionRecipes(
          recommended: [_item('a'), _item('b')],
          recipes: [_item('a'), _item('c'), _item('b'), _item('d')],
        );

        expect(sections.today?.id, 'a');
        expect(sections.suggested.map((e) => e.id), ['b']);
        expect(sections.explore.map((e) => e.id), ['c', 'd']);
      },
    );

    test('no recipe id appears twice across the whole page', () {
      final sections = splitNutritionRecipes(
        recommended: [_item('a'), _item('b'), _item('b')],
        recipes: [_item('a'), _item('b'), _item('c'), _item('c')],
      );
      final ids = [
        sections.today!.id,
        ...sections.suggested.map((e) => e.id),
        ...sections.explore.map((e) => e.id),
      ];
      expect(ids, ['a', 'b', 'c']);
    });

    test(
      'does not touch the lists it was given (the shared source stays whole)',
      () {
        final recommended = [_item('a'), _item('b')];
        final recipes = [_item('a'), _item('c')];
        splitNutritionRecipes(recommended: recommended, recipes: recipes);
        expect(recommended.map((e) => e.id), ['a', 'b']);
        expect(recipes.map((e) => e.id), ['a', 'c']);
      },
    );

    test('a section that ends up empty is empty, not padded', () {
      final sections = splitNutritionRecipes(
        recommended: [_item('a')],
        recipes: [_item('a')],
      );
      expect(sections.today?.id, 'a');
      expect(sections.suggested, isEmpty);
      expect(sections.explore, isEmpty);
      expect(sections.isEmpty, isFalse);
    });

    test('nothing at all gives an empty result', () {
      final sections = splitNutritionRecipes(
        recommended: const [],
        recipes: const [],
      );
      expect(sections.today, isNull);
      expect(sections.isEmpty, isTrue);
    });

    test('recipes without an id are kept (they cannot be matched)', () {
      final sections = splitNutritionRecipes(
        recommended: [_item('a')],
        recipes: [_item(''), _item('')],
      );
      expect(sections.explore, hasLength(2));
    });
  });

  group('MealItem protein', () {
    test(
      'reads proteinG as a number, and leaves it null when the recipe has none',
      () {
        final withProtein = MealItem.fromJson({
          '_id': 'x',
          'nutrition': {'proteinG': 31.5, 'calories': 400},
        });
        expect(withProtein.proteinGrams, 31.5);

        final without = MealItem.fromJson({
          '_id': 'y',
          'nutrition': {'calories': 400},
        });
        expect(without.proteinGrams, isNull);
        expect(without.protein, isNull);
      },
    );
  });
}
