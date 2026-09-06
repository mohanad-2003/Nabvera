import 'package:nabvera/core/localization/generated/app_localizations.dart';
import 'package:nabvera/core/theme/app_theme_extension.dart';
import 'package:nabvera/core/widgets/premium_scaffold.dart';
import 'package:nabvera/core/widgets/primary_button.dart';
import 'package:nabvera/features/nutrition/domain/nutrition_preferences.dart';
import 'package:nabvera/features/nutrition/presentation/providers/nutrition_preferences_controller.dart';
import 'package:nabvera/features/nutrition/presentation/widgets/option_selector.dart';
import 'package:nabvera/features/workout/presentation/widgets/workout_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

String _dietLabel(AppLocalizations l10n, String value) => switch (value) {
  'vegetarian' => l10n.mealPlanDietVegetarian,
  'vegan' => l10n.mealPlanDietVegan,
  'halal' => l10n.mealPlanDietHalal,
  'gluten_free' => l10n.mealPlanDietGlutenFree,
  'lactose_free' => l10n.mealPlanDietLactoseFree,
  _ => value,
};

String _cookingTimeLabel(AppLocalizations l10n, String value) => switch (value) {
  'quick' => l10n.mealPlanCookingQuick,
  'flexible' => l10n.mealPlanCookingFlexible,
  _ => l10n.mealPlanCookingStandard,
};

/// Nutrition Preferences setup screen (Phase 6) — food/logistics only, no
/// medical fields. Loads the user's saved preferences (or defaults) via
/// [nutritionPreferencesControllerProvider], edits them locally, and saves
/// the whole object back on submit.
class NutritionPreferencesPage extends ConsumerStatefulWidget {
  const NutritionPreferencesPage({super.key});

  @override
  ConsumerState<NutritionPreferencesPage> createState() => _NutritionPreferencesPageState();
}

class _NutritionPreferencesPageState extends ConsumerState<NutritionPreferencesPage> {
  NutritionPreferences? _draft;
  late final TextEditingController _allergiesController;
  late final TextEditingController _dislikedController;
  late final TextEditingController _calorieController;
  late final TextEditingController _proteinController;
  late final TextEditingController _budgetController;

  @override
  void initState() {
    super.initState();
    _allergiesController = TextEditingController();
    _dislikedController = TextEditingController();
    _calorieController = TextEditingController();
    _proteinController = TextEditingController();
    _budgetController = TextEditingController();
  }

  @override
  void dispose() {
    _allergiesController.dispose();
    _dislikedController.dispose();
    _calorieController.dispose();
    _proteinController.dispose();
    _budgetController.dispose();
    super.dispose();
  }

  void _seedFrom(NutritionPreferences prefs) {
    if (_draft != null) return;
    _draft = prefs;
    _allergiesController.text = prefs.allergies.join(', ');
    _dislikedController.text = prefs.dislikedIngredients.join(', ');
    _calorieController.text = prefs.dailyCalorieTarget?.toString() ?? '';
    _proteinController.text = prefs.proteinTargetGrams?.toString() ?? '';
    _budgetController.text = prefs.weeklyFoodBudget?.toString() ?? '';
  }

  List<String> _parseList(String text) =>
      text.split(',').map((s) => s.trim()).where((s) => s.isNotEmpty).toList();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final ext = Theme.of(context).extension<AppThemeExtension>()!;
    final asyncPrefs = ref.watch(nutritionPreferencesControllerProvider);

