import 'package:flutter/material.dart';

import '../../../core/localization/generated/app_localizations.dart';
import '../../../core/theme/app_colors.dart';

/// The seven filterable notification categories (plus the synthetic "all"
/// / "unread" chips handled separately in the UI). Each has one canonical
/// accent gradient used by [NotificationIcon].
enum NotificationCategory {
  workout,
  challenge,
  achievement,
  nutrition,
  reminder,
  community;

  IconData get icon => switch (this) {
    NotificationCategory.workout => Icons.fitness_center_rounded,
    NotificationCategory.challenge => Icons.emoji_events_rounded,
    NotificationCategory.achievement => Icons.military_tech_rounded,
    NotificationCategory.nutrition => Icons.restaurant_rounded,
    NotificationCategory.reminder => Icons.notifications_active_rounded,
    NotificationCategory.community => Icons.favorite_rounded,
  };

  List<Color> get gradient => switch (this) {
    NotificationCategory.workout => const [
      AppColors.electricOrange,
      Color(0xFFFFB020),
    ],
    NotificationCategory.challenge => const [
      AppColors.seedViolet,
      AppColors.aquaBlue,
    ],
    NotificationCategory.achievement => const [
      AppColors.warning,
      AppColors.electricOrange,
    ],
    NotificationCategory.nutrition => const [
      AppColors.success,
      Color(0xFF1FB6A8),
    ],
    NotificationCategory.reminder => const [
      AppColors.aquaBlue,
      AppColors.seedViolet,
    ],
    NotificationCategory.community => const [
      AppColors.communityPink,
      AppColors.seedViolet,
    ],
  };
}

/// Maps the backend `Notification.type` enum (`workout_reminder`, `streak`,
/// `like`, `comment`, `meal_plan`, `system`, `workout_completed`,
/// `challenge`) onto the UI's richer category set.
NotificationCategory notificationCategoryFromApi(String? type) =>
    switch (type) {
      'workout_reminder' || 'workout_completed' => NotificationCategory.workout,
      'streak' => NotificationCategory.achievement,
      'challenge' => NotificationCategory.challenge,
      'like' || 'comment' => NotificationCategory.community,
      'meal_plan' => NotificationCategory.nutrition,
      _ => NotificationCategory.reminder,
    };

/// The action button a notification card offers, if any — kept as an enum
/// (rather than a pre-picked English string) so the button label is
/// localized at the widget layer alongside everything else.
enum NotificationAction {
  start,
  view;

  String label(AppLocalizations l10n) => switch (this) {
    NotificationAction.start => l10n.notificationActionStart,
    NotificationAction.view => l10n.notificationActionView,
  };
}

class NotificationItem {
  const NotificationItem({
    required this.id,
    required this.type,
    required this.category,
    required this.title,
    required this.body,
    required this.data,
    required this.timestamp,
    this.isRead = false,
    this.action,
  });

  final String id;

  /// The raw backend `type` — kept alongside [category] (its coarser UI
  /// grouping) so [localizedTitle]/[localizedBody] can render real
  /// Arabic/English copy for the event types the backend actually
  /// generates now, instead of only ever showing whatever plain-English
  /// text the server happened to store.
  final String type;
  final NotificationCategory category;

  /// Server-provided text — English-only today (the backend has no stored
  /// per-user locale to localize a push banner with). Used as-is only for
  /// types [localizedTitle]/[localizedBody] don't specifically handle.
  final String title;
  final String body;

  final Map<String, dynamic> data;
  final DateTime timestamp;
  final bool isRead;
  final NotificationAction? action;

  int? get _streak => (data['streak'] as num?)?.toInt();
  int? get _calories => (data['caloriesBurned'] as num?)?.toInt();

  /// Real, localized copy for the event types the backend now actually
  /// fires (see `backend/src/services/notificationTriggers.js`) — falls
  /// back to the server's raw (English) [title] for every other type,
  /// including the older seeded/demo ones (`like`, `comment`, `meal_plan`,
  /// `system`) this app never generates itself.
  String localizedTitle(AppLocalizations l10n) => switch (type) {
    'workout_completed' => l10n.notificationWorkoutCompletedTitle,
    'streak' when _streak != null => l10n.notificationStreakTitle(_streak!),
    'workout_reminder' => l10n.notificationWorkoutReminderTitle,
    _ => title,
  };

  String localizedBody(AppLocalizations l10n) => switch (type) {
    'workout_completed' when _calories != null => l10n
        .notificationWorkoutCompletedBody(_calories!),
    'streak' when _streak != null => l10n.notificationStreakBody(_streak!),
    'workout_reminder' => l10n.notificationWorkoutReminderBody,
    _ => body,
  };

  NotificationItem copyWith({bool? isRead}) => NotificationItem(
    id: id,
    type: type,
    category: category,
    title: title,
    body: body,
    data: data,
    timestamp: timestamp,
    isRead: isRead ?? this.isRead,
    action: action,
  );

  /// Builds a display item from a `/api/notifications` JSON document.
  factory NotificationItem.fromJson(Map<String, dynamic> json) {
    final type = (json['type'] as String?) ?? 'system';
    return NotificationItem(
      id: json['_id'] as String? ?? '',
      type: type,
      category: notificationCategoryFromApi(type),
      title: (json['title'] as String?) ?? '',
      body: (json['body'] as String?) ?? '',
      data: (json['data'] as Map?)?.cast<String, dynamic>() ?? const {},
      timestamp:
          DateTime.tryParse(json['createdAt'] as String? ?? '') ??
          DateTime.now(),
      isRead: (json['isRead'] as bool?) ?? false,
      action: switch (type) {
        'workout_reminder' || 'workout_completed' => NotificationAction.start,
        'meal_plan' || 'like' || 'comment' => NotificationAction.view,
        _ => null,
      },
    );
  }
}
