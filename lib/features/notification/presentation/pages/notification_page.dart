import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/localization/generated/app_localizations.dart';
import '../../../../core/routing/app_routes.dart';
import '../../../../core/theme/app_theme_extension.dart';
import '../../../../core/widgets/premium_scaffold.dart';
import '../providers/notification_controller.dart';
import '../widgets/empty_notifications_view.dart';
import '../widgets/notification_category_chip.dart';
import '../widgets/notification_header.dart';
import '../widgets/notification_section.dart';

class NotificationPage extends ConsumerWidget {
  const NotificationPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filter = ref.watch(notificationFilterControllerProvider);
    final grouped = ref.watch(groupedNotificationsProvider);
    final inboxMeta = ref.watch(notificationInboxMetaControllerProvider);
    final ext = Theme.of(context).extension<AppThemeExtension>()!;
    final l10n = AppLocalizations.of(context);

    final hasAny = grouped.values.any((list) => list.isNotEmpty);

    return PremiumScaffold(
      child: SizedBox.expand(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            NotificationHeader(
              title: l10n.notificationsTitle,
              subtitle: l10n.notificationsSubtitle,
              canPop: context.canPop(),
              onBack: () => context.pop(),
              markAllReadLabel: l10n.notificationsMarkAllRead,
              onMarkAllRead: () {
                ref
                    .read(notificationListControllerProvider.notifier)
                    .markAllAsRead();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(l10n.notificationsMarkAllReadDone),
                    backgroundColor: ext.cardColor,
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 18),
            SizedBox(
              height: 40,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: NotificationFilter.values.length,
                separatorBuilder: (_, _) => const SizedBox(width: 8),
                itemBuilder: (context, index) {
                  final value = NotificationFilter.values[index];
                  return NotificationCategoryChip(
                    label: _filterLabel(l10n, value),
                    icon: value.category?.icon,
                    selected: value == filter,
                    onTap:
                        () => ref
                            .read(notificationFilterControllerProvider.notifier)
                            .select(value),
                  );
                },
              ),
            ),
            const SizedBox(height: 18),
            Expanded(
              child:
                  !hasAny
                      ? EmptyNotificationsView(
                        title: l10n.notificationsEmptyTitle,
                        body: l10n.notificationsEmptyBody,
                        ctaLabel: l10n.notificationsStartWorkout,
                        onStartWorkout: () => context.go(AppRoutes.workout),
                      )
                      : ListView(
                        padding: const EdgeInsets.only(bottom: 8),
                        children: [
                          for (final group in NotificationDayGroup.values)
                            if ((grouped[group] ?? const []).isNotEmpty) ...[
                              NotificationSection(
                                title: _groupLabel(l10n, group),
                                items: grouped[group]!,
                                baseDelayMs: group.index * 60,
                                onTap: (item) {
                                  if (!item.isRead) {
                                    ref
                                        .read(
                                          notificationListControllerProvider
                                              .notifier,
                                        )
                                        .markAsRead(item.id);
                                  }
                                },
                                onMarkRead:
                                    (item) => ref
                                        .read(
                                          notificationListControllerProvider
                                              .notifier,
                                        )
                                        .markAsRead(item.id),
                                onDelete: (item) {
                                  ref
                                      .read(
                                        notificationListControllerProvider
                                            .notifier,
                                      )
                                      .delete(item.id);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        l10n.notificationsSwipeDeleted,
                                      ),
                                      backgroundColor: ext.cardColor,
                                      behavior: SnackBarBehavior.floating,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(14),
                                      ),
                                    ),
                                  );
                                },
                              ),
                              const SizedBox(height: 22),
                            ],
                          if (filter == NotificationFilter.all &&
                              inboxMeta.hasMore)
                            Padding(
                              padding: const EdgeInsets.only(bottom: 12),
                              child: Center(
                                child:
                                    inboxMeta.isLoadingMore
                                        ? const Padding(
                                          padding: EdgeInsets.all(12),
                                          child: SizedBox(
                                            width: 22,
                                            height: 22,
                                            child: CircularProgressIndicator(
                                              strokeWidth: 2.5,
                                            ),
                                          ),
                                        )
                                        : TextButton(
                                          onPressed:
                                              () => ref
                                                  .read(
                                                    notificationListControllerProvider
                                                        .notifier,
                                                  )
                                                  .loadMore(),
                                          child: Text(
                                            Localizations.localeOf(
                                                          context,
                                                        ).languageCode ==
                                                        'ar'
                                                    ? 'عرض المزيد'
                                                    : 'Load more',
                                          ),
                                        ),
                              ),
                            ),
                        ],
                      ),
            ),
          ],
        ),
      ),
    );
  }

  String _filterLabel(AppLocalizations l10n, NotificationFilter filter) =>
      switch (filter) {
        NotificationFilter.all => l10n.notificationsFilterAll,
        NotificationFilter.unread => l10n.notificationsFilterUnread,
        NotificationFilter.workout => l10n.notificationsFilterWorkouts,
        NotificationFilter.challenge => l10n.notificationsFilterChallenges,
        NotificationFilter.achievement => l10n.notificationsFilterAchievements,
        NotificationFilter.nutrition => l10n.notificationsFilterNutrition,
        NotificationFilter.reminder => l10n.notificationsFilterReminders,
        NotificationFilter.community => l10n.notificationsFilterCommunity,
      };

  String _groupLabel(AppLocalizations l10n, NotificationDayGroup group) =>
      switch (group) {
        NotificationDayGroup.today => l10n.notificationsGroupToday,
        NotificationDayGroup.yesterday => l10n.notificationsGroupYesterday,
        NotificationDayGroup.earlierThisWeek =>
          l10n.notificationsGroupEarlierThisWeek,
        NotificationDayGroup.older => l10n.notificationsGroupOlder,
      };
}
