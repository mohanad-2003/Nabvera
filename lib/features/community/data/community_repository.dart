import 'package:nabvera/core/network/api_client.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'community_repository.g.dart';

/// Talks to `/api/posts` (see `backend/src/routes/postRoutes.js`).
class CommunityRepository {
  CommunityRepository(this._client);

  final ApiClient _client;

  Future<List<Map<String, dynamic>>> fetchChallenges() async {
    final response = await _client.get('/challenges');
    final body = _client.decode(response);
    return (body['data'] as List).cast<Map<String, dynamic>>();
  }

  /// Challenges the current user hasn't joined yet (`/challenges/available`).
  Future<List<Map<String, dynamic>>> fetchAvailableChallenges() async {
    final response = await _client.get('/challenges/available');
    final body = _client.decode(response);
    return (body['data'] as List).cast<Map<String, dynamic>>();
  }

  /// The current user's `ChallengeProgress` documents (`/challenges/my`),
  /// each carrying the populated `Challenge` alongside its status.
  Future<List<Map<String, dynamic>>> fetchMyChallenges() async {
    final response = await _client.get('/challenges/my');
    final body = _client.decode(response);
    return (body['data'] as List).cast<Map<String, dynamic>>();
  }

  /// Up to two rule-based `{ challenge, reasonCode }` suggestions
  /// (`/challenges/suggested`).
  Future<List<Map<String, dynamic>>> fetchSuggestedChallenges() async {
    final response = await _client.get('/challenges/suggested');
    final body = _client.decode(response);
    return (body['data'] as List).cast<Map<String, dynamic>>();
  }

  /// Joins (or resets, after leaving/expiring) progress on a challenge.
  Future<Map<String, dynamic>> joinChallenge(String challengeId) async {
    final response = await _client.post('/challenges/$challengeId/join');
    final body = _client.decode(response);
    return body['data'] as Map<String, dynamic>;
  }

  /// Leaves a challenge the user is actively working on.
  Future<Map<String, dynamic>> leaveChallenge(String challengeId) async {
    final response = await _client.post('/challenges/$challengeId/leave');
    final body = _client.decode(response);
    return body['data'] as Map<String, dynamic>;
  }

  /// The user's progress on a single challenge (`/challenges/:id/progress`).
  Future<Map<String, dynamic>> fetchChallengeProgress(
    String challengeId,
  ) async {
    final response = await _client.get('/challenges/$challengeId/progress');
    final body = _client.decode(response);
    return body['data'] as Map<String, dynamic>;
  }

  Future<List<Map<String, dynamic>>> fetchFeed() async {
    final response = await _client.get('/posts');
    final body = _client.decode(response);
    return (body['data'] as List).cast<Map<String, dynamic>>();
  }

  Future<List<Map<String, dynamic>>> fetchComments(String postId) async {
    final response = await _client.get('/posts/$postId/comments');
    final body = _client.decode(response);
    return (body['data'] as List).cast<Map<String, dynamic>>();
  }

  Future<Map<String, dynamic>> addComment(String postId, String text) async {
    final response = await _client.post(
      '/posts/$postId/comments',
      body: {'text': text},
    );
    final body = _client.decode(response);
    return body['data'] as Map<String, dynamic>;
  }

  /// Returns `(likesCount, liked)` after toggling.
  Future<(int, bool)> toggleLike(String postId) async {
    final response = await _client.post('/posts/$postId/like');
    final body = _client.decode(response);
    final data = body['data'] as Map<String, dynamic>;
    return (data['likesCount'] as int, data['liked'] as bool);
  }
}

@Riverpod(keepAlive: true)
CommunityRepository communityRepository(Ref ref) {
  return CommunityRepository(ref.watch(apiClientProvider));
}
