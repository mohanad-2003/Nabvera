import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/network/api_client.dart';

part 'notification_repository.g.dart';

/// One cursor-paginated page of the inbox — mirrors the backend's
/// `{ data, unreadCount, pagination: { limit, hasMore, nextCursor } }`
/// shape (see `backend/src/controllers/notificationController.js`).
/// `unreadCount` is always the *true* total across every notification
/// this user has, independent of how many pages have been loaded so
/// far — never derive an unread badge from `items.length`.
class NotificationPage {
  const NotificationPage({
    required this.items,
    required this.unreadCount,
    required this.hasMore,
    required this.nextCursor,
  });

  final List<Map<String, dynamic>> items;
  final int unreadCount;
  final bool hasMore;
  final String? nextCursor;
}

/// Talks to `/api/notifications` (see
/// `backend/src/routes/notificationRoutes.js`).
class NotificationRepository {
  NotificationRepository(this._client);

  final ApiClient _client;

  /// Fetches one page, newest first. Pass [cursor] (a previous page's
  /// [NotificationPage.nextCursor]) to load the next one; omit it for the
  /// first page.
  Future<NotificationPage> fetchPage({String? cursor, int limit = 20}) async {
    final query = <String, String>{
      'limit': '$limit',
      if (cursor != null) 'cursor': cursor,
    };
    final path =
        '/notifications?${query.entries.map((e) => '${e.key}=${Uri.encodeQueryComponent(e.value)}').join('&')}';
    final response = await _client.get(path);
    final body = _client.decode(response);
    final pagination = body['pagination'] as Map<String, dynamic>;
    return NotificationPage(
      items: (body['data'] as List).cast<Map<String, dynamic>>(),
      unreadCount: (body['unreadCount'] as num).toInt(),
      hasMore: pagination['hasMore'] as bool,
      nextCursor: pagination['nextCursor'] as String?,
    );
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
