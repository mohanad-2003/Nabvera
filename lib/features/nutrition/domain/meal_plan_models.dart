import '../../../core/localization/generated/app_localizations.dart';

/// One meal slot inside a [MealPlanDay] — mirrors the backend's embedded
/// `MealPlanItem` subdocument (see `backend/src/models/MealPlanItem.js`).
/// `recipe*` fields are only present when the backend populated the
/// `recipe` ref; a [customName] item (no matching safe recipe) never has
/// them, so the UI must render a generic placeholder card for those.
class MealPlanItem {
  const MealPlanItem({
    required this.id,
    required this.mealType,
    this.recipeId,
    this.isCustom = false,
    this.customName,
    required this.servings,
    required this.calories,
    required this.proteinG,
    required this.carbsG,
    required this.fatG,
    required this.explanationCode,
    this.recipeTitle,
    this.recipeImageUrl,
    this.recipePrepTimeMinutes,
  });

  final String id;
  final String mealType; // breakfast | lunch | dinner | snack
  final String? recipeId;
  final bool isCustom;
  final String? customName;
  final int servings;
  final int calories;
  final int proteinG;
  final int carbsG;
  final int fatG;
  final String explanationCode;
  final String? recipeTitle;
  final String? recipeImageUrl;
  final int? recipePrepTimeMinutes;

  String get displayTitle => recipeTitle ?? customName ?? '';

  factory MealPlanItem.fromJson(Map<String, dynamic> json) {
    final recipe = json['recipe'];
    final recipeMap = recipe is Map<String, dynamic> ? recipe : null;
    return MealPlanItem(
      id: json['_id'] as String? ?? '',
      mealType: json['mealType'] as String? ?? 'snack',
      recipeId: recipeMap != null ? recipeMap['_id'] as String? : recipe as String?,
      isCustom: json['isCustom'] as bool? ?? false,
      customName: json['customName'] as String?,
      servings: (json['servings'] as num?)?.toInt() ?? 1,
      calories: (json['calories'] as num?)?.toInt() ?? 0,
      proteinG: (json['proteinG'] as num?)?.toInt() ?? 0,
      carbsG: (json['carbsG'] as num?)?.toInt() ?? 0,
      fatG: (json['fatG'] as num?)?.toInt() ?? 0,
      explanationCode: json['explanationCode'] as String? ?? '',
      recipeTitle: recipeMap != null ? recipeMap['title'] as String? : null,
      recipeImageUrl: recipeMap != null ? recipeMap['imageUrl'] as String? : null,
      recipePrepTimeMinutes: recipeMap != null ? (recipeMap['prepTimeMinutes'] as num?)?.toInt() : null,
    );
  }
}

/// One day of a [MealPlan] — `dayIndex` is week-relative (0..6), not a
/// fixed weekday, matching `backend/src/models/MealPlanDay.js`.
class MealPlanDay {
  const MealPlanDay({
    required this.dayIndex,
    required this.breakfast,
    required this.lunch,
    required this.dinner,
    required this.snacks,
    this.dayExplanationCode,
  });

  final int dayIndex;
  final List<MealPlanItem> breakfast;
  final List<MealPlanItem> lunch;
  final List<MealPlanItem> dinner;
  final List<MealPlanItem> snacks;
  final String? dayExplanationCode;

  List<MealPlanItem> get allItems => [...breakfast, ...lunch, ...dinner, ...snacks];

  int get totalCalories => allItems.fold(0, (sum, item) => sum + item.calories);
  int get totalProteinG => allItems.fold(0, (sum, item) => sum + item.proteinG);

  factory MealPlanDay.fromJson(Map<String, dynamic> json) {
    final meals = json['meals'] as Map<String, dynamic>? ?? const {};
    List<MealPlanItem> slot(String key) => (meals[key] as List? ?? const [])
        .cast<Map<String, dynamic>>()
        .map(MealPlanItem.fromJson)
        .toList();
    return MealPlanDay(
      dayIndex: (json['dayIndex'] as num?)?.toInt() ?? 0,
      breakfast: slot('breakfast'),
      lunch: slot('lunch'),
      dinner: slot('dinner'),
      snacks: slot('snacks'),
      dayExplanationCode: json['dayExplanationCode'] as String?,
    );
  }
}

class ShoppingListItem {
  const ShoppingListItem({
    required this.id,
    required this.ingredientName,
    required this.amount,
    required this.checked,
  });

  final String id;
  final String ingredientName;
  final String amount;
  final bool checked;

  ShoppingListItem copyWith({bool? checked}) => ShoppingListItem(
    id: id,
    ingredientName: ingredientName,
    amount: amount,
    checked: checked ?? this.checked,
  );

  factory ShoppingListItem.fromJson(Map<String, dynamic> json) => ShoppingListItem(
    id: json['_id'] as String? ?? '',
    ingredientName: json['ingredientName'] as String? ?? '',
    amount: json['amount'] as String? ?? '',
    checked: json['checked'] as bool? ?? false,
  );
}

