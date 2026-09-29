// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'workout_active_session_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// The Workout tab's "continue where you left off" state — sourced from
/// `CurrentUserProfile.activeWorkoutSession` (backend-persisted, syncs
/// across devices), not local storage. Optimistic updates mirror
/// `WorkoutListByLevel.toggleFavorite`: apply locally first, sync in the
/// background, revert on failure.

@ProviderFor(WorkoutActiveSession)
final workoutActiveSessionProvider = WorkoutActiveSessionProvider._();

/// The Workout tab's "continue where you left off" state — sourced from
/// `CurrentUserProfile.activeWorkoutSession` (backend-persisted, syncs
/// across devices), not local storage. Optimistic updates mirror
/// `WorkoutListByLevel.toggleFavorite`: apply locally first, sync in the
/// background, revert on failure.
final class WorkoutActiveSessionProvider
    extends $NotifierProvider<WorkoutActiveSession, WorkoutProgressEntry?> {
  /// The Workout tab's "continue where you left off" state — sourced from
  /// `CurrentUserProfile.activeWorkoutSession` (backend-persisted, syncs
  /// across devices), not local storage. Optimistic updates mirror
  /// `WorkoutListByLevel.toggleFavorite`: apply locally first, sync in the
  /// background, revert on failure.
  WorkoutActiveSessionProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'workoutActiveSessionProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$workoutActiveSessionHash();

  @$internal
  @override
  WorkoutActiveSession create() => WorkoutActiveSession();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(WorkoutProgressEntry? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<WorkoutProgressEntry?>(value),
    );
  }
}

String _$workoutActiveSessionHash() =>
    r'54da2a7e92f4cc894353f428107d9c74f72ed116';

/// The Workout tab's "continue where you left off" state — sourced from
/// `CurrentUserProfile.activeWorkoutSession` (backend-persisted, syncs
/// across devices), not local storage. Optimistic updates mirror
/// `WorkoutListByLevel.toggleFavorite`: apply locally first, sync in the
/// background, revert on failure.

abstract class _$WorkoutActiveSession extends $Notifier<WorkoutProgressEntry?> {
  WorkoutProgressEntry? build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<WorkoutProgressEntry?, WorkoutProgressEntry?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<WorkoutProgressEntry?, WorkoutProgressEntry?>,
              WorkoutProgressEntry?,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