    return PremiumScaffold(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      child: asyncPrefs.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(
          child: Text('$error', style: TextStyle(color: ext.textMuted)),
        ),
        data: (prefs) {
          _seedFrom(prefs);
          final draft = _draft!;
          final saving = asyncPrefs.isLoading;

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                WorkoutHeader(title: l10n.mealPlanTitle),
                const SizedBox(height: 18),
                _SectionTitle(l10n.mealPlanDietaryPreferences),
                const SizedBox(height: 12),
                Text(l10n.mealPlanDietaryPreferencesQuestion, style: TextStyle(color: ext.textPrimary)),
                const SizedBox(height: 16),
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: [
                    for (final option in NutritionPreferences.dietaryOptions)
                      FilterChip(
                        label: Text(_dietLabel(l10n, option)),
                        selected: draft.dietaryPreferences.contains(option),
                        onSelected: (selected) => setState(() {
                          final next = [...draft.dietaryPreferences];
                          selected ? next.add(option) : next.remove(option);
                          _draft = draft.copyWith(dietaryPreferences: next);
                        }),
                      ),
                  ],
                ),
                const SizedBox(height: 28),
                _SectionTitle(l10n.mealPlanAllergies),
                const SizedBox(height: 12),
                Text(l10n.mealPlanAllergiesQuestion, style: TextStyle(color: ext.textPrimary)),
                const SizedBox(height: 12),
                TextField(
                  controller: _allergiesController,
                  decoration: InputDecoration(hintText: l10n.mealPlanAllergiesHint),
                ),
                const SizedBox(height: 28),
                _SectionTitle(l10n.mealPlanDislikedIngredients),
                const SizedBox(height: 12),
                Text(l10n.mealPlanDislikedIngredientsQuestion, style: TextStyle(color: ext.textPrimary)),
                const SizedBox(height: 12),
                TextField(
                  controller: _dislikedController,
                  decoration: InputDecoration(hintText: l10n.mealPlanDislikedIngredientsHint),
                ),
                const SizedBox(height: 28),
                _SectionTitle(l10n.mealPlanCookingTime),
                const SizedBox(height: 12),
                Text(l10n.mealPlanCookingTimeQuestion, style: TextStyle(color: ext.textPrimary)),
                const SizedBox(height: 16),
                OptionSelector(
                  options: NutritionPreferences.cookingTimeOptions
                      .map((o) => _cookingTimeLabel(l10n, o))
                      .toList(),
                  selected: _cookingTimeLabel(l10n, draft.cookingTimePreference),
                  onSelected: (label) {
                    final value = NutritionPreferences.cookingTimeOptions.firstWhere(
                      (o) => _cookingTimeLabel(l10n, o) == label,
                    );
                    setState(() => _draft = draft.copyWith(cookingTimePreference: value));
                  },
                ),
                const SizedBox(height: 28),
                _SectionTitle(l10n.mealPlanServings),
                const SizedBox(height: 12),
                Text(l10n.mealPlanServingsQuestion, style: TextStyle(color: ext.textPrimary)),
                const SizedBox(height: 12),
                Row(
                  children: [
                    IconButton(
                      onPressed: draft.servings > 1
                          ? () => setState(() => _draft = draft.copyWith(servings: draft.servings - 1))
                          : null,
                      icon: const Icon(Icons.remove_circle_outline),
                    ),
                    Text('${draft.servings}', style: TextStyle(color: ext.textPrimary, fontSize: 18)),
                    IconButton(
                      onPressed: () => setState(() => _draft = draft.copyWith(servings: draft.servings + 1)),
                      icon: const Icon(Icons.add_circle_outline),
                    ),
                  ],
                ),
                const SizedBox(height: 28),
                _SectionTitle(l10n.mealPlanCalorieTarget),
                const SizedBox(height: 12),
                TextField(
                  controller: _calorieController,
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 8),
                _CalorieSuggestionHint(
                  onApply: (calories, protein) => setState(() {
                    _calorieController.text = calories.toString();
                    _proteinController.text = protein.toString();
                  }),
                ),
                const SizedBox(height: 20),
                _SectionTitle(l10n.mealPlanProteinTarget),
                const SizedBox(height: 12),
                TextField(
                  controller: _proteinController,
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 28),
                _SectionTitle(l10n.mealPlanWeeklyBudget),
                const SizedBox(height: 12),
                TextField(
                  controller: _budgetController,
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 12),
                Text(
                  l10n.mealPlanEstimateDisclaimer,
                  style: TextStyle(color: ext.textMuted, fontSize: 12),
                ),
                const SizedBox(height: 28),
                PrimaryButton(
                  label: l10n.mealPlanSavePreferences,
                  isLoading: saving,
                  onPressed: saving
                      ? null
                      : () async {
                          final updated = draft.copyWith(
                            allergies: _parseList(_allergiesController.text),
                            dislikedIngredients: _parseList(_dislikedController.text),
                            dailyCalorieTarget: int.tryParse(_calorieController.text),
                            proteinTargetGrams: int.tryParse(_proteinController.text),
                            weeklyFoodBudget: num.tryParse(_budgetController.text),
                            nutritionPlanEnabled: true,
                          );
                          await ref.read(nutritionPreferencesControllerProvider.notifier).save(updated);
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text(l10n.mealPlanPreferencesSaved)),
                            );
                          }
                        },
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _CalorieSuggestionHint extends ConsumerWidget {
  const _CalorieSuggestionHint({required this.onApply});

  final void Function(int calories, int protein) onApply;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final ext = Theme.of(context).extension<AppThemeExtension>()!;
    final suggestion = ref.watch(calorieSuggestionProvider);

    return suggestion.when(
      loading: () => const SizedBox.shrink(),
      error: (_, _) => const SizedBox.shrink(),
      data: (value) {
        if (value.estimatedCalories == null) {
          return Text(l10n.mealPlanEstimateUnavailable, style: TextStyle(color: ext.textMuted, fontSize: 12));
        }
        return TextButton(
          onPressed: () => onApply(value.estimatedCalories!, value.estimatedProteinGrams ?? 0),
          child: Text('${l10n.mealPlanUseEstimate}: ${value.estimatedCalories} kcal / ${value.estimatedProteinGrams}g'),
        );
      },
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle(this.text);
  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: Theme.of(context).textTheme.titleLarge?.copyWith(
        color: Theme.of(context).colorScheme.primary,
        fontWeight: FontWeight.w900,
      ),
    );
  }
}
