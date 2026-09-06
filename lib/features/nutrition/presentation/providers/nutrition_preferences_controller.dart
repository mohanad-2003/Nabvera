import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/analytics/analytics_service.dart';
import '../../data/nutrition_repository.dart';
import '../../domain/nutrition_preferences.dart';

part 'nutrition_preferences_controller.g.dart';

/// Loads and saves `/api/users/me/nutrition-preferences` — an
/// [AsyncNotifier] so the setup screen can show a real loading/error state
/// instead of a fake one (see the Phase 6 brief's "honest progress"
/// requirement, which applies to every part of this feature, not just plan
/// generation).
@riverpod
class NutritionPreferencesController extends _$NutritionPreferencesController {
  @override
  Future<NutritionPreferences> build() async {
    final json = await ref.read(nutritionRepositoryProvider).fetchNutritionPreferences();
    return NutritionPreferences.fromJson(json);
  }

  Future<void> save(NutritionPreferences preferences) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final json = await ref
          .read(nutritionRepositoryProvider)
          .updateNutritionPreferences(preferences.toJson());
      final saved = NutritionPreferences.fromJson(json);
      ref.read(analyticsServiceProvider).logEvent(AnalyticsEvent.nutritionPreferencesUpdated, {
        'preferencesFieldCount': saved.dietaryPreferences.length + saved.allergies.length,
        'cookingTimePreference': saved.cookingTimePreference,
      });
      return saved;
    });
  }
}

/// One-shot rule-based calorie/protein suggestion — fetched on demand
/// (e.g. when the preferences screen opens with no saved target yet), not
/// auto-applied: the user always sees and can edit it before saving.
@riverpod
Future<CalorieSuggestion> calorieSuggestion(Ref ref) async {
  final json = await ref.read(nutritionRepositoryProvider).fetchCalorieSuggestion();
  return CalorieSuggestion.fromJson(json);
}
