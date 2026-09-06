// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'nutrition_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(NutritionTabController)
final nutritionTabControllerProvider = NutritionTabControllerProvider._();

final class NutritionTabControllerProvider
    extends $NotifierProvider<NutritionTabController, NutritionTab> {
  NutritionTabControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'nutritionTabControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$nutritionTabControllerHash();

  @$internal
  @override
  NutritionTabController create() => NutritionTabController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(NutritionTab value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<NutritionTab>(value),
    );
  }
}

String _$nutritionTabControllerHash() =>
    r'0868b563d44ec6fd0087fdde7045f86827459de9';

abstract class _$NutritionTabController extends $Notifier<NutritionTab> {
  NutritionTab build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<NutritionTab, NutritionTab>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<NutritionTab, NutritionTab>,
              NutritionTab,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

/// Loads `/api/recipes` once and splits it: the two highest-rated recipes
/// become "Recommended", the rest fill "Recipes for you".

@ProviderFor(NutritionRecommended)
final nutritionRecommendedProvider = NutritionRecommendedProvider._();

/// Loads `/api/recipes` once and splits it: the two highest-rated recipes
/// become "Recommended", the rest fill "Recipes for you".
final class NutritionRecommendedProvider
    extends $NotifierProvider<NutritionRecommended, List<MealItem>> {
  /// Loads `/api/recipes` once and splits it: the two highest-rated recipes
  /// become "Recommended", the rest fill "Recipes for you".
  NutritionRecommendedProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'nutritionRecommendedProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$nutritionRecommendedHash();

  @$internal
  @override
  NutritionRecommended create() => NutritionRecommended();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(List<MealItem> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<List<MealItem>>(value),
    );
  }
}

String _$nutritionRecommendedHash() =>
    r'0ef5d5acb0b301ff82e241278cac0685f8ebfe90';

/// Loads `/api/recipes` once and splits it: the two highest-rated recipes
/// become "Recommended", the rest fill "Recipes for you".

abstract class _$NutritionRecommended extends $Notifier<List<MealItem>> {
  List<MealItem> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<List<MealItem>, List<MealItem>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<List<MealItem>, List<MealItem>>,
              List<MealItem>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

@ProviderFor(NutritionRecipes)
final nutritionRecipesProvider = NutritionRecipesProvider._();

final class NutritionRecipesProvider
    extends $NotifierProvider<NutritionRecipes, List<MealItem>> {
  NutritionRecipesProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'nutritionRecipesProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$nutritionRecipesHash();

  @$internal
  @override
  NutritionRecipes create() => NutritionRecipes();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(List<MealItem> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<List<MealItem>>(value),
    );
  }
}

String _$nutritionRecipesHash() => r'9076fac56bd27eba48da5c7a235b1923a03e08c3';

abstract class _$NutritionRecipes extends $Notifier<List<MealItem>> {
  List<MealItem> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<List<MealItem>, List<MealItem>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<List<MealItem>, List<MealItem>>,
              List<MealItem>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

@ProviderFor(_recipes)
final _recipesProvider = _RecipesProvider._();

final class _RecipesProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Map<String, dynamic>>>,
          List<Map<String, dynamic>>,
          FutureOr<List<Map<String, dynamic>>>
        >
    with
        $FutureModifier<List<Map<String, dynamic>>>,
        $FutureProvider<List<Map<String, dynamic>>> {
  _RecipesProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'_recipesProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$_recipesHash();

  @$internal
  @override
  $FutureProviderElement<List<Map<String, dynamic>>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<Map<String, dynamic>>> create(Ref ref) {
    return _recipes(ref);
  }
}

String _$_recipesHash() => r'c216a42870b373a933380971cc9a06cb773074ff';

/// Loads the real `/api/nutrition/today` document and converts it into
/// display fractions/strings.

@ProviderFor(DailyNutritionSummaryController)
final dailyNutritionSummaryControllerProvider =
    DailyNutritionSummaryControllerProvider._();

/// Loads the real `/api/nutrition/today` document and converts it into
/// display fractions/strings.
final class DailyNutritionSummaryControllerProvider
    extends
        $NotifierProvider<
          DailyNutritionSummaryController,
          DailyNutritionSummary
        > {
  /// Loads the real `/api/nutrition/today` document and converts it into
  /// display fractions/strings.
  DailyNutritionSummaryControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'dailyNutritionSummaryControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$dailyNutritionSummaryControllerHash();

  @$internal
  @override
  DailyNutritionSummaryController create() => DailyNutritionSummaryController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(DailyNutritionSummary value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<DailyNutritionSummary>(value),
    );
  }
}

String _$dailyNutritionSummaryControllerHash() =>
    r'f2f22c934fdd53cf4dcf2f7c991c70471cfc799f';

/// Loads the real `/api/nutrition/today` document and converts it into
/// display fractions/strings.

abstract class _$DailyNutritionSummaryController
    extends $Notifier<DailyNutritionSummary> {
  DailyNutritionSummary build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<DailyNutritionSummary, DailyNutritionSummary>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<DailyNutritionSummary, DailyNutritionSummary>,
              DailyNutritionSummary,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
