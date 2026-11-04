import 'package:flutter/widgets.dart' show BuildContext, Localizations;

import '../../../core/localization/generated/app_localizations.dart';

/// Replaces the `Map<String, dynamic>` meal entries used throughout the
/// legacy nutrition/meal-idea controllers.
class MealItem {
  const MealItem({
    this.id = '',
    required this.image,
    required this.name,
    required this.time,
    required this.calories,
    this.subtitle = '',
    this.protein,
    this.carbs,
    this.fat,
    this.proteinGrams,
    this.rating,
    this.difficulty,
    this.prepTimeMinutes,
    this.caloriesValue,
    this.nameAr = '',
    this.subtitleAr = '',
  });

  /// Backend `Recipe._id` — used to fetch the full detail on tap and to
  /// key the favorite toggle.
  final String id;
  final String image;
  final String name;
  final String time;
  final String calories;

  /// Short one-line description shown under the name on grid cards, so no
  /// card ever renders as a bare photo without context.
  final String subtitle;

  /// Arabic translations, from `Recipe.titleAr`/`descriptionAr` — empty for
  /// a recipe an admin hasn't translated yet, in which case
  /// [localizedName]/[localizedSubtitle] fall back to [name]/[subtitle]
  /// (same pattern as `ArticleTip.localizedTitle`).
  final String nameAr;
  final String subtitleAr;

  String localizedName(BuildContext context) =>
      Localizations.localeOf(context).languageCode == 'ar' && nameAr.isNotEmpty
          ? nameAr
          : name;

  String localizedSubtitle(BuildContext context) =>
      Localizations.localeOf(context).languageCode == 'ar' &&
              subtitleAr.isNotEmpty
          ? subtitleAr
          : subtitle;

  /// Optional macro/quality metadata for the premium recipe card. Null when
  /// not supplied by a given mock source — cards render gracefully without
  /// these chips rather than showing fabricated numbers.
  final String? protein;
  final String? carbs;
  final String? fat;

  /// Raw `Recipe.nutrition.proteinG` — lets cards format the amount for the
  /// current locale instead of showing the English-only [protein] string.
  /// Null when the recipe has no protein value (never shown as 0).
  final double? proteinGrams;
  final double? rating;

  /// Raw backend value (`easy`/`medium`/`hard`) — the widget layer maps
  /// this to a localized label instead of showing it verbatim, unlike
  /// [time]/[calories] which are pre-formatted (English-only) fallbacks
  /// for call sites that haven't been updated to use [prepTimeMinutes]/
  /// [caloriesValue] with `AppLocalizations` yet.
  final String? difficulty;
  final int? prepTimeMinutes;
  final int? caloriesValue;

  /// Builds a grid-card item from a `/api/recipes` JSON document.
  factory MealItem.fromJson(Map<String, dynamic> json) {
    final nutrition = json['nutrition'] as Map<String, dynamic>? ?? const {};
    final minutes = (json['prepTimeMinutes'] as num?)?.toInt();
    final calories = (nutrition['calories'] as num?)?.toInt();
    return MealItem(
      id: json['_id'] as String? ?? '',
      image: (json['imageUrl'] as String?) ?? 'assets/workout.png',
      name: (json['title'] as String?) ?? '',
      nameAr: (json['titleAr'] as String?) ?? '',
      subtitle: (json['description'] as String?) ?? '',
      subtitleAr: (json['descriptionAr'] as String?) ?? '',
      time: '${minutes ?? '—'} Minutes',
      calories: '${calories ?? '—'} Cal',
      prepTimeMinutes: minutes,
      caloriesValue: calories,
      protein:
          nutrition['proteinG'] == null ? null : '${nutrition['proteinG']}g',
      carbs: nutrition['carbsG'] == null ? null : '${nutrition['carbsG']}g',
      fat: nutrition['fatG'] == null ? null : '${nutrition['fatG']}g',
      proteinGrams: (nutrition['proteinG'] as num?)?.toDouble(),
      rating: (json['rating'] as num?)?.toDouble(),
      difficulty: json['difficulty'] as String?,
    );
  }
}

