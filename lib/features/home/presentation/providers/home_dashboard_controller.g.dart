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
    r'fb74a97549ad254e83d889d74a5c3626cd965ef7';

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
    r'057fb4cbf06a4d2402427e07cbfcebb54adbcf96';

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
    r'7679dc1d70fca3ec4ba0cd6ef1068032543c2564';

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

/// The richer weekly-progress numbers (total minutes, week-over-week
/// comparison, longest streak, "any logs at all" for the empty state) —
/// kept as its own provider rather than folded into
/// [WeeklyActivityController] so that widget's existing, already-shipped
/// consumers (hero card, metrics grid) are untouched by this addition.
/// Costs one extra `fetchWorkoutLogs()` call, which is an accepted,
/// existing pattern in this codebase for independent per-feature fetches.

@ProviderFor(WeeklyProgressStatsController)
final weeklyProgressStatsControllerProvider =
    WeeklyProgressStatsControllerProvider._();

/// The richer weekly-progress numbers (total minutes, week-over-week
/// comparison, longest streak, "any logs at all" for the empty state) —
/// kept as its own provider rather than folded into
/// [WeeklyActivityController] so that widget's existing, already-shipped
/// consumers (hero card, metrics grid) are untouched by this addition.
/// Costs one extra `fetchWorkoutLogs()` call, which is an accepted,
/// existing pattern in this codebase for independent per-feature fetches.
final class WeeklyProgressStatsControllerProvider
    extends
        $NotifierProvider<WeeklyProgressStatsController, WeeklyProgressStats> {
  /// The richer weekly-progress numbers (total minutes, week-over-week
  /// comparison, longest streak, "any logs at all" for the empty state) —
  /// kept as its own provider rather than folded into
  /// [WeeklyActivityController] so that widget's existing, already-shipped
  /// consumers (hero card, metrics grid) are untouched by this addition.
  /// Costs one extra `fetchWorkoutLogs()` call, which is an accepted,
  /// existing pattern in this codebase for independent per-feature fetches.
  WeeklyProgressStatsControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'weeklyProgressStatsControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$weeklyProgressStatsControllerHash();

  @$internal
  @override
  WeeklyProgressStatsController create() => WeeklyProgressStatsController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(WeeklyProgressStats value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<WeeklyProgressStats>(value),
    );
  }
}

String _$weeklyProgressStatsControllerHash() =>
    r'1b9233c3d6a953f42c2714c9788c3e8fa0f8bd40';

/// The richer weekly-progress numbers (total minutes, week-over-week
/// comparison, longest streak, "any logs at all" for the empty state) —
/// kept as its own provider rather than folded into
/// [WeeklyActivityController] so that widget's existing, already-shipped
/// consumers (hero card, metrics grid) are untouched by this addition.
/// Costs one extra `fetchWorkoutLogs()` call, which is an accepted,
/// existing pattern in this codebase for independent per-feature fetches.

abstract class _$WeeklyProgressStatsController
    extends $Notifier<WeeklyProgressStats> {
  WeeklyProgressStats build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<WeeklyProgressStats, WeeklyProgressStats>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<WeeklyProgressStats, WeeklyProgressStats>,
              WeeklyProgressStats,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
