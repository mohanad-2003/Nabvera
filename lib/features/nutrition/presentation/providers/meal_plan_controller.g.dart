// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'meal_plan_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// The current user's active weekly meal plan — `null` means no plan has
/// been generated yet (the empty state). An [AsyncNotifier] so
/// generating/regenerating/replacing all show a real, honest loading state
/// rather than a fixed-duration fake progress animation (see the Phase 6
/// brief's explicit requirement on the generating screen).

@ProviderFor(MealPlanController)
final mealPlanControllerProvider = MealPlanControllerProvider._();

/// The current user's active weekly meal plan — `null` means no plan has
/// been generated yet (the empty state). An [AsyncNotifier] so
/// generating/regenerating/replacing all show a real, honest loading state
/// rather than a fixed-duration fake progress animation (see the Phase 6
/// brief's explicit requirement on the generating screen).
final class MealPlanControllerProvider
    extends $AsyncNotifierProvider<MealPlanController, MealPlan?> {
  /// The current user's active weekly meal plan — `null` means no plan has
  /// been generated yet (the empty state). An [AsyncNotifier] so
  /// generating/regenerating/replacing all show a real, honest loading state
  /// rather than a fixed-duration fake progress animation (see the Phase 6
  /// brief's explicit requirement on the generating screen).
  MealPlanControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'mealPlanControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$mealPlanControllerHash();

  @$internal
  @override
  MealPlanController create() => MealPlanController();
}

String _$mealPlanControllerHash() =>
    r'54a7d5586463325c62dbe86cde0ec71643652ec1';

/// The current user's active weekly meal plan — `null` means no plan has
/// been generated yet (the empty state). An [AsyncNotifier] so
/// generating/regenerating/replacing all show a real, honest loading state
/// rather than a fixed-duration fake progress animation (see the Phase 6
/// brief's explicit requirement on the generating screen).

abstract class _$MealPlanController extends $AsyncNotifier<MealPlan?> {
  FutureOr<MealPlan?> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AsyncValue<MealPlan?>, MealPlan?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<MealPlan?>, MealPlan?>,
              AsyncValue<MealPlan?>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

/// The user's past (inactive) meal plans, most recent first.

@ProviderFor(mealPlanHistory)
final mealPlanHistoryProvider = MealPlanHistoryProvider._();

/// The user's past (inactive) meal plans, most recent first.

final class MealPlanHistoryProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<MealPlan>>,
          List<MealPlan>,
          FutureOr<List<MealPlan>>
        >
    with $FutureModifier<List<MealPlan>>, $FutureProvider<List<MealPlan>> {
  /// The user's past (inactive) meal plans, most recent first.
  MealPlanHistoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'mealPlanHistoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$mealPlanHistoryHash();

  @$internal
  @override
  $FutureProviderElement<List<MealPlan>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<MealPlan>> create(Ref ref) {
    return mealPlanHistory(ref);
  }
}

String _$mealPlanHistoryHash() => r'e40f5e03318278e7976010ef4e3f243b459325f2';