class MealDetail {
  const MealDetail({
    required this.image,
    required this.name,
    required this.time,
    required this.calories,
    this.ingredients = const [],
    this.preparation = const [],
    this.favoriteKey,
    this.protein,
    this.carbs,
    this.fat,
    this.proteinGrams,
    this.rating,
    this.difficulty,
    this.servings,
    this.tips = const [],
    this.benefits = const [],
    this.prepTimeMinutes,
    this.caloriesValue,
    this.similarRecipes = const [],
    this.category,
    this.nameAr = '',
    this.ingredientsAr = const [],
    this.preparationAr = const [],
    this.tipsAr = const [],
    this.benefitsAr = const [],
  });

  final String image;
  final String name;
  final String time;
  final String calories;
  final List<String> ingredients;
  final List<String> preparation;

  /// Arabic translations, from `Recipe.titleAr`/`ingredientsAr`/`stepsAr`/
  /// `tipsAr`/`benefitsAr` — same fallback contract as `MealItem.nameAr`:
  /// empty means "not translated yet", so the `localized*` getters below
  /// fall back to the English list rather than showing nothing.
  final String nameAr;
  final List<String> ingredientsAr;
  final List<String> preparationAr;
  final List<String> tipsAr;
  final List<String> benefitsAr;

  String localizedName(BuildContext context) =>
      Localizations.localeOf(context).languageCode == 'ar' && nameAr.isNotEmpty
          ? nameAr
          : name;

  List<String> localizedIngredients(BuildContext context) =>
      Localizations.localeOf(context).languageCode == 'ar' && ingredientsAr.isNotEmpty
          ? ingredientsAr
          : ingredients;

  List<String> localizedPreparation(BuildContext context) =>
      Localizations.localeOf(context).languageCode == 'ar' && preparationAr.isNotEmpty
          ? preparationAr
          : preparation;

  List<String> localizedTips(BuildContext context) =>
      Localizations.localeOf(context).languageCode == 'ar' && tipsAr.isNotEmpty
          ? tipsAr
          : tips;

  List<String> localizedBenefits(BuildContext context) =>
      Localizations.localeOf(context).languageCode == 'ar' && benefitsAr.isNotEmpty
          ? benefitsAr
          : benefits;

  /// Identity used to look up/toggle favorite state; null when the detail
  /// page is opened for a screen that doesn't track favorites.
  final String? favoriteKey;

  /// Optional recipe-detail metadata — same "render only if present"
  /// contract as [MealItem].
  final String? protein;
  final String? carbs;
  final String? fat;

  /// See [MealItem.proteinGrams].
  final double? proteinGrams;
  final double? rating;

  /// See the doc comment on [MealItem.difficulty] — same raw-value contract.
  final String? difficulty;
  final String? servings;
  final List<String> tips;
  final List<String> benefits;
  final int? prepTimeMinutes;
  final int? caloriesValue;

  /// Other recipes in the same category — from the backend's
  /// `getRecipeById`, which computes this specifically for the recipe
  /// being viewed (not a generic "recommended" list shared by every recipe).
  final List<MealItem> similarRecipes;

  /// Recipe.category ('breakfast'/'lunch'/'dinner'/'snack'/'drink') — used
  /// only to default the mealType when logging this recipe as eaten from
  /// Meal Ideas (see meal_detail_page.dart); never shown as diagnostic or
  /// medical information.
  final String? category;

