// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_routine_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(CreateRoutineController)
final createRoutineControllerProvider = CreateRoutineControllerProvider._();

final class CreateRoutineControllerProvider
    extends $NotifierProvider<CreateRoutineController, CreateRoutineState> {
  CreateRoutineControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'createRoutineControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$createRoutineControllerHash();

  @$internal
  @override
  CreateRoutineController create() => CreateRoutineController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(CreateRoutineState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<CreateRoutineState>(value),
    );
  }
}

String _$createRoutineControllerHash() =>
    r'b583898f7ebe5f31129566cafd5c259e9a50977a';

abstract class _$CreateRoutineController extends $Notifier<CreateRoutineState> {
  CreateRoutineState build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<CreateRoutineState, CreateRoutineState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<CreateRoutineState, CreateRoutineState>,
              CreateRoutineState,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
