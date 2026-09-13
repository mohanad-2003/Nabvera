// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'subscription_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// The paywall's available packages (monthly/yearly), fetched fresh each
/// time the paywall opens.

@ProviderFor(offerings)
final offeringsProvider = OfferingsProvider._();

/// The paywall's available packages (monthly/yearly), fetched fresh each
/// time the paywall opens.

final class OfferingsProvider
    extends
        $FunctionalProvider<
          AsyncValue<Offerings>,
          Offerings,
          FutureOr<Offerings>
        >
    with $FutureModifier<Offerings>, $FutureProvider<Offerings> {
  /// The paywall's available packages (monthly/yearly), fetched fresh each
  /// time the paywall opens.
  OfferingsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'offeringsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$offeringsHash();

  @$internal
  @override
  $FutureProviderElement<Offerings> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<Offerings> create(Ref ref) {
    return offerings(ref);
  }
}

String _$offeringsHash() => r'a80f5d7cc0092681a73ffe9ce2c5d7a2ee113e4c';

/// The backend-confirmed subscription state for the signed-in user — see
/// [SubscriptionRepository] for why this is trusted over RevenueCat's own
/// `CustomerInfo`. Gate premium UI on `state.value?.isActive`, not on
/// anything read straight from the RevenueCat SDK.

@ProviderFor(SubscriptionStatus)
final subscriptionStatusProvider = SubscriptionStatusProvider._();

/// The backend-confirmed subscription state for the signed-in user — see
/// [SubscriptionRepository] for why this is trusted over RevenueCat's own
/// `CustomerInfo`. Gate premium UI on `state.value?.isActive`, not on
/// anything read straight from the RevenueCat SDK.
final class SubscriptionStatusProvider
    extends $AsyncNotifierProvider<SubscriptionStatus, SubscriptionInfo> {
  /// The backend-confirmed subscription state for the signed-in user — see
  /// [SubscriptionRepository] for why this is trusted over RevenueCat's own
  /// `CustomerInfo`. Gate premium UI on `state.value?.isActive`, not on
  /// anything read straight from the RevenueCat SDK.
  SubscriptionStatusProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'subscriptionStatusProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$subscriptionStatusHash();

  @$internal
  @override
  SubscriptionStatus create() => SubscriptionStatus();
}

String _$subscriptionStatusHash() =>
    r'762ccf51436a9b2f7d0497f035de9f7014cf7ef6';

/// The backend-confirmed subscription state for the signed-in user — see
/// [SubscriptionRepository] for why this is trusted over RevenueCat's own
/// `CustomerInfo`. Gate premium UI on `state.value?.isActive`, not on
/// anything read straight from the RevenueCat SDK.

abstract class _$SubscriptionStatus extends $AsyncNotifier<SubscriptionInfo> {
  FutureOr<SubscriptionInfo> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref =
        this.ref as $Ref<AsyncValue<SubscriptionInfo>, SubscriptionInfo>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<SubscriptionInfo>, SubscriptionInfo>,
              AsyncValue<SubscriptionInfo>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
