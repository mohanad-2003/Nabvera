import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../data/nutrition_repository.dart';

part 'meal_plan_wizard_controller.g.dart';

class MealPlanPreferences {
  const MealPlanPreferences({
    this.dietaryPreference = 'No preferences',
    this.allergy = 'No allergies',
    this.mealType = 'Breakfast',
    this.caloricGoal = "Not sure/Don't have agoal",
    this.cookingTime = 'Less than 15 minutes',
    this.servings = '1',
  });

  final String dietaryPreference;
  final String allergy;
  final String mealType;
  final String caloricGoal;
  final String cookingTime;
  final String servings;

  MealPlanPreferences copyWith({
    String? dietaryPreference,
    String? allergy,
    String? mealType,
    String? caloricGoal,
    String? cookingTime,
    String? servings,
  }) {
    return MealPlanPreferences(
      dietaryPreference: dietaryPreference ?? this.dietaryPreference,
      allergy: allergy ?? this.allergy,
      mealType: mealType ?? this.mealType,
      caloricGoal: caloricGoal ?? this.caloricGoal,
      cookingTime: cookingTime ?? this.cookingTime,
      servings: servings ?? this.servings,
    );
  }
}

/// Single wizard state replacing MealPlaneController + MealPlan2Conroller,
/// which only ever held one selected value each across two consecutive
/// screens of the same flow.
@riverpod
class MealPlanWizardController extends _$MealPlanWizardController {
  static const dietaryOptions = [
    'Vegetarian',
    'Vegan',
    'Gluten-Free',
    'Keto',
    'Paleo',
    'No preferences',
  ];
  static const allergyOptions = [
    'Nuts',
    'Eggs',
    'Dairy',
    'No allergies',
    'Shellfish',
  ];
  static const mealTypeOptions = ['Breakfast', 'Dinner', 'Lunch', 'Snacks'];
  static const caloricGoalOptions = [
    'Less than 1500 calories',
    '1500-2000 calories',
    'More than 2000 calories',
    "Not sure/Don't have agoal",
  ];
  static const cookingTimeOptions = [
    'Less than 15 minutes',
    '15-30 minutes',
    'More than 30 minutes',
  ];
  static const servingOptions = ['1', '3-4', '2', 'More than 4'];

  @override
  MealPlanPreferences build() => const MealPlanPreferences();

  void selectDietaryPreference(String value) =>
      state = state.copyWith(dietaryPreference: value);
  void selectAllergy(String value) => state = state.copyWith(allergy: value);
  void selectMealType(String value) => state = state.copyWith(mealType: value);
  void selectCaloricGoal(String value) =>
      state = state.copyWith(caloricGoal: value);
  void selectCookingTime(String value) =>
      state = state.copyWith(cookingTime: value);
  void selectServings(String value) => state = state.copyWith(servings: value);

  /// Submits the wizard's answers to `POST /api/meal-plans`. Best effort —
  /// the generating screen still proceeds to the breakfast step even if
  /// this fails, since there's no error UI in that flow to surface it.
  Future<void> submit() async {
    final payload = <String, dynamic>{
      'dietaryPreference': _dietaryPreferenceToApi(state.dietaryPreference),
      'dailyCalorieTarget': _caloricGoalToTarget(state.caloricGoal),
    };
    try {
      await ref.read(nutritionRepositoryProvider).createMealPlan(payload);
    } catch (_) {
      // See doc comment.
    }
  }

  static String _dietaryPreferenceToApi(String value) => switch (value) {
    'Vegetarian' => 'vegetarian',
    'Vegan' => 'vegan',
    'Gluten-Free' => 'gluten_free',
    'Keto' => 'keto',
    'Paleo' => 'paleo',
    _ => 'none',
  };

  /// The wizard collects a calorie *range* label, not a single number — the
  /// backend wants one target, so this picks the range's midpoint.
  static int _caloricGoalToTarget(String value) => switch (value) {
    'Less than 1500 calories' => 1400,
    '1500-2000 calories' => 1750,
    'More than 2000 calories' => 2300,
    _ => 2000,
  };
}