  /// Builds a detail-page model from a `/api/recipes/:id` (or list) JSON
  /// document. `favoriteKey` is the recipe's `_id`, matched against
  /// `UserProfile.favoriteRecipeIds`.
  factory MealDetail.fromJson(Map<String, dynamic> json) {
    final nutrition = json['nutrition'] as Map<String, dynamic>? ?? const {};
    final ingredients =
        (json['ingredients'] as List? ?? const []).cast<Map<String, dynamic>>();
    final ingredientsAr =
        (json['ingredientsAr'] as List? ?? const []).cast<Map<String, dynamic>>();
    // .toList() first: `?? const []` returns an unmodifiable list when
    // `steps` is missing entirely (a recipe with no steps yet), and
    // `..sort()` on that throws — this is the fix, not new behavior.
    final steps =
        (json['steps'] as List? ?? const []).cast<Map<String, dynamic>>().toList()..sort(
          (a, b) =>
              ((a['order'] as num?) ?? 0).compareTo((b['order'] as num?) ?? 0),
        );
    final stepsAr =
        (json['stepsAr'] as List? ?? const []).cast<Map<String, dynamic>>().toList()..sort(
          (a, b) =>
              ((a['order'] as num?) ?? 0).compareTo((b['order'] as num?) ?? 0),
        );
    final minutes = (json['prepTimeMinutes'] as num?)?.toInt();
    final calories = (nutrition['calories'] as num?)?.toInt();

    return MealDetail(
      image: (json['imageUrl'] as String?) ?? 'assets/workout.png',
      name: (json['title'] as String?) ?? '',
      nameAr: (json['titleAr'] as String?) ?? '',
      time: '${minutes ?? '—'} Minutes',
      calories: '${calories ?? '—'} Cal',
      prepTimeMinutes: minutes,
      caloriesValue: calories,
      ingredients: [
        for (final i in ingredients)
          '${i['amount'] ?? ''} ${i['name'] ?? ''}'.trim(),
      ],
      ingredientsAr: [
        for (final i in ingredientsAr)
          '${i['amount'] ?? ''} ${i['name'] ?? ''}'.trim(),
      ],
      preparation: [for (final s in steps) (s['instruction'] as String?) ?? ''],
      preparationAr: [for (final s in stepsAr) (s['instruction'] as String?) ?? ''],
      tipsAr: (json['tipsAr'] as List? ?? const []).cast<String>(),
      benefitsAr: (json['benefitsAr'] as List? ?? const []).cast<String>(),
      favoriteKey: json['_id'] as String?,
      protein:
          nutrition['proteinG'] == null ? null : '${nutrition['proteinG']}g',
      carbs: nutrition['carbsG'] == null ? null : '${nutrition['carbsG']}g',
      fat: nutrition['fatG'] == null ? null : '${nutrition['fatG']}g',
      proteinGrams: (nutrition['proteinG'] as num?)?.toDouble(),
      rating: (json['rating'] as num?)?.toDouble(),
      difficulty: json['difficulty'] as String?,
      tips: (json['tips'] as List? ?? const []).cast<String>(),
      benefits: (json['benefits'] as List? ?? const []).cast<String>(),
      similarRecipes: [
        for (final r in (json['similarRecipes'] as List? ?? const []))
          MealItem.fromJson(r as Map<String, dynamic>),
      ],
      category: json['category'] as String?,
    );
  }

  /// Maps [category] to a valid `DailyNutrition` mealType, falling back to
  /// 'snack' for anything not in {breakfast, lunch, dinner, snack} (e.g.
  /// Recipe's 'drink' category, or no category at all).
  String get defaultMealType =>
      const {'breakfast', 'lunch', 'dinner', 'snack'}.contains(category) ? category! : 'snack';

  static const empty = MealDetail(
    image: 'assets/workout.png',
    name: 'No recipes yet',
    time: '—',
    calories: '—',
  );
}

enum MealCategory { breakfast, lunch, dinner }

/// One macro's intake for the day, in grams. [consumed]/[goal] stay null when
/// the API didn't send them — a missing value is "not available", never a
/// real 0, so the UI can tell the two apart.
class MacroIntake {
  const MacroIntake({this.consumed, this.goal});

  final double? consumed;
  final double? goal;

