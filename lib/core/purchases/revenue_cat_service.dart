import 'dart:io' show Platform;

import 'package:flutter/foundation.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'revenue_cat_service.g.dart';

/// RevenueCat's public (client-facing) SDK keys — safe to ship in the app
/// binary, unlike a secret key. Each store needs its own: RevenueCat
/// dashboard → Project settings → API keys → "Apple App Store" /
/// "Google Play Store".
///
/// Overridable with `--dart-define=REVENUECAT_IOS_API_KEY=...` /
/// `--dart-define=REVENUECAT_ANDROID_API_KEY=...`, matching how
/// `API_BASE_URL` is overridden in `core/network/api_client.dart`. Left
/// empty, [RevenueCatService.initializeIfNeeded] no-ops rather than
/// crashing the app on a build that hasn't been given real keys yet.
const _iosApiKey = String.fromEnvironment('REVENUECAT_IOS_API_KEY');
const _androidApiKey = String.fromEnvironment('REVENUECAT_ANDROID_API_KEY');

/// Owns the RevenueCat SDK's lifecycle: configuring it once per process,
/// and keeping its logged-in `app_user_id` in sync with whichever Firebase
/// account is signed in. That id is what ties a purchase back to a Mongo
/// user — see `backend/src/services/subscriptionService.js`, which matches
/// an incoming webhook's `app_user_id` against `User.firebaseUid`.
///
/// Mirrors `PushNotificationService`'s shape on purpose (best-effort,
/// idempotent `initializeIfNeeded`) — a paywall/subscription-status screen
/// failing to load isn't allowed to take the rest of the app down with it.
class RevenueCatService {
  bool _configured = false;
  String? _loggedInFirebaseUid;

  /// Call once a signed-in Firebase uid is available (see
  /// `CurrentUserProfile.refresh`/`refreshAfterSignIn`) and again on every
  /// subsequent sign-in — cheap and safe to call repeatedly; only the
  /// first call configures the SDK, and logging in again with the same uid
  /// is a no-op inside the SDK itself.
  Future<void> initializeIfNeeded(String firebaseUid) async {
    // No web billing key is configured yet — `Platform.isIOS` itself
    // throws `UnsupportedError` on web (there's no such platform), so this
    // must be checked before it, not just the key being empty.
    if (kIsWeb) return;
    final apiKey = Platform.isIOS ? _iosApiKey : _androidApiKey;
    if (apiKey.isEmpty) {
      // No key configured for this build (e.g. local dev without
      // --dart-define set) — subscriptions simply aren't available rather
      // than crashing.
      return;
    }

    try {
      if (!_configured) {
        _configured = true;
        await Purchases.setLogLevel(
          kReleaseMode ? LogLevel.error : LogLevel.debug,
        );
        await Purchases.configure(PurchasesConfiguration(apiKey));
      }

      if (_loggedInFirebaseUid == firebaseUid) return;
      await Purchases.logIn(firebaseUid);
      _loggedInFirebaseUid = firebaseUid;
    } catch (error) {
      debugPrint('RevenueCat setup failed: $error');
    }
  }

  /// Call on sign-out so a shared/reused device doesn't keep RevenueCat
  /// pointed at the account that just signed out — resets the SDK back to
  /// a fresh anonymous id, matching `Purchases.logOut`'s own contract.
  Future<void> signOut() async {
    if (_loggedInFirebaseUid == null) return;
    _loggedInFirebaseUid = null;
    try {
      await Purchases.logOut();
    } catch (error) {
      debugPrint('RevenueCat sign-out failed: $error');
    }
  }
}

@Riverpod(keepAlive: true)
RevenueCatService revenueCatService(Ref ref) {
  return RevenueCatService();
}
