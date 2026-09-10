import 'dart:async';

import 'package:nabvera/core/notifications/push_notification_service.dart';
import 'package:nabvera/core/storage/preferences_service.dart';
import 'package:nabvera/features/profile/data/user_repository.dart';
import 'package:nabvera/features/profile/domain/profile_models.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'profile_controller.g.dart';

/// Loads the signed-in user's profile from the backend on first read.
/// Exposes a plain [UserProfile] (not `AsyncValue`) so every existing
/// consumer keeps working unchanged: it starts as [UserProfile.empty] and
/// swaps in the real data — or stays empty on failure — once the fetch
/// resolves, notifying listeners like any other state change.
///
/// `keepAlive: true` is load-bearing, not just an optimization: this is
/// also where `adminRouteGuard` reads `role` from on every navigation
/// (see `app_router.dart`). Left as the default autoDispose, this provider
/// would tear itself down the moment nothing currently on screen watches
/// it (e.g. switching between Admin console tabs, none of which watch
/// profile) and reset to `UserProfile.empty` — an admin's own `role` would
/// momentarily read back as `'user'` mid-navigation and the guard would
/// wrongly bounce them to the unauthorized page.
@Riverpod(keepAlive: true)
class CurrentUserProfile extends _$CurrentUserProfile {
  @override
  UserProfile build() {
    Future.microtask(refresh);
    return UserProfile.empty;
  }

  Future<void> refresh() async {
    try {
      state = await ref.read(userRepositoryProvider).fetchMe();
      final notificationsEnabled =
          ref.read(preferencesServiceProvider).notificationsEnabled;
      if (state.id.isNotEmpty && notificationsEnabled) {
        // Fire-and-forget: registering for push shouldn't block or fail
        // profile loading, and PushNotificationService is itself
        // idempotent past the first successful call. Skipped entirely
        // when the user has turned the "General Notification" toggle off
        // (see NotificationSettingsPage) — otherwise a fresh app launch
        // would silently re-register the device regardless of that choice.
        unawaited(
          ref.read(pushNotificationServiceProvider).initializeIfNeeded(),
        );
      }
    } catch (_) {
      // Left at the previous (or empty) state — pages render their empty
      // placeholders rather than crashing when the backend is unreachable.
    }
  }

  Future<void> update(Map<String, dynamic> patch) async {
    state = await ref.read(userRepositoryProvider).updateProfile(patch);
  }

  /// Same as [refresh], but meant to be called right after a fresh sign-in
  /// (see `LoginController`/`SignupController`) — retries once, after a
  /// short delay, if the first attempt comes back empty.
  ///
  /// Why this can happen right after `signInWithEmailAndPassword` (rarer,
  /// seemingly, after `signInWithGoogle` — consistent with a genuine
  /// timing race rather than a deterministic bug): `ApiClient` attaches
  /// `Authorization` from `FirebaseAuth.currentUser?.getIdToken()`, and
  /// there's a narrow window right after sign-in where the Future has
  /// already resolved but `currentUser` hasn't propagated to that getter
  /// yet — the very first `/auth/me` call goes out with *no* Authorization
  /// header at all in that window. That's not the same failure
  /// `ApiClient`'s own 401-retry-with-forceRefresh exists for (a *stale*
  /// token, not a *missing* one), so it doesn't help here: both the
  /// original attempt and the retry go out tokenless, `refresh()`'s
  /// internal catch swallows the resulting error, and the profile is left
  /// at [UserProfile.empty] — indistinguishable, from the caller's side,
  /// from a brand new account that genuinely has no data yet.
  Future<void> refreshAfterSignIn() async {
    await refresh();
    if (state.id.isNotEmpty) return;
    await Future<void>.delayed(const Duration(milliseconds: 400));
    await refresh();
  }
}

@riverpod
List<DocumentItem> userDocuments(Ref ref) => const [
  DocumentItem(
    title: 'Document 1',
    description: 'Description or details of document 1',
  ),
  DocumentItem(
    title: 'Document 2',
    description: 'Description or details of document 2',
  ),
  DocumentItem(
    title: 'Document 3',
    description: 'Description or details of document 3',
  ),
  DocumentItem(
    title: 'Document 4',
    description: 'Description or details of document 4',
  ),
  DocumentItem(
    title: 'Document 5',
    description: 'Description or details of document 5',
  ),
];
