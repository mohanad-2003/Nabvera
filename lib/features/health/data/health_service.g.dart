// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'health_service.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(healthService)
final healthServiceProvider = HealthServiceProvider._();

final class HealthServiceProvider
    extends $FunctionalProvider<HealthService, HealthService, HealthService>
    with $Provider<HealthService> {
  HealthServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'healthServiceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$healthServiceHash();

  @$internal
  @override
  $ProviderElement<HealthService> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  HealthService create(Ref ref) {
    return healthService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(HealthService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<HealthService>(value),
    );
  }
}

String _$healthServiceHash() => r'211455d3a10ff432450c1a0d739cd9d7765896b4';
