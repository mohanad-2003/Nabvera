// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'meal_plan_wizard_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Single wizard state replacing MealPlaneController + MealPlan2Conroller,
/// which only ever held one selected value each across two consecutive
/// screens of the same flow.

@ProviderFor(MealPlanWizardController)
final mealPlanWizardControllerProvider = MealPlanWizardControllerProvider._();

/// Single wizard state replacing MealPlaneController + MealPlan2Conroller,
/// which only ever held one selected value each across two consecutive
/// screens of the same flow.
final class MealPlanWizardControllerProvider
    extends $NotifierProvider<MealPlanWizardController, MealPlanPreferences> {
  /// Single wizard state replacing MealPlaneController + MealPlan2Conroller,
  /// which only ever held one selected value each across two consecutive
  /// screens of the same flow.
  MealPlanWizardControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'mealPlanWizardControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$mealPlanWizardControllerHash();

  @$internal
  @override
  MealPlanWizardController create() => MealPlanWizardController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(MealPlanPreferences value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<MealPlanPreferences>(value),
    );
  }
}

String _$mealPlanWizardControllerHash() =>
    r'ae04c10a8d6ca9e4c76ab96bf85e460f533e4281';

/// Single wizard state replacing MealPlaneController + MealPlan2Conroller,
/// which only ever held one selected value each across two consecutive
/// screens of the same flow.

abstract class _$MealPlanWizardController
    extends $Notifier<MealPlanPreferences> {
  MealPlanPreferences build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<MealPlanPreferences, MealPlanPreferences>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<MealPlanPreferences, MealPlanPreferences>,
              MealPlanPreferences,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
