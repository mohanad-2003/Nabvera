import 'package:flutter/material.dart';

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
/// `like`, `comment`, `meal_plan`, `system`) onto the UI's richer category
/// set. `challenge` has no backend equivalent, so it never gets a real
/// notification — its filter chip just stays empty.
NotificationCategory notificationCategoryFromApi(String? type) => switch (type) {
  'workout_reminder' => NotificationCategory.workout,
  'streak' => NotificationCategory.achievement,
  'like' || 'comment' => NotificationCategory.community,
  'meal_plan' => NotificationCategory.nutrition,
  _ => NotificationCategory.reminder,
};

class NotificationItem {
  const NotificationItem({
    required this.id,
    required this.category,
    required this.title,
    required this.body,
    required this.timestamp,
    this.isRead = false,
    this.actionLabel,
  });

  final String id;
  final NotificationCategory category;
  final String title;
  final String body;
  final DateTime timestamp;
  final bool isRead;
  final String? actionLabel;

  NotificationItem copyWith({bool? isRead}) => NotificationItem(
    id: id,
    category: category,
    title: title,
    body: body,
    timestamp: timestamp,
    isRead: isRead ?? this.isRead,
    actionLabel: actionLabel,
  );

  /// Builds a display item from a `/api/notifications` JSON document.
  factory NotificationItem.fromJson(Map<String, dynamic> json) {
    final type = json['type'] as String?;
    return NotificationItem(
      id: json['_id'] as String? ?? '',
      category: notificationCategoryFromApi(type),
      title: (json['title'] as String?) ?? '',
      body: (json['body'] as String?) ?? '',
      timestamp: DateTime.tryParse(json['createdAt'] as String? ?? '') ?? DateTime.now(),
      isRead: (json['isRead'] as bool?) ?? false,
      actionLabel: switch (type) {
        'workout_reminder' => 'Start',
        'meal_plan' || 'like' || 'comment' => 'View',
        _ => null,
      },
    );
  }
}