/// A user's AI-assisted (or rule-based fallback) 7-day meal plan — mirrors
/// `backend/src/models/MealPlan.js`. `generationSource` and `disclaimerCode` exist
/// specifically so the UI never presents this as medical/therapeutic
/// advice — see [mealPlanDisclaimer].
class MealPlan {
  const MealPlan({
    required this.id,
    required this.isActive,
    required this.weekStartDate,
    required this.goal,
    required this.calorieTarget,
    required this.proteinTargetGrams,
    required this.servings,
    required this.cookingTimePreference,
    required this.generationSource,
    required this.days,
    required this.shoppingList,
    required this.disclaimerCode,
  });

  final String id;
  final bool isActive;
  final DateTime weekStartDate;
  final String goal;
  final int calorieTarget;
  final int proteinTargetGrams;
  final int servings;
  final String cookingTimePreference;
  final String generationSource; // 'ai' | 'fallback'
  final List<MealPlanDay> days;
  final List<ShoppingListItem> shoppingList;
  final String disclaimerCode;

  MealPlan copyWith({List<MealPlanDay>? days, List<ShoppingListItem>? shoppingList}) => MealPlan(
    id: id,
    isActive: isActive,
    weekStartDate: weekStartDate,
    goal: goal,
    calorieTarget: calorieTarget,
    proteinTargetGrams: proteinTargetGrams,
    servings: servings,
    cookingTimePreference: cookingTimePreference,
    generationSource: generationSource,
    days: days ?? this.days,
    shoppingList: shoppingList ?? this.shoppingList,
    disclaimerCode: disclaimerCode,
  );

  factory MealPlan.fromJson(Map<String, dynamic> json) => MealPlan(
    id: json['_id'] as String? ?? '',
    isActive: json['isActive'] as bool? ?? true,
    weekStartDate: DateTime.tryParse(json['weekStartDate'] as String? ?? '') ?? DateTime.now(),
    goal: json['goal'] as String? ?? 'keep_fit',
    calorieTarget: (json['calorieTarget'] as num?)?.toInt() ?? 0,
    proteinTargetGrams: (json['proteinTargetGrams'] as num?)?.toInt() ?? 0,
    servings: (json['servings'] as num?)?.toInt() ?? 1,
    cookingTimePreference: json['cookingTimePreference'] as String? ?? 'standard',
    generationSource: json['generationSource'] as String? ?? 'ai',
    days: (json['days'] as List? ?? const [])
        .cast<Map<String, dynamic>>()
        .map(MealPlanDay.fromJson)
        .toList(),
    shoppingList: (json['shoppingList'] as List? ?? const [])
        .cast<Map<String, dynamic>>()
        .map(ShoppingListItem.fromJson)
        .toList(),
    disclaimerCode: json['disclaimerCode'] as String? ?? 'general_nutrition_disclaimer',
  );
}

/// Localizes a meal/day `explanationCode` — the backend only ever sends a
/// fixed code (see `backend/src/utils/mealPlanCodes.js`), never free text,
/// specifically so this mapping is the single place that decides the
/// user-facing wording (and can be translated).
String explanationCodeLabel(AppLocalizations l10n, String code) => switch (code) {
  'matches_calorie_target' => l10n.mealPlanReasonMatchesCalorieTarget,
  'matches_protein_target' => l10n.mealPlanReasonMatchesProteinTarget,
  'quick_to_cook' => l10n.mealPlanReasonQuickToCook,
  'fits_dietary_preference' => l10n.mealPlanReasonFitsDietaryPreference,
  'budget_friendly' => l10n.mealPlanReasonBudgetFriendly,
  'variety_boost' => l10n.mealPlanReasonVarietyBoost,
  'uses_favorite_ingredients' => l10n.mealPlanReasonUsesFavoriteIngredients,
  'allergy_safe_substitution' => l10n.mealPlanReasonAllergySafeSubstitution,
  'fallback_default_meal' => l10n.mealPlanReasonFallbackDefaultMeal,
  'recipe_unavailable_placeholder' => l10n.mealPlanReasonRecipeUnavailablePlaceholder,
  'balanced_across_targets' => l10n.mealPlanReasonBalancedAcrossTargets,
  'higher_protein_day' => l10n.mealPlanReasonHigherProteinDay,
  'lighter_calorie_day' => l10n.mealPlanReasonLighterCalorieDay,
  'fallback_rule_based_plan' => l10n.mealPlanReasonFallbackRuleBasedPlan,
  _ => '',
};

/// The mandatory disclaimer shown alongside every plan (see the Phase 6
/// brief's explicit "not a substitute for a nutrition professional"
/// requirement) — always sourced from this fixed code, never AI text.
String mealPlanDisclaimer(AppLocalizations l10n, String code) => switch (code) {
  _ => l10n.mealPlanDisclaimer,
};
