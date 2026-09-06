/// The user's food/logistics nutrition preferences — mirrors
/// `User.nutritionPreferences` in the backend (see
/// `backend/src/models/User.js`). Deliberately holds no medical or
/// diagnostic data, only dietary restrictions, allergies (matched against
/// recipe ingredients, not a medical record), and planning logistics.
class NutritionPreferences {
  const NutritionPreferences({
    this.dietaryPreferences = const [],
    this.allergies = const [],
    this.dislikedIngredients = const [],
    this.dailyCalorieTarget,
    this.proteinTargetGrams,
    this.cookingTimePreference = 'standard',
    this.weeklyFoodBudget,
    this.servings = 1,
    this.nutritionPlanEnabled = false,
  });

  final List<String> dietaryPreferences;
  final List<String> allergies;
  final List<String> dislikedIngredients;
  final int? dailyCalorieTarget;
  final int? proteinTargetGrams;
  final String cookingTimePreference; // quick | standard | flexible
  final num? weeklyFoodBudget;
  final int servings;
  final bool nutritionPlanEnabled;

  static const dietaryOptions = ['vegetarian', 'vegan', 'halal', 'gluten_free', 'lactose_free'];
  static const cookingTimeOptions = ['quick', 'standard', 'flexible'];

  NutritionPreferences copyWith({
    List<String>? dietaryPreferences,
    List<String>? allergies,
    List<String>? dislikedIngredients,
    int? dailyCalorieTarget,
    int? proteinTargetGrams,
    String? cookingTimePreference,
    num? weeklyFoodBudget,
    int? servings,
    bool? nutritionPlanEnabled,
  }) {
    return NutritionPreferences(
      dietaryPreferences: dietaryPreferences ?? this.dietaryPreferences,
      allergies: allergies ?? this.allergies,
      dislikedIngredients: dislikedIngredients ?? this.dislikedIngredients,
      dailyCalorieTarget: dailyCalorieTarget ?? this.dailyCalorieTarget,
      proteinTargetGrams: proteinTargetGrams ?? this.proteinTargetGrams,
      cookingTimePreference: cookingTimePreference ?? this.cookingTimePreference,
      weeklyFoodBudget: weeklyFoodBudget ?? this.weeklyFoodBudget,
      servings: servings ?? this.servings,
      nutritionPlanEnabled: nutritionPlanEnabled ?? this.nutritionPlanEnabled,
    );
  }

  factory NutritionPreferences.fromJson(Map<String, dynamic> json) => NutritionPreferences(
    dietaryPreferences: (json['dietaryPreferences'] as List? ?? const []).cast<String>(),
    allergies: (json['allergies'] as List? ?? const []).cast<String>(),
    dislikedIngredients: (json['dislikedIngredients'] as List? ?? const []).cast<String>(),
    dailyCalorieTarget: (json['dailyCalorieTarget'] as num?)?.toInt(),
    proteinTargetGrams: (json['proteinTargetGrams'] as num?)?.toInt(),
    cookingTimePreference: json['cookingTimePreference'] as String? ?? 'standard',
    weeklyFoodBudget: json['weeklyFoodBudget'] as num?,
    servings: (json['servings'] as num?)?.toInt() ?? 1,
    nutritionPlanEnabled: json['nutritionPlanEnabled'] as bool? ?? false,
  );

  Map<String, dynamic> toJson() => {
    'dietaryPreferences': dietaryPreferences,
    'allergies': allergies,
    'dislikedIngredients': dislikedIngredients,
    'dailyCalorieTarget': dailyCalorieTarget,
    'proteinTargetGrams': proteinTargetGrams,
    'cookingTimePreference': cookingTimePreference,
    'weeklyFoodBudget': weeklyFoodBudget,
    'servings': servings,
    'nutritionPlanEnabled': nutritionPlanEnabled,
  };
}

/// Rule-based calorie/protein suggestion from `GET
/// /nutrition/calorie-targets/suggestion` — never AI-computed, and always
/// carries either an estimate + disclaimer or a reasonCode explaining why
/// one couldn't be produced (see the backend's
/// `nutritionCalculatorService.js`).
class CalorieSuggestion {
  const CalorieSuggestion({this.estimatedCalories, this.estimatedProteinGrams, this.reasonCode});

  final int? estimatedCalories;
  final int? estimatedProteinGrams;
  final String? reasonCode;

  factory CalorieSuggestion.fromJson(Map<String, dynamic> json) => CalorieSuggestion(
    estimatedCalories: (json['estimatedCalories'] as num?)?.toInt(),
    estimatedProteinGrams: (json['estimatedProteinGrams'] as num?)?.toInt(),
    reasonCode: json['reasonCode'] as String?,
  );
}