  bool get hasGoal => goal != null && goal! > 0;

  /// 0..1 progress for a progress bar only — [consumed] itself is never
  /// clamped. Null when either side is missing or the goal is 0.
  double? get progress =>
      hasGoal && consumed != null ? (consumed! / goal!).clamp(0.0, 1.0) : null;
}

/// At-a-glance daily nutrition snapshot shown at the top of the Nutrition
/// home tab — a real `/api/nutrition/today` document, mapped via
/// [fromEntry]. [goalSource] and [isLoading] exist specifically so the UI
/// never presents a guessed/placeholder goal as the user's own (see
/// [goalSource]'s doc comment) and never shows numbers before they've
/// actually loaded.
class DailyNutritionSummary {
  const DailyNutritionSummary({
    required this.consumedCalories,
    required this.goalCalories,
    required this.proteinFraction,
    required this.carbsFraction,
    required this.fatFraction,
    required this.waterIntake,
    this.waterCupsConsumed = 0,
    this.waterCupsGoal = 0,
    this.goalSource = 'fallback',
    this.isLoading = false,
    this.proteinConsumedG,
    this.proteinGoalG,
    this.carbsConsumedG,
    this.carbsGoalG,
    this.fatConsumedG,
    this.fatGoalG,
    this.waterConsumedMl,
    this.waterGoalMl,
    this.loadFailed = false,
  });

  final int consumedCalories;

  /// 0 only when the API explicitly sent a 0 goal — see [hasCalorieGoal].
  final int goalCalories;

  /// 0..1 progress toward the daily goal for each macro (0 when the goal is
  /// missing). Kept for existing call sites; the Nutrition page reads the
  /// raw grams below instead.
  final double proteinFraction;
  final double carbsFraction;
  final double fatFraction;

  /// Raw grams from `/api/nutrition/today` (`proteinConsumedG`/
  /// `proteinGoalG`, ...). Null when the API omitted them — never derived
  /// from the clamped fractions above.
  final double? proteinConsumedG;
  final double? proteinGoalG;
  final double? carbsConsumedG;
  final double? carbsGoalG;
  final double? fatConsumedG;
  final double? fatGoalG;

  MacroIntake get protein =>
      MacroIntake(consumed: proteinConsumedG, goal: proteinGoalG);
  MacroIntake get carbs =>
      MacroIntake(consumed: carbsConsumedG, goal: carbsGoalG);
  MacroIntake get fat => MacroIntake(consumed: fatConsumedG, goal: fatGoalG);

  /// English-formatted fallback (e.g. "5 / 8 cups"), used only where
  /// [waterCupsConsumed]/[waterCupsGoal] aren't available. Prefer
  /// [localizedWaterIntake] for display — see `WorkoutListItem` for why a
  /// raw number-plus-English-word string breaks under Arabic/RTL.
  final String waterIntake;
  final int waterCupsConsumed;
  final int waterCupsGoal;

  /// Raw millilitres from the API (`waterConsumedMl`/`waterGoalMl`). Null
  /// when omitted; the rounded cup counts above are display-only and must
  /// not be turned back into an "exact" amount.
  final num? waterConsumedMl;
  final num? waterGoalMl;

  /// Water progress formatted for [context]'s current locale.
  String localizedWaterIntake(BuildContext context) =>
      AppLocalizations.of(context).waterCupsProgress(waterCupsConsumed, waterCupsGoal);

  /// 0..1 water progress for a progress bar, from the raw ml values only.
  double? get waterProgress {
    final consumed = waterConsumedMl;
    final goal = waterGoalMl;
    if (consumed == null || goal == null || goal <= 0) return null;
    return (consumed / goal).clamp(0.0, 1.0).toDouble();
  }

