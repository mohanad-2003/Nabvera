import 'package:nabvera/features/nutrition/domain/meal_plan_models.dart';
import 'package:nabvera/features/nutrition/domain/nutrition_preferences.dart';
import 'package:flutter_test/flutter_test.dart';

Map<String, dynamic> _itemJson({
  String id = 'i1',
  String mealType = 'breakfast',
  Object? recipe = const {'_id': 'r1', 'title': 'Oatmeal', 'imageUrl': 'assets/workout.png', 'prepTimeMinutes': 10},
  bool isCustom = false,
  String? customName,
  int calories = 300,
  String explanationCode = 'matches_calorie_target',
}) => {
  '_id': id,
  'mealType': mealType,
  'recipe': recipe,
  'isCustom': isCustom,
  'customName': customName,
  'servings': 1,
  'calories': calories,
  'proteinG': 20,
  'carbsG': 30,
  'fatG': 10,
  'explanationCode': explanationCode,
};

Map<String, dynamic> _dayJson({int dayIndex = 0}) => {
  'dayIndex': dayIndex,
  'meals': {
    'breakfast': [_itemJson()],
    'lunch': [],
    'dinner': [],
    'snacks': [],
  },
  'dayExplanationCode': 'balanced_across_targets',
};

Map<String, dynamic> _planJson() => {
  '_id': 'p1',
  'isActive': true,
  'weekStartDate': '2026-09-06T00:00:00.000Z',
  'goal': 'keep_fit',
  'calorieTarget': 2000,
  'proteinTargetGrams': 150,
  'servings': 2,
  'cookingTimePreference': 'quick',
  'generationSource': 'ai',
  'days': List.generate(7, (i) => _dayJson(dayIndex: i)),
  'shoppingList': [
    {'_id': 's1', 'ingredientName': 'Rice', 'amount': '1 cup', 'checked': false},
  ],
  'disclaimerCode': 'general_nutrition_disclaimer',
};

void main() {
  group('MealPlanItem.fromJson', () {
    test('parses a recipe-backed item, flattening the populated recipe fields', () {
      final item = MealPlanItem.fromJson(_itemJson());
      expect(item.id, 'i1');
      expect(item.recipeId, 'r1');
      expect(item.recipeTitle, 'Oatmeal');
      expect(item.recipePrepTimeMinutes, 10);
      expect(item.displayTitle, 'Oatmeal');
      expect(item.isCustom, isFalse);
    });

    test('parses an unpopulated recipe ref (plain id string) without crashing', () {
      final item = MealPlanItem.fromJson(_itemJson(recipe: 'r1'));
      expect(item.recipeId, 'r1');
      expect(item.recipeTitle, isNull);
    });

    test('parses a custom/placeholder item with no recipe at all', () {
      final item = MealPlanItem.fromJson(
        _itemJson(recipe: null, isCustom: true, customName: 'Placeholder oatmeal', explanationCode: 'recipe_unavailable_placeholder'),
      );
      expect(item.recipeId, isNull);
      expect(item.isCustom, isTrue);
      expect(item.displayTitle, 'Placeholder oatmeal');
    });
  });

  group('MealPlanDay.fromJson', () {
    test('groups items by meal slot and computes totals', () {
      final day = MealPlanDay.fromJson(_dayJson());
      expect(day.breakfast, hasLength(1));
      expect(day.lunch, isEmpty);
      expect(day.totalCalories, 300);
      expect(day.totalProteinG, 20);
      expect(day.dayExplanationCode, 'balanced_across_targets');
    });
  });

  group('MealPlan.fromJson', () {
    test('parses a full plan with exactly 7 days and a shopping list', () {
      final plan = MealPlan.fromJson(_planJson());
      expect(plan.id, 'p1');
      expect(plan.days, hasLength(7));
      expect(plan.generationSource, 'ai');
      expect(plan.shoppingList, hasLength(1));
      expect(plan.shoppingList.first.ingredientName, 'Rice');
    });

    test('copyWith replaces only the given fields', () {
      final plan = MealPlan.fromJson(_planJson());
      final updated = plan.copyWith(shoppingList: []);
      expect(updated.shoppingList, isEmpty);
      expect(updated.id, plan.id);
      expect(updated.days, plan.days);
    });
  });

  group('ShoppingListItem', () {
    test('fromJson parses fields and copyWith flips checked without touching the rest', () {
      final item = ShoppingListItem.fromJson({
        '_id': 's1',
        'ingredientName': 'Rice',
        'amount': '1 cup',
        'checked': false,
      });
      expect(item.checked, isFalse);
      final checked = item.copyWith(checked: true);
      expect(checked.checked, isTrue);
      expect(checked.id, item.id);
      expect(checked.ingredientName, item.ingredientName);
    });
  });

  group('NutritionPreferences', () {
    test('fromJson/toJson round-trips every field', () {
      final json = {
        'dietaryPreferences': ['vegetarian'],
        'allergies': ['peanut'],
        'dislikedIngredients': ['mushroom'],
        'dailyCalorieTarget': 2000,
        'proteinTargetGrams': 140,
        'cookingTimePreference': 'quick',
        'weeklyFoodBudget': 50,
        'servings': 2,
        'nutritionPlanEnabled': true,
      };
      final prefs = NutritionPreferences.fromJson(json);
      expect(prefs.dietaryPreferences, ['vegetarian']);
      expect(prefs.allergies, ['peanut']);
      expect(prefs.cookingTimePreference, 'quick');
      expect(prefs.nutritionPlanEnabled, isTrue);

      final roundTripped = prefs.toJson();
      expect(roundTripped['dailyCalorieTarget'], 2000);
      expect(roundTripped['servings'], 2);
    });

    test('defaults are safe (no medical fields, sane fallbacks) for an empty document', () {
      final prefs = NutritionPreferences.fromJson({});
      expect(prefs.dietaryPreferences, isEmpty);
      expect(prefs.allergies, isEmpty);
      expect(prefs.dailyCalorieTarget, isNull);
      expect(prefs.cookingTimePreference, 'standard');
      expect(prefs.servings, 1);
      expect(prefs.nutritionPlanEnabled, isFalse);
    });
  });

  group('CalorieSuggestion', () {
    test('parses an estimate response', () {
      final suggestion = CalorieSuggestion.fromJson({'estimatedCalories': 2200, 'estimatedProteinGrams': 150});
      expect(suggestion.estimatedCalories, 2200);
      expect(suggestion.reasonCode, isNull);
    });

    test('parses an insufficient-data response with no numbers', () {
      final suggestion = CalorieSuggestion.fromJson({'reasonCode': 'insufficient_profile_data'});
      expect(suggestion.estimatedCalories, isNull);
      expect(suggestion.reasonCode, 'insufficient_profile_data');
    });
  });
}
