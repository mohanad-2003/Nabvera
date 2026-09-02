// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'home_dashboard_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(HomeFeaturedWorkoutController)
final homeFeaturedWorkoutControllerProvider =
    HomeFeaturedWorkoutControllerProvider._();

final class HomeFeaturedWorkoutControllerProvider
    extends
        $NotifierProvider<HomeFeaturedWorkoutController, HomeFeaturedWorkout?> {
  HomeFeaturedWorkoutControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'homeFeaturedWorkoutControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$homeFeaturedWorkoutControllerHash();

  @$internal
  @override
  HomeFeaturedWorkoutController create() => HomeFeaturedWorkoutController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(HomeFeaturedWorkout? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<HomeFeaturedWorkout?>(value),
    );
  }
}

String _$homeFeaturedWorkoutControllerHash() =>
    r'57ba5da29164a6bcf3ad0881587afcf5bb30053c';

abstract class _$HomeFeaturedWorkoutController
    extends $Notifier<HomeFeaturedWorkout?> {
  HomeFeaturedWorkout? build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<HomeFeaturedWorkout?, HomeFeaturedWorkout?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<HomeFeaturedWorkout?, HomeFeaturedWorkout?>,
              HomeFeaturedWorkout?,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

/// Standalone recovery-map fetch for the Home page's compact recovery row
/// — independent of [HomeFeaturedWorkoutController] so it still renders
/// even if that request fails, and so it isn't tied to any one
/// recommendation.

@ProviderFor(RecoveryMapController)
final recoveryMapControllerProvider = RecoveryMapControllerProvider._();

/// Standalone recovery-map fetch for the Home page's compact recovery row
/// — independent of [HomeFeaturedWorkoutController] so it still renders
/// even if that request fails, and so it isn't tied to any one
/// recommendation.
final class RecoveryMapControllerProvider
    extends
        $NotifierProvider<RecoveryMapController, List<MuscleGroupRecovery>> {
  /// Standalone recovery-map fetch for the Home page's compact recovery row
  /// — independent of [HomeFeaturedWorkoutController] so it still renders
  /// even if that request fails, and so it isn't tied to any one
  /// recommendation.
  RecoveryMapControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'recoveryMapControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$recoveryMapControllerHash();

  @$internal
  @override
  RecoveryMapController create() => RecoveryMapController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(List<MuscleGroupRecovery> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<List<MuscleGroupRecovery>>(value),
    );
  }
}

String _$recoveryMapControllerHash() =>
    r'9ed84fd8be38ac7462e89d01b946da6b915a4817';

/// Standalone recovery-map fetch for the Home page's compact recovery row
/// — independent of [HomeFeaturedWorkoutController] so it still renders
/// even if that request fails, and so it isn't tied to any one
/// recommendation.

abstract class _$RecoveryMapController
    extends $Notifier<List<MuscleGroupRecovery>> {
  List<MuscleGroupRecovery> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref =
        this.ref as $Ref<List<MuscleGroupRecovery>, List<MuscleGroupRecovery>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<List<MuscleGroupRecovery>, List<MuscleGroupRecovery>>,
              List<MuscleGroupRecovery>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

/// This week's per-day trained minutes, built from `/api/workout-logs`, for
/// the weekly progress bar chart. Index 0 = Monday.

@ProviderFor(WeeklyActivityController)
final weeklyActivityControllerProvider = WeeklyActivityControllerProvider._();

/// This week's per-day trained minutes, built from `/api/workout-logs`, for
/// the weekly progress bar chart. Index 0 = Monday.
final class WeeklyActivityControllerProvider
    extends $NotifierProvider<WeeklyActivityController, List<int>> {
  /// This week's per-day trained minutes, built from `/api/workout-logs`, for
  /// the weekly progress bar chart. Index 0 = Monday.
  WeeklyActivityControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'weeklyActivityControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$weeklyActivityControllerHash();

  @$internal
  @override
  WeeklyActivityController create() => WeeklyActivityController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(List<int> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<List<int>>(value),
    );
  }
}

String _$weeklyActivityControllerHash() =>
    r'a34e037f2deb49c57d552236e8292594aa7edf60';

/// This week's per-day trained minutes, built from `/api/workout-logs`, for
/// the weekly progress bar chart. Index 0 = Monday.

abstract class _$WeeklyActivityController extends $Notifier<List<int>> {
  List<int> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<List<int>, List<int>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<List<int>, List<int>>,
              List<int>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
