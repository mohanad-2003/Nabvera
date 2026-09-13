import 'package:nabvera/features/subscription/data/subscription_repository.dart';
import 'package:nabvera/features/subscription/domain/subscription_models.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'subscription_providers.g.dart';

/// The paywall's available packages (monthly/yearly), fetched fresh each
/// time the paywall opens.
@riverpod
Future<Offerings> offerings(Ref ref) {
  return ref.watch(subscriptionRepositoryProvider).fetchOfferings();
}

/// The backend-confirmed subscription state for the signed-in user — see
/// [SubscriptionRepository] for why this is trusted over RevenueCat's own
/// `CustomerInfo`. Gate premium UI on `state.value?.isActive`, not on
/// anything read straight from the RevenueCat SDK.
@riverpod
class SubscriptionStatus extends _$SubscriptionStatus {
  @override
  Future<SubscriptionInfo> build() {
    return ref.watch(subscriptionRepositoryProvider).fetchMySubscription();
  }

  /// Call right after a purchase/restore completes on the paywall. The
  /// webhook that updates the backend usually lands within a few seconds
  /// but is not synchronous with the purchase call returning, so a caller
  /// that needs to reflect the new plan immediately should still trust
  /// this refreshed value, not the raw purchase result.
  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(
      () => ref.read(subscriptionRepositoryProvider).fetchMySubscription(),
    );
  }
}
