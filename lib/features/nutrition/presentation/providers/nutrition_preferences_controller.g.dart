// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'nutrition_preferences_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Loads and saves `/api/users/me/nutrition-preferences` — an
/// [AsyncNotifier] so the setup screen can show a real loading/error state
/// instead of a fake one (see the Phase 6 brief's "honest progress"
/// requirement, which applies to every part of this feature, not just plan
/// generation).

@ProviderFor(NutritionPreferencesController)
final nutritionPreferencesControllerProvider =
    NutritionPreferencesControllerProvider._();

/// Loads and saves `/api/users/me/nutrition-preferences` — an
/// [AsyncNotifier] so the setup screen can show a real loading/error state
/// instead of a fake one (see the Phase 6 brief's "honest progress"
/// requirement, which applies to every part of this feature, not just plan
/// generation).
final class NutritionPreferencesControllerProvider
    extends
        $AsyncNotifierProvider<
          NutritionPreferencesController,
          NutritionPreferences
        > {
  /// Loads and saves `/api/users/me/nutrition-preferences` — an
  /// [AsyncNotifier] so the setup screen can show a real loading/error state
  /// instead of a fake one (see the Phase 6 brief's "honest progress"
  /// requirement, which applies to every part of this feature, not just plan
  /// generation).
  NutritionPreferencesControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'nutritionPreferencesControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$nutritionPreferencesControllerHash();

  @$internal
  @override
  NutritionPreferencesController create() => NutritionPreferencesController();
}

String _$nutritionPreferencesControllerHash() =>
    r'4e63ee1ca778be48384b0bba2f9bfd0a9c4b20ce';

/// Loads and saves `/api/users/me/nutrition-preferences` — an
/// [AsyncNotifier] so the setup screen can show a real loading/error state
/// instead of a fake one (see the Phase 6 brief's "honest progress"
/// requirement, which applies to every part of this feature, not just plan
/// generation).

abstract class _$NutritionPreferencesController
    extends $AsyncNotifier<NutritionPreferences> {
  FutureOr<NutritionPreferences> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref =
        this.ref
            as $Ref<AsyncValue<NutritionPreferences>, NutritionPreferences>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                AsyncValue<NutritionPreferences>,
                NutritionPreferences
              >,
              AsyncValue<NutritionPreferences>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

/// One-shot rule-based calorie/protein suggestion — fetched on demand
/// (e.g. when the preferences screen opens with no saved target yet), not
/// auto-applied: the user always sees and can edit it before saving.

@ProviderFor(calorieSuggestion)
final calorieSuggestionProvider = CalorieSuggestionProvider._();

/// One-shot rule-based calorie/protein suggestion — fetched on demand
/// (e.g. when the preferences screen opens with no saved target yet), not
/// auto-applied: the user always sees and can edit it before saving.

final class CalorieSuggestionProvider
    extends
        $FunctionalProvider<
          AsyncValue<CalorieSuggestion>,
          CalorieSuggestion,
          FutureOr<CalorieSuggestion>
        >
    with
        $FutureModifier<CalorieSuggestion>,
        $FutureProvider<CalorieSuggestion> {
  /// One-shot rule-based calorie/protein suggestion — fetched on demand
  /// (e.g. when the preferences screen opens with no saved target yet), not
  /// auto-applied: the user always sees and can edit it before saving.
  CalorieSuggestionProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'calorieSuggestionProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$calorieSuggestionHash();

  @$internal
  @override
  $FutureProviderElement<CalorieSuggestion> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<CalorieSuggestion> create(Ref ref) {
    return calorieSuggestion(ref);
  }
}

String _$calorieSuggestionHash() => r'2e3d2d487dd8682faf06ef3d7c560d70aacacce3';
