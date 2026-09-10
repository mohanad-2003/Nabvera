// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'health_preferences_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Loads and saves `/api/health/preferences`. An [AsyncNotifier] so the
/// Health Data Settings screen shows a real loading/error state.

@ProviderFor(HealthPreferencesController)
final healthPreferencesControllerProvider =
    HealthPreferencesControllerProvider._();

/// Loads and saves `/api/health/preferences`. An [AsyncNotifier] so the
/// Health Data Settings screen shows a real loading/error state.
final class HealthPreferencesControllerProvider
    extends
        $AsyncNotifierProvider<HealthPreferencesController, HealthPreferences> {
  /// Loads and saves `/api/health/preferences`. An [AsyncNotifier] so the
  /// Health Data Settings screen shows a real loading/error state.
  HealthPreferencesControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'healthPreferencesControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$healthPreferencesControllerHash();

  @$internal
  @override
  HealthPreferencesController create() => HealthPreferencesController();
}

String _$healthPreferencesControllerHash() =>
    r'f6a4433d2b5f03726097790aa52655e5c3294d6f';

/// Loads and saves `/api/health/preferences`. An [AsyncNotifier] so the
/// Health Data Settings screen shows a real loading/error state.

abstract class _$HealthPreferencesController
    extends $AsyncNotifier<HealthPreferences> {
  FutureOr<HealthPreferences> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref =
        this.ref as $Ref<AsyncValue<HealthPreferences>, HealthPreferences>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<HealthPreferences>, HealthPreferences>,
              AsyncValue<HealthPreferences>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
