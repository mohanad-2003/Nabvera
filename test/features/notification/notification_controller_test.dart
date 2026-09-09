import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nabvera/features/notification/data/notification_repository.dart';
import 'package:nabvera/features/notification/presentation/providers/notification_controller.dart';

class FakeNotificationRepository implements NotificationRepository {
  /// Pages keyed by the cursor that requests them — `null` is the first
  /// page. Lets a test script out exactly what each `fetchPage` call
  /// should return, same shape the real backend would.
  Map<String?, NotificationPage> pages = {};
  int markAllAsReadCalls = 0;
  final List<String> markAsReadCalls = [];
  final List<String> deleteCalls = [];
  Object? throwOnFetch;

  @override
  Future<NotificationPage> fetchPage({String? cursor, int limit = 20}) async {
    if (throwOnFetch != null) throw throwOnFetch!;
    final page = pages[cursor];
    if (page == null) {
      throw StateError('FakeNotificationRepository: no page stubbed for cursor "$cursor"');
    }
    return page;
  }

  @override
  Future<void> markAsRead(String id) async => markAsReadCalls.add(id);

  @override
  Future<void> markAllAsRead() async => markAllAsReadCalls++;

  @override
  Future<void> delete(String id) async => deleteCalls.add(id);
}

Map<String, dynamic> _notif(String id, {bool isRead = false, String createdAt = '2026-01-15T10:00:00.000Z'}) => {
  '_id': id,
  'type': 'system',
  'title': 'Title $id',
  'body': 'Body $id',
  'isRead': isRead,
  'createdAt': createdAt,
  'data': {},
};

