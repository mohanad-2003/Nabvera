import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../data/notification_repository.dart';
import '../../domain/notification_models.dart';

part 'notification_controller.g.dart';

/// Synthetic filter on top of [NotificationCategory]: "All" and "Unread"
/// aren't real categories, they're views over the same list.
enum NotificationFilter {
  all,
  unread,
  workout,
  challenge,
  achievement,
  nutrition,
  reminder,
  community;

  NotificationCategory? get category => switch (this) {
    NotificationFilter.all || NotificationFilter.unread => null,
    NotificationFilter.workout => NotificationCategory.workout,
    NotificationFilter.challenge => NotificationCategory.challenge,
    NotificationFilter.achievement => NotificationCategory.achievement,
    NotificationFilter.nutrition => NotificationCategory.nutrition,
    NotificationFilter.reminder => NotificationCategory.reminder,
    NotificationFilter.community => NotificationCategory.community,
  };
}

@riverpod
class NotificationFilterController extends _$NotificationFilterController {
  @override
  NotificationFilter build() => NotificationFilter.all;

  void select(NotificationFilter filter) => state = filter;
}

/// Pagination/badge metadata for the inbox — kept separate from the item
/// list itself ([NotificationListController]) so the list can grow
/// (pages appended) without this needing to be recomputed from
/// whichever items happen to be loaded. `unreadCount` in particular is
/// always the server's true total across *every* notification this
/// user has — computing it from `NotificationListController`'s state
/// would silently go wrong the moment that state only holds one page
/// instead of the whole inbox.
class NotificationInboxMeta {
  const NotificationInboxMeta({
    this.unreadCount = 0,
    this.hasMore = false,
    this.nextCursor,
    this.isLoadingMore = false,
  });

  final int unreadCount;
  final bool hasMore;
  final String? nextCursor;
  final bool isLoadingMore;

  NotificationInboxMeta copyWith({
    int? unreadCount,
    bool? hasMore,
    String? nextCursor,
    bool clearNextCursor = false,
    bool? isLoadingMore,
  }) => NotificationInboxMeta(
    unreadCount: unreadCount ?? this.unreadCount,
    hasMore: hasMore ?? this.hasMore,
    nextCursor: clearNextCursor ? null : (nextCursor ?? this.nextCursor),
    isLoadingMore: isLoadingMore ?? this.isLoadingMore,
  );
}

@riverpod
class NotificationInboxMetaController
    extends _$NotificationInboxMetaController {
  @override
  NotificationInboxMeta build() => const NotificationInboxMeta();

  void set({required int unreadCount, required bool hasMore, String? nextCursor}) {
    state = state.copyWith(
      unreadCount: unreadCount,
      hasMore: hasMore,
      nextCursor: nextCursor,
      clearNextCursor: nextCursor == null,
    );
  }

  void setLoadingMore(bool value) {
    state = state.copyWith(isLoadingMore: value);
  }

  /// Optimistic local decrement — the real count is refreshed from the
  /// server on the next full reload, but this keeps the badge from
  /// visibly lagging behind a mark-as-read the user just tapped.
  void decrementUnread() {
    if (state.unreadCount > 0) {
      state = state.copyWith(unreadCount: state.unreadCount - 1);
    }
  }

  void clearUnread() => state = state.copyWith(unreadCount: 0);
}

/// Loads the real `/api/notifications` inbox, one cursor-paginated page
/// at a time (see [NotificationInboxMetaController] for hasMore/
/// unreadCount). Mutations are optimistic — applied to local state
/// immediately, then sent to the backend; failures are silently left
/// as-is rather than reverted, since a missed read/delete sync here is
/// low-stakes and self-corrects on next refresh.
@riverpod
class NotificationListController extends _$NotificationListController {
  @override
  List<NotificationItem> build() {
    Future.microtask(_loadFirstPage);
    return const [];
  }

  Future<void> _loadFirstPage() async {
    try {
      final page = await ref.read(notificationRepositoryProvider).fetchPage();
      state = [for (final doc in page.items) NotificationItem.fromJson(doc)];
      ref
          .read(notificationInboxMetaControllerProvider.notifier)
          .set(
            unreadCount: page.unreadCount,
            hasMore: page.hasMore,
            nextCursor: page.nextCursor,
          );
    } catch (_) {
      // Left empty — see WorkoutListByLevel for the same pattern.
    }
  }