  /// 'preferences' when [goalCalories] is the user's own manually-set
  /// target, 'estimate' when it's the rule-based suggestion, 'fallback'
  /// when it's a fixed placeholder because neither was available — see
  /// `backend/src/services/nutritionCalculatorService.resolveDailyGoals`.
  /// Anything other than 'preferences' should read as "not personalized
  /// yet", never as the user's real goal.
  final String goalSource;

  /// True only for the initial placeholder shown before the first real
  /// load completes — lets the summary card show a genuine loading state
  /// instead of a misleading fixed number.
  final bool isLoading;

  /// True when the first load failed, so there is no real data to show —
  /// the card shows a retry state instead of zeros that would read as
  /// "you ate nothing today". A failed *refresh* keeps the last good data
  /// and leaves this false.
  final bool loadFailed;

  bool get hasPersonalGoal => goalSource == 'preferences';

  bool get hasCalorieGoal => goalCalories > 0;

  bool get isOverCalorieGoal => hasCalorieGoal && consumedCalories > goalCalories;

  /// Calories above the goal; 0 when at/under it or when there is no goal.
  int get caloriesOverGoal =>
      isOverCalorieGoal ? consumedCalories - goalCalories : 0;

  /// Calories left today, floored at 0 (an overshoot is reported through
  /// [caloriesOverGoal] instead of a negative remainder). Null without a goal.
  int? get caloriesRemaining {
    if (!hasCalorieGoal) return null;
    return isOverCalorieGoal ? 0 : goalCalories - consumedCalories;
  }

  /// 0..1 calorie progress for a progress bar only; null without a goal.
  /// [consumedCalories] itself is never clamped.
  double? get calorieProgress =>
      hasCalorieGoal
          ? (consumedCalories / goalCalories).clamp(0.0, 1.0).toDouble()
          : null;

  DailyNutritionSummary copyWith({
    bool? isLoading,
    bool? loadFailed,
    double? proteinConsumedG,
    double? proteinGoalG,
    double? carbsConsumedG,
    double? carbsGoalG,
    double? fatConsumedG,
    double? fatGoalG,
    num? waterConsumedMl,
    num? waterGoalMl,
  }) => DailyNutritionSummary(
    consumedCalories: consumedCalories,
    goalCalories: goalCalories,
    proteinFraction: proteinFraction,
    carbsFraction: carbsFraction,
    fatFraction: fatFraction,
    waterIntake: waterIntake,
    waterCupsConsumed: waterCupsConsumed,
    waterCupsGoal: waterCupsGoal,
    goalSource: goalSource,
    isLoading: isLoading ?? this.isLoading,
    loadFailed: loadFailed ?? this.loadFailed,
    proteinConsumedG: proteinConsumedG ?? this.proteinConsumedG,
    proteinGoalG: proteinGoalG ?? this.proteinGoalG,
    carbsConsumedG: carbsConsumedG ?? this.carbsConsumedG,
    carbsGoalG: carbsGoalG ?? this.carbsGoalG,
    fatConsumedG: fatConsumedG ?? this.fatConsumedG,
    fatGoalG: fatGoalG ?? this.fatGoalG,
    waterConsumedMl: waterConsumedMl ?? this.waterConsumedMl,
    waterGoalMl: waterGoalMl ?? this.waterGoalMl,
  );

