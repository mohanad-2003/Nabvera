import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/network/api_client.dart';

part 'notification_repository.g.dart';

/// Talks to `/api/notifications` (see
/// `backend/src/routes/notificationRoutes.js`).
class NotificationRepository {
  NotificationRepository(this._client);

  final ApiClient _client;

  Future<List<Map<String, dynamic>>> fetchAll() async {
    final response = await _client.get('/notifications');
    final body = _client.decode(response);
    return (body['data'] as List).cast<Map<String, dynamic>>();
  }

  Future<void> markAsRead(String id) async {
    _client.decode(await _client.patch('/notifications/$id/read'));
  }

  Future<void> markAllAsRead() async {
    _client.decode(await _client.patch('/notifications/read-all'));
  }

  Future<void> delete(String id) async {
    _client.decode(await _client.delete('/notifications/$id'));
  }
}

@Riverpod(keepAlive: true)
NotificationRepository notificationRepository(Ref ref) {
  return NotificationRepository(ref.watch(apiClientProvider));
}
