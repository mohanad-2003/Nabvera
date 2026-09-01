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

/// Loads the real `/api/notifications` inbox. Mutations are optimistic —
/// applied to local state immediately, then sent to the backend; failures
/// are silently left as-is rather than reverted, since a missed
/// read/delete sync here is low-stakes and self-corrects on next refresh.
@riverpod
class NotificationListController extends _$NotificationListController {
  @override
  List<NotificationItem> build() {
    Future.microtask(_load);
    return const [];
  }

  Future<void> _load() async {
    try {
      final docs = await ref.read(notificationRepositoryProvider).fetchAll();
      state = [for (final doc in docs) NotificationItem.fromJson(doc)];
    } catch (_) {
      // Left empty — see WorkoutListByLevel for the same pattern.
    }
  }

  void markAsRead(String id) {
    state = [
      for (final item in state)
        if (item.id == id) item.copyWith(isRead: true) else item,
    ];
    ref.read(notificationRepositoryProvider).markAsRead(id);
  }

  void markAllAsRead() {
    state = [for (final item in state) item.copyWith(isRead: true)];
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
      }).toList()..sort((a, b) => b.timestamp.compareTo(a.timestamp));

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

@riverpod
int unreadNotificationCount(Ref ref) =>
    ref
        .watch(notificationListControllerProvider)
        .where((item) => !item.isRead)
        .length;
