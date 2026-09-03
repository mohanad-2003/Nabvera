import 'dart:async';

import 'package:fitness_app/core/notifications/push_notification_service.dart';
import 'package:fitness_app/features/profile/data/user_repository.dart';
import 'package:fitness_app/features/profile/domain/profile_models.dart';
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
      if (state.id.isNotEmpty) {
        // Fire-and-forget: registering for push shouldn't block or fail
        // profile loading, and PushNotificationService is itself
        // idempotent past the first successful call.
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
