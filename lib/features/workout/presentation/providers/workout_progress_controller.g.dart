// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'workout_progress_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(WorkoutProgressTab)
final workoutProgressTabProvider = WorkoutProgressTabProvider._();

final class WorkoutProgressTabProvider
    extends $NotifierProvider<WorkoutProgressTab, ProgressTab> {
  WorkoutProgressTabProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'workoutProgressTabProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$workoutProgressTabHash();

  @$internal
  @override
  WorkoutProgressTab create() => WorkoutProgressTab();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ProgressTab value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ProgressTab>(value),
    );
  }
}

String _$workoutProgressTabHash() =>
    r'e61ee787ff889abf79fa2c2937f7992569681d4a';

abstract class _$WorkoutProgressTab extends $Notifier<ProgressTab> {
  ProgressTab build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<ProgressTab, ProgressTab>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<ProgressTab, ProgressTab>,
              ProgressTab,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

/// Loads `/api/workout-logs` — the user's completed-workout history.

@ProviderFor(ActivityLog)
final activityLogProvider = ActivityLogProvider._();

/// Loads `/api/workout-logs` — the user's completed-workout history.
final class ActivityLogProvider
    extends $NotifierProvider<ActivityLog, List<ActivityLogItem>> {
  /// Loads `/api/workout-logs` — the user's completed-workout history.
  ActivityLogProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'activityLogProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$activityLogHash();

  @$internal
  @override
  ActivityLog create() => ActivityLog();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(List<ActivityLogItem> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<List<ActivityLogItem>>(value),
    );
  }
}

String _$activityLogHash() => r'4726c5a0020146c52a89d7ae7208a1bcc12b36de';

/// Loads `/api/workout-logs` — the user's completed-workout history.

abstract class _$ActivityLog extends $Notifier<List<ActivityLogItem>> {
  List<ActivityLogItem> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<List<ActivityLogItem>, List<ActivityLogItem>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<List<ActivityLogItem>, List<ActivityLogItem>>,
              List<ActivityLogItem>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

/// This week's per-day activity built from `/api/workout-logs`, for the
/// Charts tab's bar chart and summary row. Index 0 = Monday.

@ProviderFor(WeeklyChart)
final weeklyChartProvider = WeeklyChartProvider._();

/// This week's per-day activity built from `/api/workout-logs`, for the
/// Charts tab's bar chart and summary row. Index 0 = Monday.
final class WeeklyChartProvider
    extends $NotifierProvider<WeeklyChart, List<DayActivity>> {
  /// This week's per-day activity built from `/api/workout-logs`, for the
  /// Charts tab's bar chart and summary row. Index 0 = Monday.
  WeeklyChartProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'weeklyChartProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$weeklyChartHash();

  @$internal
  @override
  WeeklyChart create() => WeeklyChart();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(List<DayActivity> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<List<DayActivity>>(value),
    );
  }
}

String _$weeklyChartHash() => r'07d5ad5a8f9432f02a5ebf96fbf9839beb944c39';

/// This week's per-day activity built from `/api/workout-logs`, for the
/// Charts tab's bar chart and summary row. Index 0 = Monday.

abstract class _$WeeklyChart extends $Notifier<List<DayActivity>> {
  List<DayActivity> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<List<DayActivity>, List<DayActivity>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<List<DayActivity>, List<DayActivity>>,
              List<DayActivity>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