void main() {
  test('first load: populates the list and inbox meta (unreadCount/hasMore) from the server response', () async {
    final fake = FakeNotificationRepository()
      ..pages = {
        null: const NotificationPage(
          items: [],
          unreadCount: 0,
          hasMore: false,
          nextCursor: null,
        ),
      };
    fake.pages[null] = NotificationPage(
      items: [_notif('n1', isRead: false), _notif('n2', isRead: true)],
      unreadCount: 7, // deliberately not derivable from the 2 loaded items
      hasMore: true,
      nextCursor: 'cursor-1',
    );

    final container = ProviderContainer(
      overrides: [notificationRepositoryProvider.overrideWithValue(fake)],
    );
    addTearDown(container.dispose);
    container.listen(notificationListControllerProvider, (_, _) {});
    await Future<void>.delayed(Duration.zero);

    final items = container.read(notificationListControllerProvider);
    expect(items, hasLength(2));
    expect(items.map((i) => i.id), ['n1', 'n2']);

    final meta = container.read(notificationInboxMetaControllerProvider);
    expect(meta.unreadCount, 7, reason: 'must come from the server, not be derived from the 2 loaded items');
    expect(meta.hasMore, isTrue);
    expect(meta.nextCursor, 'cursor-1');

    // unreadNotificationCountProvider (read by the badge elsewhere in the
    // app) must reflect the same server-provided total.
    expect(container.read(unreadNotificationCountProvider), 7);
  });

  test('loadMore: appends the next page rather than replacing the first one', () async {
    final fake = FakeNotificationRepository()
      ..pages = {
        null: NotificationPage(
          items: [_notif('n1'), _notif('n2')],
          unreadCount: 10,
          hasMore: true,
          nextCursor: 'cursor-1',
        ),
        'cursor-1': NotificationPage(
          items: [_notif('n3'), _notif('n4')],
          unreadCount: 10,
          hasMore: false,
          nextCursor: null,
        ),
      };

    final container = ProviderContainer(
      overrides: [notificationRepositoryProvider.overrideWithValue(fake)],
    );
    addTearDown(container.dispose);
    container.listen(notificationListControllerProvider, (_, _) {});
    await Future<void>.delayed(Duration.zero);

    await container
        .read(notificationListControllerProvider.notifier)
        .loadMore();

    final items = container.read(notificationListControllerProvider);
    expect(items.map((i) => i.id), ['n1', 'n2', 'n3', 'n4'], reason: 'page 1 items must still be present');

    final meta = container.read(notificationInboxMetaControllerProvider);
    expect(meta.hasMore, isFalse);
    expect(meta.nextCursor, isNull);
  });

  test('loadMore: a no-op when hasMore is already false (never calls fetchPage again)', () async {
    final fake = FakeNotificationRepository()
      ..pages = {
        null: NotificationPage(
          items: [_notif('n1')],
          unreadCount: 0,
          hasMore: false,
          nextCursor: null,
        ),
      };

    final container = ProviderContainer(
      overrides: [notificationRepositoryProvider.overrideWithValue(fake)],
    );
    addTearDown(container.dispose);
    container.listen(notificationListControllerProvider, (_, _) {});
    await Future<void>.delayed(Duration.zero);

    // No page stubbed for any cursor other than null — if loadMore
    // called fetchPage again it would throw and this test would fail.
    await container
        .read(notificationListControllerProvider.notifier)
        .loadMore();

    expect(container.read(notificationListControllerProvider), hasLength(1));
  });

  test('an empty inbox loads to an empty list with hasMore=false and unreadCount=0', () async {
    final fake = FakeNotificationRepository()
      ..pages = {
        null: const NotificationPage(items: [], unreadCount: 0, hasMore: false, nextCursor: null),
      };

    final container = ProviderContainer(
      overrides: [notificationRepositoryProvider.overrideWithValue(fake)],
    );
    addTearDown(container.dispose);
    container.listen(notificationListControllerProvider, (_, _) {});
    await Future<void>.delayed(Duration.zero);

    expect(container.read(notificationListControllerProvider), isEmpty);
    expect(container.read(unreadNotificationCountProvider), 0);
  });

  test(
    'markAllAsRead: clears the badge locally immediately and calls the backend once — '
    'the backend itself is what scopes this to every notification, not just loaded pages',
    () async {
      final fake = FakeNotificationRepository()
        ..pages = {
          null: NotificationPage(
            items: [_notif('n1', isRead: false), _notif('n2', isRead: false)],
            unreadCount: 12,
            hasMore: true,
            nextCursor: 'cursor-1',
          ),
        };

      final container = ProviderContainer(
        overrides: [notificationRepositoryProvider.overrideWithValue(fake)],
      );
      addTearDown(container.dispose);
      container.listen(notificationListControllerProvider, (_, _) {});
      await Future<void>.delayed(Duration.zero);

      container.read(notificationListControllerProvider.notifier).markAllAsRead();

      expect(
        container.read(notificationListControllerProvider).every((i) => i.isRead),
        isTrue,
      );
      expect(container.read(unreadNotificationCountProvider), 0);
      expect(fake.markAllAsReadCalls, 1);
    },
  );

  test('markAsRead: decrements the server-sourced unread count by exactly one, only for a previously-unread item', () async {
    final fake = FakeNotificationRepository()
      ..pages = {
        null: NotificationPage(
          items: [_notif('n1', isRead: false), _notif('n2', isRead: true)],
          unreadCount: 5,
          hasMore: false,
          nextCursor: null,
        ),
      };

    final container = ProviderContainer(
      overrides: [notificationRepositoryProvider.overrideWithValue(fake)],
    );
    addTearDown(container.dispose);
    container.listen(notificationListControllerProvider, (_, _) {});
    await Future<void>.delayed(Duration.zero);

    container.read(notificationListControllerProvider.notifier).markAsRead('n1');
    expect(container.read(unreadNotificationCountProvider), 4);

    // Marking an already-read item as read again must not decrement
    // further (it's already 0-cost on the server side too).
    container.read(notificationListControllerProvider.notifier).markAsRead('n2');
    expect(container.read(unreadNotificationCountProvider), 4);
  });

  test('a fetch failure leaves the list empty rather than throwing out of build()', () async {
    final fake = FakeNotificationRepository()..throwOnFetch = Exception('network down');
    final container = ProviderContainer(
      overrides: [notificationRepositoryProvider.overrideWithValue(fake)],
    );
    addTearDown(container.dispose);
    container.listen(notificationListControllerProvider, (_, _) {});
    await Future<void>.delayed(Duration.zero);

    expect(container.read(notificationListControllerProvider), isEmpty);
  });
}
