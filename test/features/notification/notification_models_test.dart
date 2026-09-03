import 'package:fitness_app/core/localization/generated/app_localizations_en.dart';
import 'package:fitness_app/features/notification/domain/notification_models.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final l10n = AppLocalizationsEn();

  group('NotificationItem.fromJson — real event types', () {
    test('workout_completed renders localized title/body from data', () {
      final item = NotificationItem.fromJson({
        '_id': 'n1',
        'type': 'workout_completed',
        'title': 'Workout completed!',
        'body': 'Server English fallback',
        'data': {'workoutLogId': 'log1', 'caloriesBurned': 250},
        'createdAt': '2026-01-01T00:00:00.000Z',
        'isRead': false,
      });

      expect(item.category, NotificationCategory.workout);
      expect(item.localizedTitle(l10n), l10n.notificationWorkoutCompletedTitle);
      expect(
        item.localizedBody(l10n),
        l10n.notificationWorkoutCompletedBody(250),
      );
      expect(item.action, NotificationAction.start);
    });

    test('streak renders the milestone count from data', () {
      final item = NotificationItem.fromJson({
        '_id': 'n2',
        'type': 'streak',
        'title': '7-day streak!',
        'body': 'server text',
        'data': {'streak': 7},
        'createdAt': '2026-01-01T00:00:00.000Z',
      });

      expect(item.category, NotificationCategory.achievement);
      expect(item.localizedTitle(l10n), l10n.notificationStreakTitle(7));
      expect(item.localizedBody(l10n), l10n.notificationStreakBody(7));
    });

    test('workout_reminder uses fixed localized copy, no data needed', () {
      final item = NotificationItem.fromJson({
        '_id': 'n3',
        'type': 'workout_reminder',
        'title': "Haven't trained today yet",
        'body': 'server text',
        'createdAt': '2026-01-01T00:00:00.000Z',
      });

      expect(item.localizedTitle(l10n), l10n.notificationWorkoutReminderTitle);
      expect(item.localizedBody(l10n), l10n.notificationWorkoutReminderBody);
      expect(item.action, NotificationAction.start);
    });

    test('challenge maps to the challenge category', () {
      final item = NotificationItem.fromJson({
        '_id': 'n4',
        'type': 'challenge',
        'title': 'Challenge joined!',
        'body': "You're in.",
        'createdAt': '2026-01-01T00:00:00.000Z',
      });
      expect(item.category, NotificationCategory.challenge);
    });
  });

  group('NotificationItem.fromJson — fallback for legacy/demo types', () {
    test(
      'falls back to raw server title/body when data is missing for a known type',
      () {
        final item = NotificationItem.fromJson({
          '_id': 'n5',
          'type': 'streak',
          'title': 'Old seeded streak text',
          'body': 'Old seeded body',
          'createdAt': '2026-01-01T00:00:00.000Z',
          // No `data.streak` — can't render the localized copy meaningfully.
        });
        expect(item.localizedTitle(l10n), 'Old seeded streak text');
        expect(item.localizedBody(l10n), 'Old seeded body');
      },
    );

    test(
      'an unhandled type (like/comment/meal_plan/system) always uses server text',
      () {
        final item = NotificationItem.fromJson({
          '_id': 'n6',
          'type': 'meal_plan',
          'title': 'Your meal plan is ready',
          'body': 'Check it out',
          'createdAt': '2026-01-01T00:00:00.000Z',
        });
        expect(item.localizedTitle(l10n), 'Your meal plan is ready');
        expect(item.localizedBody(l10n), 'Check it out');
        expect(item.action, NotificationAction.view);
      },
    );
  });
}
