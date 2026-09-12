// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'workout_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(WorkoutTab)
final workoutTabProvider = WorkoutTabProvider._();

final class WorkoutTabProvider
    extends $NotifierProvider<WorkoutTab, WorkoutLevel> {
  WorkoutTabProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'workoutTabProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$workoutTabHash();

  @$internal
  @override
  WorkoutTab create() => WorkoutTab();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(WorkoutLevel value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<WorkoutLevel>(value),
    );
  }
}

String _$workoutTabHash() => r'0257bf0bcb0681538337c1fc7f9e765fd6f6db66';

abstract class _$WorkoutTab extends $Notifier<WorkoutLevel> {
  WorkoutLevel build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<WorkoutLevel, WorkoutLevel>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<WorkoutLevel, WorkoutLevel>,
              WorkoutLevel,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

/// The selected category chip on the Workout tab's list (raw backend
/// `Workout.category` value, or `null` for "All") — kept separate from
/// [WorkoutTab] since the two filters are independent (level always
/// applies; category narrows further).

@ProviderFor(WorkoutCategoryFilter)
final workoutCategoryFilterProvider = WorkoutCategoryFilterProvider._();

/// The selected category chip on the Workout tab's list (raw backend
/// `Workout.category` value, or `null` for "All") — kept separate from
/// [WorkoutTab] since the two filters are independent (level always
/// applies; category narrows further).
final class WorkoutCategoryFilterProvider
    extends $NotifierProvider<WorkoutCategoryFilter, String?> {
  /// The selected category chip on the Workout tab's list (raw backend
  /// `Workout.category` value, or `null` for "All") — kept separate from
  /// [WorkoutTab] since the two filters are independent (level always
  /// applies; category narrows further).
  WorkoutCategoryFilterProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'workoutCategoryFilterProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$workoutCategoryFilterHash();

  @$internal
  @override
  WorkoutCategoryFilter create() => WorkoutCategoryFilter();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<String?>(value),
    );
  }
}

String _$workoutCategoryFilterHash() =>
    r'9f560c30d37a417b3fbb42b3d0245f0fb4bce8b5';

/// The selected category chip on the Workout tab's list (raw backend
/// `Workout.category` value, or `null` for "All") — kept separate from
/// [WorkoutTab] since the two filters are independent (level always
/// applies; category narrows further).

abstract class _$WorkoutCategoryFilter extends $Notifier<String?> {
  String? build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<String?, String?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<String?, String?>,
              String?,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

/// Loads `/api/workouts?difficulty=<level>&category=<category>` for the
/// selected tab + category chip. Starts empty and fills in once the fetch
/// resolves — matches the pattern used by `CurrentUserProfile` so the page
/// never needs an `AsyncValue` branch.

@ProviderFor(WorkoutListByLevel)
final workoutListByLevelProvider = WorkoutListByLevelFamily._();

/// Loads `/api/workouts?difficulty=<level>&category=<category>` for the
/// selected tab + category chip. Starts empty and fills in once the fetch
/// resolves — matches the pattern used by `CurrentUserProfile` so the page
/// never needs an `AsyncValue` branch.
final class WorkoutListByLevelProvider
    extends $NotifierProvider<WorkoutListByLevel, List<WorkoutListItem>> {
  /// Loads `/api/workouts?difficulty=<level>&category=<category>` for the
  /// selected tab + category chip. Starts empty and fills in once the fetch
  /// resolves — matches the pattern used by `CurrentUserProfile` so the page
  /// never needs an `AsyncValue` branch.
  WorkoutListByLevelProvider._({
    required WorkoutListByLevelFamily super.from,
    required WorkoutLevel super.argument,
  }) : super(
         retry: null,
         name: r'workoutListByLevelProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$workoutListByLevelHash();

  @override
  String toString() {
    return r'workoutListByLevelProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  WorkoutListByLevel create() => WorkoutListByLevel();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(List<WorkoutListItem> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<List<WorkoutListItem>>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is WorkoutListByLevelProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$workoutListByLevelHash() =>
    r'829b13a747a8fc46121561fdbd4a2fc7a3fef988';

/// Loads `/api/workouts?difficulty=<level>&category=<category>` for the
/// selected tab + category chip. Starts empty and fills in once the fetch
/// resolves — matches the pattern used by `CurrentUserProfile` so the page
/// never needs an `AsyncValue` branch.

final class WorkoutListByLevelFamily extends $Family
    with
        $ClassFamilyOverride<
          WorkoutListByLevel,
          List<WorkoutListItem>,
          List<WorkoutListItem>,
          List<WorkoutListItem>,
          WorkoutLevel
        > {
  WorkoutListByLevelFamily._()
    : super(
        retry: null,
        name: r'workoutListByLevelProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Loads `/api/workouts?difficulty=<level>&category=<category>` for the
  /// selected tab + category chip. Starts empty and fills in once the fetch
  /// resolves — matches the pattern used by `CurrentUserProfile` so the page
  /// never needs an `AsyncValue` branch.

  WorkoutListByLevelProvider call(WorkoutLevel level) =>
      WorkoutListByLevelProvider._(argument: level, from: this);

  @override
  String toString() => r'workoutListByLevelProvider';
}

/// Loads `/api/workouts?difficulty=<level>&category=<category>` for the
/// selected tab + category chip. Starts empty and fills in once the fetch
/// resolves — matches the pattern used by `CurrentUserProfile` so the page
/// never needs an `AsyncValue` branch.

abstract class _$WorkoutListByLevel extends $Notifier<List<WorkoutListItem>> {
  late final _$args = ref.$arg as WorkoutLevel;
  WorkoutLevel get level => _$args;

  List<WorkoutListItem> build(WorkoutLevel level);
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<List<WorkoutListItem>, List<WorkoutListItem>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<List<WorkoutListItem>, List<WorkoutListItem>>,
              List<WorkoutListItem>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, () => build(_$args));
  }
}
