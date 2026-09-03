import 'package:fitness_app/features/notification/presentation/providers/notification_controller.dart';
import 'package:fitness_app/features/profile/data/user_repository.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'push_notification_service.g.dart';

/// Registers this device for push notifications and keeps the in-app
/// inbox current while the app is open. This is the only place
/// `firebase_messaging` is touched — everything else in the app talks to
/// notifications through the existing `/api/notifications` REST endpoints.
///
/// Best-effort throughout: a user who denies the permission prompt, or a
/// device where FCM setup fails for any reason, still gets the in-app
/// inbox (see `NotificationListController`) — push is additive, never a
/// requirement for the rest of the feature to work.
class PushNotificationService {
  PushNotificationService(this._ref, this._userRepository);

  final Ref _ref;
  final UserRepository _userRepository;

  bool _initialized = false;
  String? _registeredToken;

  /// Call once a real signed-in profile is available (see
  /// `CurrentUserProfile`). Safe to call more than once — only the first
  /// call after a cold start actually does anything.
  Future<void> initializeIfNeeded() async {
    if (_initialized) return;
    _initialized = true;

    try {
      final messaging = FirebaseMessaging.instance;
      final settings = await messaging.requestPermission();
      if (settings.authorizationStatus == AuthorizationStatus.denied) {
        return;
      }

      final token = await messaging.getToken();
      if (token != null) await _registerToken(token);

      messaging.onTokenRefresh.listen(_registerToken);

      // Foreground messages don't show a system banner on their own (no
      // local-notifications plugin in this app) — refreshing the inbox
      // list is the honest thing to do instead of pretending a heads-up
      // notification appeared.
      FirebaseMessaging.onMessage.listen((_) {
        _ref.read(notificationListControllerProvider.notifier).refresh();
      });
    } catch (error) {
      // Missing platform config, permission plumbing issues, etc. — the
      // in-app inbox still works without push.
      debugPrint('Push notification setup failed: $error');
    }
  }

  Future<void> _registerToken(String token) async {
    if (token == _registeredToken) return;
    try {
      await _userRepository.registerFcmToken(token);
      _registeredToken = token;
    } catch (error) {
      debugPrint('Registering FCM token failed: $error');
    }
  }

  /// Called on sign-out so a shared/reused device doesn't keep receiving
  /// pushes meant for the account that just signed out.
  Future<void> unregisterCurrentDevice() async {
    final token = _registeredToken;
    if (token == null) return;
    _registeredToken = null;
    _initialized = false;
    try {
      await _userRepository.unregisterFcmToken(token);
    } catch (error) {
      debugPrint('Unregistering FCM token failed: $error');
    }
  }
}

@Riverpod(keepAlive: true)
PushNotificationService pushNotificationService(Ref ref) {
  return PushNotificationService(ref, ref.watch(userRepositoryProvider));
}
