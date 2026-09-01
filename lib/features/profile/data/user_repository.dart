import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/network/api_client.dart';
import '../domain/profile_models.dart';

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

  Future<UserProfile> setBiometricEnabled(bool enabled) async {
    final response = await _client.patch(
      '/users/me/biometric',
      body: {'enabled': enabled},
    );
    final body = _client.decode(response);
    return UserProfile.fromJson(body['data'] as Map<String, dynamic>);
  }

  Future<List<String>> toggleFavoriteWorkout(String workoutId) async {
    final response = await _client.post('/users/me/favorites/workouts/$workoutId');
    final body = _client.decode(response);
    return (body['data'] as List).map((e) => e.toString()).toList();
  }

  Future<List<String>> toggleFavoriteRecipe(String recipeId) async {
    final response = await _client.post('/users/me/favorites/recipes/$recipeId');
    final body = _client.decode(response);
    return (body['data'] as List).map((e) => e.toString()).toList();
  }
}

@Riverpod(keepAlive: true)
UserRepository userRepository(Ref ref) {
  return UserRepository(ref.watch(apiClientProvider));
}
