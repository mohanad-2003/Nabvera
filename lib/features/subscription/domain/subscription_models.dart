/// Mirrors backend `User.subscription` (see `backend/src/models/User.js`)
/// — a `'free' | 'monthly' | 'yearly'` string on the wire, never guessed
/// from a RevenueCat product id client-side.
enum SubscriptionTier {
  free,
  monthly,
  yearly;

  static SubscriptionTier fromApi(String? value) {
    switch (value) {
      case 'monthly':
        return SubscriptionTier.monthly;
      case 'yearly':
        return SubscriptionTier.yearly;
      default:
        return SubscriptionTier.free;
    }
  }
}

/// Mirrors backend `User.subscription.status`. `gracePeriod` means a
/// renewal charge failed and the store/RevenueCat is still retrying — the
/// user typically keeps access during this window, but it's worth
/// surfacing (e.g. "update your payment method") rather than treating it
/// identically to `active`.
enum SubscriptionStatus {
  active,
  gracePeriod,
  expired;

  static SubscriptionStatus fromApi(String? value) {
    switch (value) {
      case 'active':
        return SubscriptionStatus.active;
      case 'grace_period':
        return SubscriptionStatus.gracePeriod;
      default:
        return SubscriptionStatus.expired;
    }
  }
}

/// The backend-confirmed subscription state for the signed-in user — see
/// `SubscriptionRepository.fetchMySubscription`. Deliberately not read from
/// RevenueCat's own `CustomerInfo` for anything gating a feature: the
/// webhook that updates the backend can lag a few seconds behind a
/// purchase completing on-device, but the backend mirror is what every
/// server-side entitlement check actually trusts, so the app should agree
/// with it rather than a client-side value that might briefly disagree.
class SubscriptionInfo {
  const SubscriptionInfo({
    required this.tier,
    required this.status,
    required this.willRenew,
    this.productId,
    this.currentPeriodEndsAt,
  });

  final SubscriptionTier tier;
  final SubscriptionStatus status;
  final bool willRenew;
  final String? productId;
  final DateTime? currentPeriodEndsAt;

  /// True while a paid plan is entitled — including a cancelled
  /// (`willRenew == false`) plan that hasn't actually lapsed yet.
  bool get isActive =>
      tier != SubscriptionTier.free && status != SubscriptionStatus.expired;

  static const free = SubscriptionInfo(
    tier: SubscriptionTier.free,
    status: SubscriptionStatus.expired,
    willRenew: false,
  );

  factory SubscriptionInfo.fromJson(Map<String, dynamic> json) {
    final endsAt = json['currentPeriodEndsAt'] as String?;
    return SubscriptionInfo(
      tier: SubscriptionTier.fromApi(json['tier'] as String?),
      status: SubscriptionStatus.fromApi(json['status'] as String?),
      willRenew: json['willRenew'] as bool? ?? false,
      productId: json['productId'] as String?,
      currentPeriodEndsAt: endsAt == null ? null : DateTime.tryParse(endsAt),
    );
  }
}
