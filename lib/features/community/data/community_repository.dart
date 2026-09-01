import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/network/api_client.dart';

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
