// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(NotificationFilterController)
final notificationFilterControllerProvider =
    NotificationFilterControllerProvider._();

final class NotificationFilterControllerProvider
    extends
        $NotifierProvider<NotificationFilterController, NotificationFilter> {
  NotificationFilterControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'notificationFilterControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$notificationFilterControllerHash();

  @$internal
  @override
  NotificationFilterController create() => NotificationFilterController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(NotificationFilter value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<NotificationFilter>(value),
    );
  }
}

String _$notificationFilterControllerHash() =>
    r'b41b19c0e0cd1407e41820e841a9d5588472bf18';

abstract class _$NotificationFilterController
    extends $Notifier<NotificationFilter> {
  NotificationFilter build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<NotificationFilter, NotificationFilter>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<NotificationFilter, NotificationFilter>,
              NotificationFilter,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

/// Loads the real `/api/notifications` inbox. Mutations are optimistic —
/// applied to local state immediately, then sent to the backend; failures
/// are silently left as-is rather than reverted, since a missed
/// read/delete sync here is low-stakes and self-corrects on next refresh.

@ProviderFor(NotificationListController)
final notificationListControllerProvider =
    NotificationListControllerProvider._();

/// Loads the real `/api/notifications` inbox. Mutations are optimistic —
/// applied to local state immediately, then sent to the backend; failures
/// are silently left as-is rather than reverted, since a missed
/// read/delete sync here is low-stakes and self-corrects on next refresh.
final class NotificationListControllerProvider
    extends
        $NotifierProvider<NotificationListController, List<NotificationItem>> {
  /// Loads the real `/api/notifications` inbox. Mutations are optimistic —
  /// applied to local state immediately, then sent to the backend; failures
  /// are silently left as-is rather than reverted, since a missed
  /// read/delete sync here is low-stakes and self-corrects on next refresh.
  NotificationListControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'notificationListControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$notificationListControllerHash();

  @$internal
  @override
  NotificationListController create() => NotificationListController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(List<NotificationItem> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<List<NotificationItem>>(value),
    );
  }
}

String _$notificationListControllerHash() =>
    r'561bff431298e12f3f97829b27846e8671764d8d';

/// Loads the real `/api/notifications` inbox. Mutations are optimistic —
/// applied to local state immediately, then sent to the backend; failures
/// are silently left as-is rather than reverted, since a missed
/// read/delete sync here is low-stakes and self-corrects on next refresh.

abstract class _$NotificationListController
    extends $Notifier<List<NotificationItem>> {
  List<NotificationItem> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref =
        this.ref as $Ref<List<NotificationItem>, List<NotificationItem>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<List<NotificationItem>, List<NotificationItem>>,
              List<NotificationItem>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

@ProviderFor(groupedNotifications)
final groupedNotificationsProvider = GroupedNotificationsProvider._();

final class GroupedNotificationsProvider
    extends
        $FunctionalProvider<
          Map<NotificationDayGroup, List<NotificationItem>>,
          Map<NotificationDayGroup, List<NotificationItem>>,
          Map<NotificationDayGroup, List<NotificationItem>>
        >
    with $Provider<Map<NotificationDayGroup, List<NotificationItem>>> {
  GroupedNotificationsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'groupedNotificationsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$groupedNotificationsHash();

  @$internal
  @override
  $ProviderElement<Map<NotificationDayGroup, List<NotificationItem>>>
  $createElement($ProviderPointer pointer) => $ProviderElement(pointer);

  @override
  Map<NotificationDayGroup, List<NotificationItem>> create(Ref ref) {
    return groupedNotifications(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(
    Map<NotificationDayGroup, List<NotificationItem>> value,
  ) {
    return $ProviderOverride(
      origin: this,
      providerOverride:
          $SyncValueProvider<Map<NotificationDayGroup, List<NotificationItem>>>(
            value,
          ),
    );
  }
}

String _$groupedNotificationsHash() =>
    r'dec484b4597e00ddced760969b841da80db8667e';

@ProviderFor(unreadNotificationCount)
final unreadNotificationCountProvider = UnreadNotificationCountProvider._();

final class UnreadNotificationCountProvider
    extends $FunctionalProvider<int, int, int>
    with $Provider<int> {
  UnreadNotificationCountProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'unreadNotificationCountProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$unreadNotificationCountHash();

  @$internal
  @override
  $ProviderElement<int> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  int create(Ref ref) {
    return unreadNotificationCount(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(int value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<int>(value),
    );
  }
}

String _$unreadNotificationCountHash() =>
    r'05e73b04e84de384c30e50f2ea69fa1a6827b97b';
