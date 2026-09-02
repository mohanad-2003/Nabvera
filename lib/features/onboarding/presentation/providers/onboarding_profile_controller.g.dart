// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'onboarding_profile_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Single source of truth for the whole profile-setup wizard, replacing
/// five separate near-identical GetX controllers (GenderController,
/// AgeControllert, HeightController, WeightController, GoalController)
/// that each only held one primitive value.

@ProviderFor(OnboardingProfileController)
final onboardingProfileControllerProvider =
    OnboardingProfileControllerProvider._();

/// Single source of truth for the whole profile-setup wizard, replacing
/// five separate near-identical GetX controllers (GenderController,
/// AgeControllert, HeightController, WeightController, GoalController)
/// that each only held one primitive value.
final class OnboardingProfileControllerProvider
    extends $NotifierProvider<OnboardingProfileController, OnboardingProfile> {
  /// Single source of truth for the whole profile-setup wizard, replacing
  /// five separate near-identical GetX controllers (GenderController,
  /// AgeControllert, HeightController, WeightController, GoalController)
  /// that each only held one primitive value.
  OnboardingProfileControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'onboardingProfileControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$onboardingProfileControllerHash();

  @$internal
  @override
  OnboardingProfileController create() => OnboardingProfileController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(OnboardingProfile value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<OnboardingProfile>(value),
    );
  }
}

String _$onboardingProfileControllerHash() =>
    r'1220badbc0b3be4abeebb2a6f495520e295b2ea5';

/// Single source of truth for the whole profile-setup wizard, replacing
/// five separate near-identical GetX controllers (GenderController,
/// AgeControllert, HeightController, WeightController, GoalController)
/// that each only held one primitive value.

abstract class _$OnboardingProfileController
    extends $Notifier<OnboardingProfile> {
  OnboardingProfile build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<OnboardingProfile, OnboardingProfile>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<OnboardingProfile, OnboardingProfile>,
              OnboardingProfile,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
