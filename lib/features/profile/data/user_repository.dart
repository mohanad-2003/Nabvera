import 'dart:typed_data';

import 'package:nabvera/core/network/api_client.dart';
import 'package:nabvera/features/profile/domain/profile_models.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'user_repository.g.dart';

/// Talks to `/api/auth/me` and `/api/users/me` (see
/// `backend/src/routes/authRoutes.js` and `userRoutes.js`).
class UserRepository {
  UserRepository(this._client);

  final ApiClient _client;

  Future<UserProfile> fetchMe() async {
    final response = await _client.get('/auth/me');
    final body = _client.decode(response);
    return UserProfile.fromJson(body['data'] as Map<String, dynamic>);
  }

  Future<UserProfile> updateProfile(Map<String, dynamic> patch) async {
    final response = await _client.patch('/users/me', body: patch);
    final body = _client.decode(response);
    return UserProfile.fromJson(body['data'] as Map<String, dynamic>);
  }

  /// Uploads an avatar first, then lets the caller persist its returned URL
  /// with the regular profile PATCH endpoint. Pass the picker's own
  /// `XFile.mimeType` as [contentType] when available — see
  /// [ApiClient.uploadImage]'s doc comment for why this matters.
  Future<String> uploadAvatar({
    required Uint8List bytes,
    required String filename,
    String? contentType,
  }) async {
    final response = await _client.uploadImage(
      '/uploads',
      bytes: bytes,
      filename: filename,
      contentType: contentType,
    );
    final body = _client.decode(response);
    final path = (body['data'] as Map<String, dynamic>)['url'] as String;
    return resolveBackendUrl(path);
  }

  Future<UserProfile> setBiometricEnabled(bool enabled) async {
    final response = await _client.patch(
      '/users/me/biometric',
      body: {'enabled': enabled},
    );
    final body = _client.decode(response);
    return UserProfile.fromJson(body['data'] as Map<String, dynamic>);
  }

  Future<List<String>> toggleFavoriteWorkout(String workoutId) async {
    final response = await _client.post(
      '/users/me/favorites/workouts/$workoutId',
    );
    final body = _client.decode(response);
    return (body['data'] as List).map((e) => e.toString()).toList();
  }

  Future<List<String>> toggleFavoriteRecipe(String recipeId) async {
    final response = await _client.post(
      '/users/me/favorites/recipes/$recipeId',
    );
    final body = _client.decode(response);
    return (body['data'] as List).map((e) => e.toString()).toList();
  }

  /// Overwrites the current user's single "continue where you left off"
  /// entry — real completed/total set counts from `CategoryDetailPage`,
  /// never a fabricated percentage. See `WorkoutActiveSession`.
  Future<void> setActiveWorkoutSession({
    required String workoutId,
    required String title,
    required String titleAr,
    required String image,
    required int completedSets,
    required int totalSets,
  }) async {
    await _client.patch(
      '/users/me/active-workout-session',
      body: {
        'workoutId': workoutId,
        'title': title,
        'titleAr': titleAr,
        'image': image,
        'completedSets': completedSets,
        'totalSets': totalSets,
      },
    );
  }

  /// Clears the active workout session — a finished session, or one undone
  /// back to zero completed sets, has nothing left to "continue".
  Future<void> clearActiveWorkoutSession() async {
    await _client.delete('/users/me/active-workout-session');
  }

  /// Registers this device for push notifications (see
  /// `PushNotificationService`). Safe to call repeatedly with the same
  /// token — the backend de-dupes.
  Future<void> registerFcmToken(String token) async {
    await _client.post('/users/me/fcm-token', body: {'token': token});
  }

  /// Removes this device's token — call on sign-out so a shared/reused
  /// device doesn't keep receiving another account's pushes.
  Future<void> unregisterFcmToken(String token) async {
    await _client.delete('/users/me/fcm-token', body: {'token': token});
  }

  /// Permanently deletes the current user's account and every piece of
  /// data they own (see `backend/src/services/accountDeletionService.js`)
  /// — irreversible. Throws [ApiException] (503) if deletion couldn't be
  /// confirmed, in which case nothing was deleted; the caller must not
  /// treat that as success.
  Future<void> deleteAccount() async {
    final response = await _client.delete('/users/me');
    _client.decode(response);
  }

  /// Every piece of data this user owns — the read-only "right to access"
  /// counterpart to [deleteAccount] (see `GET /api/users/me/export` /
  /// `backend/src/controllers/userController.js`'s `exportMyData`). Returns
  /// the raw JSON so the caller can hand it straight to a file/share sheet
  /// without this layer guessing what to do with it.
  Future<Map<String, dynamic>> exportData() async {
    final response = await _client.get(
      '/users/me/export',
      // The default 15s timeout is tuned for small JSON payloads — an
      // export aggregates across every collection a long-time user owns,
      // so it can legitimately take longer.
      timeout: const Duration(seconds: 45),
    );
    final body = _client.decode(response);
    return body['data'] as Map<String, dynamic>;
  }
}

@Riverpod(keepAlive: true)
UserRepository userRepository(Ref ref) {
  return UserRepository(ref.watch(apiClientProvider));
}