  /// Re-fetches just the first page — used after a foreground push
  /// arrives (see `PushNotificationService`) so the list/badge reflect
  /// it without requiring the user to manually pull-to-refresh, and
  /// after mark-all-read. Deliberately replaces (not appends to) the
  /// current state, same as the initial load.
  Future<void> refresh() => _loadFirstPage();

  /// Appends the next page — call when the user reaches the bottom of
  /// the list or taps "Load more". A no-op if already loading or if the
  /// server has already said there's nothing more.
  Future<void> loadMore() async {
    final meta = ref.read(notificationInboxMetaControllerProvider);
    if (meta.isLoadingMore || !meta.hasMore || meta.nextCursor == null) return;

    final metaNotifier = ref.read(notificationInboxMetaControllerProvider.notifier);
    metaNotifier.setLoadingMore(true);
    try {
      final page = await ref
          .read(notificationRepositoryProvider)
          .fetchPage(cursor: meta.nextCursor);
      state = [
        ...state,
        for (final doc in page.items) NotificationItem.fromJson(doc),
      ];
      metaNotifier.set(
        unreadCount: page.unreadCount,
        hasMore: page.hasMore,
        nextCursor: page.nextCursor,
      );
    } catch (_) {
      // Left as-is on failure — the user can retry via the same "load
      // more" affordance; hasMore/nextCursor are untouched so a retry
      // targets the same page it just failed to load.
    } finally {
      metaNotifier.setLoadingMore(false);
    }
  }

  void markAsRead(String id) {
    final target = state.where((item) => item.id == id).firstOrNull;
    state = [
      for (final item in state)
        if (item.id == id) item.copyWith(isRead: true) else item,
    ];
    if (target != null && !target.isRead) {
      ref.read(notificationInboxMetaControllerProvider.notifier).decrementUnread();
    }
    ref.read(notificationRepositoryProvider).markAsRead(id);
  }

  /// Marks every notification this user has as read on the server —
  /// not just whatever page is currently loaded (see
  /// `notificationController.js`'s `markAllAsRead`, scoped directly to
  /// `{ user, isRead: false }`). The optimistic local update below only
  /// touches the pages already loaded here, which is fine: any
  /// not-yet-loaded page will come back already marked read from the
  /// server on its own next fetch, since the mutation itself is global.
  void markAllAsRead() {
    state = [for (final item in state) item.copyWith(isRead: true)];
    ref.read(notificationInboxMetaControllerProvider.notifier).clearUnread();
    ref.read(notificationRepositoryProvider).markAllAsRead();
  }

  void delete(String id) {
    state = state.where((item) => item.id != id).toList();
    ref.read(notificationRepositoryProvider).delete(id);
  }
}

/// Same-day-of-year check without pulling in a date package — used to
/// group notifications into Today / Yesterday / Earlier This Week / Older.
bool _isSameDay(DateTime a, DateTime b) =>
    a.year == b.year && a.month == b.month && a.day == b.day;

enum NotificationDayGroup { today, yesterday, earlierThisWeek, older }

@riverpod
Map<NotificationDayGroup, List<NotificationItem>> groupedNotifications(
  Ref ref,
) {
  final filter = ref.watch(notificationFilterControllerProvider);
  final all = ref.watch(notificationListControllerProvider);

  final filtered =
      all.where((item) {
          if (filter == NotificationFilter.unread) return !item.isRead;
          final category = filter.category;
          return category == null || item.category == category;
        }).toList()
        ..sort((a, b) => b.timestamp.compareTo(a.timestamp));

  final now = DateTime.now();
  final yesterday = now.subtract(const Duration(days: 1));
  final weekAgo = now.subtract(const Duration(days: 7));

  final grouped = <NotificationDayGroup, List<NotificationItem>>{};
  for (final item in filtered) {
    final group =
        _isSameDay(item.timestamp, now)
            ? NotificationDayGroup.today
            : _isSameDay(item.timestamp, yesterday)
            ? NotificationDayGroup.yesterday
            : item.timestamp.isAfter(weekAgo)
            ? NotificationDayGroup.earlierThisWeek
            : NotificationDayGroup.older;
    grouped.putIfAbsent(group, () => []).add(item);
  }
  return grouped;
}

/// The true unread count across the user's *entire* inbox — from the
/// server (see [NotificationInboxMetaController]), never derived from
/// [NotificationListController]'s state, which may only hold the first
/// page or two of it.
@riverpod
int unreadNotificationCount(Ref ref) =>
    ref.watch(notificationInboxMetaControllerProvider).unreadCount;
