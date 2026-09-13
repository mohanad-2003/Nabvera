import 'package:nabvera/core/network/api_client.dart';
import 'package:nabvera/features/subscription/domain/subscription_models.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'subscription_repository.g.dart';

/// Fronts two different sources on purpose: RevenueCat's SDK directly for
/// the paywall itself (offerings, purchase, restore — these need no
/// backend round trip and RevenueCat is the one source of truth for store
/// pricing/availability), and `/api/users/me/subscription` for the
/// backend's mirrored entitlement state (see `backend/src/models/User.js`
/// `subscription` and `backend/src/services/subscriptionService.js`) — the
/// backend mirror is what server-side feature-gating actually trusts, so
/// it's what the app should trust too rather than reading RevenueCat's own
/// `CustomerInfo`, which can be briefly ahead of the webhook that updates
/// the backend.
///
/// Callers must have already run `Purchases.configure(...)` and
/// `Purchases.logIn(firebaseUid)` once at app startup/sign-in — this class
/// does neither; see the app's auth bootstrap for where that belongs.
class SubscriptionRepository {
  SubscriptionRepository(this._client);

  final ApiClient _client;

  /// The paywall's available packages (monthly/yearly). RevenueCat caches
  /// this locally, so calling it fresh each time the paywall opens is
  /// cheap.
  Future<Offerings> fetchOfferings() => Purchases.getOfferings();

  Future<CustomerInfo> purchasePackage(Package package) async {
    final result = await Purchases.purchase(PurchaseParams.package(package));
    return result.customerInfo;
  }

  Future<CustomerInfo> restorePurchases() => Purchases.restorePurchases();

  /// The backend-confirmed state. Call again shortly after a purchase or
  /// restore completes — the RevenueCat webhook that updates the backend
  /// is not synchronous with the purchase call returning.
  Future<SubscriptionInfo> fetchMySubscription() async {
    final response = await _client.get('/users/me/subscription');
    final body = _client.decode(response);
    return SubscriptionInfo.fromJson(body['data'] as Map<String, dynamic>);
  }
}

@Riverpod(keepAlive: true)
SubscriptionRepository subscriptionRepository(Ref ref) {
  return SubscriptionRepository(ref.watch(apiClientProvider));
}