  /// Builds a summary from a `/api/nutrition/today`-shaped document —
  /// shared by the initial load and by `logWater`/`logMeal`'s response,
  /// so a successful log updates every field (not just the one that
  /// changed) from exactly the same document the backend just persisted.
  factory DailyNutritionSummary.fromEntry(Map<String, dynamic> entry) {
    final calorieGoal = (entry['calorieGoal'] as num?) ?? 2000;
    final proteinConsumed = (entry['proteinConsumedG'] as num?)?.toDouble();
    final proteinGoal = (entry['proteinGoalG'] as num?)?.toDouble();
    final carbsConsumed = (entry['carbsConsumedG'] as num?)?.toDouble();
    final carbsGoal = (entry['carbsGoalG'] as num?)?.toDouble();
    final fatConsumed = (entry['fatConsumedG'] as num?)?.toDouble();
    final fatGoal = (entry['fatGoalG'] as num?)?.toDouble();
    final waterGoalMl = entry['waterGoalMl'] as num?;
    final waterConsumedMl = entry['waterConsumedMl'] as num?;
    // ~250ml per "cup", matching the UI's original "X / 8 cups" copy.
    const mlPerCup = 250;
    final waterCupsConsumed = ((waterConsumedMl ?? 0) / mlPerCup).round();
    final waterCupsGoal = ((waterGoalMl ?? 2000) / mlPerCup).round();

    return DailyNutritionSummary(
      consumedCalories: ((entry['caloriesConsumed'] as num?) ?? 0).round(),
      goalCalories: calorieGoal.round(),
      proteinFraction:
          MacroIntake(consumed: proteinConsumed, goal: proteinGoal).progress ?? 0,
      carbsFraction:
          MacroIntake(consumed: carbsConsumed, goal: carbsGoal).progress ?? 0,
      fatFraction: MacroIntake(consumed: fatConsumed, goal: fatGoal).progress ?? 0,
      proteinConsumedG: proteinConsumed,
      proteinGoalG: proteinGoal,
      carbsConsumedG: carbsConsumed,
      carbsGoalG: carbsGoal,
      fatConsumedG: fatConsumed,
      fatGoalG: fatGoal,
      waterIntake: '$waterCupsConsumed / $waterCupsGoal cups',
      waterCupsConsumed: waterCupsConsumed,
      waterCupsGoal: waterCupsGoal,
      waterConsumedMl: waterConsumedMl,
      waterGoalMl: waterGoalMl,
      goalSource: entry['goalSource'] as String? ?? 'fallback',
    );
  }
}

class MealIdeaSection {
  const MealIdeaSection({
    required this.top,
    required this.recommended,
    required this.recipes,
  });

  final MealDetail top;
  final List<MealDetail> recommended;
  final List<MealDetail> recipes;
}

class BreakfastOption {
  const BreakfastOption({
    required this.name,
    required this.time,
    required this.calories,
    required this.image,
    required this.ingredients,
    required this.preparation,
    this.isFavorite = false,
  });

  final String name;
  final String time;
  final String calories;
  final String image;
  final List<String> ingredients;
  final List<String> preparation;
  final bool isFavorite;

  BreakfastOption copyWith({bool? isFavorite}) => BreakfastOption(
    name: name,
    time: time,
    calories: calories,
    image: image,
    ingredients: ingredients,
    preparation: preparation,
    isFavorite: isFavorite ?? this.isFavorite,
  );

  MealDetail toDetail() => MealDetail(
    image: image,
    name: name,
    time: time,
    calories: calories,
    ingredients: ingredients,
    preparation: preparation,
  );
}

/// Maps the backend's raw `Recipe.difficulty` (`easy`/`medium`/`hard`) to a
/// localized label — shared by every widget that renders a recipe's
/// difficulty chip.
String recipeDifficultyLabel(AppLocalizations l10n, String? difficulty) =>
    switch (difficulty) {
      'medium' => l10n.nutritionDifficultyMedium,
      'hard' => l10n.nutritionDifficultyHard,
      _ => l10n.nutritionDifficultyEasy,
    };

/// Localized "{n} Minutes" — falls back to the pre-formatted (English-only)
/// [fallback] when the raw value wasn't available (e.g. from an older
/// cached model that only has the formatted string).
String recipeMinutesLabel(
  AppLocalizations l10n,
  int? minutes,
  String fallback,
) => minutes == null ? fallback : l10n.nutritionMinutesValue(minutes);

/// Localized "{n} Cal" — same fallback contract as [recipeMinutesLabel].
String recipeCaloriesLabel(
  AppLocalizations l10n,
  int? calories,
  String fallback,
) => calories == null ? fallback : l10n.nutritionCaloriesValue(calories);
