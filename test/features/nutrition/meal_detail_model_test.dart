import 'package:nabvera/features/nutrition/domain/nutrition_models.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('MealDetail.defaultMealType', () {
    test('uses category directly when it is a valid mealType', () {
      final meal = MealDetail.fromJson({'category': 'breakfast'});
      expect(meal.defaultMealType, 'breakfast');
    });

    test('falls back to "snack" for a category outside {breakfast, lunch, dinner, snack} (e.g. "drink")', () {
      final meal = MealDetail.fromJson({'category': 'drink'});
      expect(meal.defaultMealType, 'snack');
    });

    test('falls back to "snack" when no category is present at all', () {
      final meal = MealDetail.fromJson({});
      expect(meal.defaultMealType, 'snack');
    });
  });

  test('MealDetail.fromJson never throws when "steps" is missing entirely (a recipe with no steps yet)', () {
    // Regression test: `(json['steps'] as List? ?? const [])` used to
    // return an unmodifiable list here, and `..sort()` on it threw.
    expect(() => MealDetail.fromJson({}), returnsNormally);
    expect(MealDetail.fromJson({}).preparation, isEmpty);
  });
}
