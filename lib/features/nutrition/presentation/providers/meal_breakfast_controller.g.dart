// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'meal_breakfast_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Loads `/api/recipes?category=breakfast`. `isFavorite` has no backend
/// equivalent for this simplified option list (see [MealIdeaFavorites] for
/// the real favorites toggle used by the recipe detail flow) — it stays a
/// local-only UI toggle here.

@ProviderFor(MealBreakfastController)
final mealBreakfastControllerProvider = MealBreakfastControllerProvider._();

/// Loads `/api/recipes?category=breakfast`. `isFavorite` has no backend
/// equivalent for this simplified option list (see [MealIdeaFavorites] for
/// the real favorites toggle used by the recipe detail flow) — it stays a
/// local-only UI toggle here.
final class MealBreakfastControllerProvider
    extends $NotifierProvider<MealBreakfastController, List<BreakfastOption>> {
  /// Loads `/api/recipes?category=breakfast`. `isFavorite` has no backend
  /// equivalent for this simplified option list (see [MealIdeaFavorites] for
  /// the real favorites toggle used by the recipe detail flow) — it stays a
  /// local-only UI toggle here.
  MealBreakfastControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'mealBreakfastControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$mealBreakfastControllerHash();

  @$internal
  @override
  MealBreakfastController create() => MealBreakfastController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(List<BreakfastOption> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<List<BreakfastOption>>(value),
    );
  }
}

String _$mealBreakfastControllerHash() =>
    r'5be11ada57d7b36a66c2f8d6b3022dadf740940d';

/// Loads `/api/recipes?category=breakfast`. `isFavorite` has no backend
/// equivalent for this simplified option list (see [MealIdeaFavorites] for
/// the real favorites toggle used by the recipe detail flow) — it stays a
/// local-only UI toggle here.

abstract class _$MealBreakfastController
    extends $Notifier<List<BreakfastOption>> {
  List<BreakfastOption> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<List<BreakfastOption>, List<BreakfastOption>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<List<BreakfastOption>, List<BreakfastOption>>,
              List<BreakfastOption>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

@ProviderFor(SelectedBreakfastIndex)
final selectedBreakfastIndexProvider = SelectedBreakfastIndexProvider._();

final class SelectedBreakfastIndexProvider
    extends $NotifierProvider<SelectedBreakfastIndex, int> {
  SelectedBreakfastIndexProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'selectedBreakfastIndexProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$selectedBreakfastIndexHash();

  @$internal
  @override
  SelectedBreakfastIndex create() => SelectedBreakfastIndex();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(int value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<int>(value),
    );
  }
}

String _$selectedBreakfastIndexHash() =>
    r'14fe2db4fc8377b80e5580b8dad2279201666174';

abstract class _$SelectedBreakfastIndex extends $Notifier<int> {
  int build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<int, int>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<int, int>,
              int,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
