import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/network/api_client.dart';

part 'home_repository.g.dart';

/// Talks to `/api/articles` (see `backend/src/routes/articleRoutes.js`) —
/// the Home screen's "Articles & Tips" content.
class HomeRepository {
  HomeRepository(this._client);

  final ApiClient _client;

  Future<List<Map<String, dynamic>>> fetchArticles() async {
    final response = await _client.get('/articles');
    final body = _client.decode(response);
    return (body['data'] as List).cast<Map<String, dynamic>>();
  }
}

@Riverpod(keepAlive: true)
HomeRepository homeRepository(Ref ref) {
  return HomeRepository(ref.watch(apiClientProvider));
}
