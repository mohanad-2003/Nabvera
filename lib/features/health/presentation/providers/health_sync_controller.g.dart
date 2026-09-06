// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'health_sync_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Orchestrates connecting to and syncing from the device's health store.
/// Never reads/writes anything if the user hasn't opted in — every path
/// here either starts from an explicit "Connect" tap or is a no-op when
/// `syncEnabled` is false (see [syncNow]).

@ProviderFor(HealthSyncController)
final healthSyncControllerProvider = HealthSyncControllerProvider._();

/// Orchestrates connecting to and syncing from the device's health store.
/// Never reads/writes anything if the user hasn't opted in — every path
/// here either starts from an explicit "Connect" tap or is a no-op when
/// `syncEnabled` is false (see [syncNow]).
final class HealthSyncControllerProvider
    extends $AsyncNotifierProvider<HealthSyncController, void> {
  /// Orchestrates connecting to and syncing from the device's health store.
  /// Never reads/writes anything if the user hasn't opted in — every path
  /// here either starts from an explicit "Connect" tap or is a no-op when
  /// `syncEnabled` is false (see [syncNow]).
  HealthSyncControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'healthSyncControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$healthSyncControllerHash();

  @$internal
  @override
  HealthSyncController create() => HealthSyncController();
}

String _$healthSyncControllerHash() =>
    r'2e33b7e039e84c61d7a1e0731b06d903feb8353d';

/// Orchestrates connecting to and syncing from the device's health store.
/// Never reads/writes anything if the user hasn't opted in — every path
/// here either starts from an explicit "Connect" tap or is a no-op when
/// `syncEnabled` is false (see [syncNow]).

abstract class _$HealthSyncController extends $AsyncNotifier<void> {
  FutureOr<void> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AsyncValue<void>, void>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<void>, void>,
              AsyncValue<void>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
