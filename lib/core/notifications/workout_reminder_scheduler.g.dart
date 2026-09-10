// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'workout_reminder_scheduler.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(workoutReminderScheduler)
final workoutReminderSchedulerProvider = WorkoutReminderSchedulerProvider._();

final class WorkoutReminderSchedulerProvider
    extends
        $FunctionalProvider<
          WorkoutReminderScheduler,
          WorkoutReminderScheduler,
          WorkoutReminderScheduler
        >
    with $Provider<WorkoutReminderScheduler> {
  WorkoutReminderSchedulerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'workoutReminderSchedulerProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$workoutReminderSchedulerHash();

  @$internal
  @override
  $ProviderElement<WorkoutReminderScheduler> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  WorkoutReminderScheduler create(Ref ref) {
    return workoutReminderScheduler(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(WorkoutReminderScheduler value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<WorkoutReminderScheduler>(value),
    );
  }
}

String _$workoutReminderSchedulerHash() =>
    r'469942317afa5209bf3f8f3e2ae7e0a688b08561';
