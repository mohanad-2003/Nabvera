// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'revenue_cat_service.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(revenueCatService)
final revenueCatServiceProvider = RevenueCatServiceProvider._();

final class RevenueCatServiceProvider
    extends
        $FunctionalProvider<
          RevenueCatService,
          RevenueCatService,
          RevenueCatService
        >
    with $Provider<RevenueCatService> {
  RevenueCatServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'revenueCatServiceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$revenueCatServiceHash();

  @$internal
  @override
  $ProviderElement<RevenueCatService> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  RevenueCatService create(Ref ref) {
    return revenueCatService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(RevenueCatService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<RevenueCatService>(value),
    );
  }
}

String _$revenueCatServiceHash() => r'bb2b55f3f17ff5332ef5dd58cf69cf6692564935';
