import 'dart:async';

import 'package:nabvera/core/analytics/analytics_service.dart';
import 'package:nabvera/core/localization/generated/app_localizations.dart';
import 'package:nabvera/core/routing/app_router.dart';
import 'package:nabvera/core/routing/app_routes.dart';
import 'package:nabvera/features/profile/domain/profile_models.dart';
import 'package:nabvera/features/profile/domain/workout_schedule.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:timezone/data/latest_all.dart' as tz_data;
import 'package:timezone/timezone.dart' as tz;

import '../../features/workout/domain/workout_models.dart' show Weekday;

part 'workout_reminder_scheduler.g.dart';

/// Stable notification ids, one per weekday — rescheduling always cancels
/// exactly these 7 ids first, so a schedule change never leaves a stray
/// notification from a day that's no longer selected.
int _notificationIdFor(Weekday day) => 6001 + Weekday.values.indexOf(day);

const _androidChannelId = 'workout_reminders';

/// Owns the local, on-device workout-reminder notifications: one per
/// selected weekday, recomputed from scratch on every call to
/// [rescheduleAll] using the pure rules in `workout_schedule.dart`
/// (`computeUpcomingReminderOccurrences`) — never a plain repeating
/// "same time every week" alarm, since that couldn't skip a day the user
/// already trained or one that falls inside quiet hours.
///
/// Deliberately local-only: no FCM/remote push is involved anywhere in
/// this class. Every call is best-effort — a permission denial or plugin
/// hiccup on a given device silently leaves reminders off rather than
/// crashing whatever screen triggered a reschedule.
class WorkoutReminderScheduler {
  WorkoutReminderScheduler(this._ref);

  final Ref _ref;
  final _plugin = FlutterLocalNotificationsPlugin();
  bool _initialized = false;

  /// Tapping the reminder notification opens the app straight to Home —
  /// where "today's plan" already lives — instead of leaving the user on
  /// whatever screen the app happened to resume on. `appRouterProvider` is
  /// itself a `keepAlive` singleton, so calling `.go` on it directly (no
  /// `BuildContext` needed) is safe from this non-widget callback.
  void _onNotificationTapped(NotificationResponse response) {
    if (response.payload != 'workout_reminder') return;
    unawaited(
      _ref
          .read(analyticsServiceProvider)
          .logEvent(AnalyticsEvent.workoutReminderOpened),
    );
    _ref.read(appRouterProvider).go(AppRoutes.home);
  }

  Future<void> _ensureInitialized() async {
    if (_initialized) return;
    _initialized = true;

    try {
      tz_data.initializeTimeZones();
      final timezoneInfo = await FlutterTimezone.getLocalTimezone();
      tz.setLocalLocation(tz.getLocation(timezoneInfo.identifier));
    } catch (error) {
      // Falls back to whatever `timezone` defaults to (UTC) — reminders
      // still fire, just not necessarily at the exact intended local wall
      // clock time on a device where this lookup fails.
      debugPrint('Workout reminder timezone setup failed: $error');
    }

    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    );
    try {
      await _plugin.initialize(
        settings: const InitializationSettings(
          android: androidSettings,
          iOS: iosSettings,
        ),
        onDidReceiveNotificationResponse: _onNotificationTapped,
      );
      await _plugin
          .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin
          >()
          ?.createNotificationChannel(
            const AndroidNotificationChannel(
              _androidChannelId,
              'Workout reminders',
              description: 'Reminders for the workout days and time you chose',
              importance: Importance.defaultImportance,
            ),
          );
    } catch (error) {
      debugPrint('Workout reminder plugin init failed: $error');
    }
  }

  /// Requests the OS notification permission — Android 13+ (POST_NOTIFICATIONS)
  /// and iOS (alert/badge/sound) each have their own explicit request call;
  /// older Android versions grant this at install time, so the Android call
  /// below is a no-op there. Safe to call more than once.
  Future<bool> requestPermission() async {
    await _ensureInitialized();
    try {
      final ios = await _plugin
          .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin
          >()
          ?.requestPermissions(alert: true, badge: true, sound: true);
      final android = await _plugin
          .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin
          >()
          ?.requestNotificationsPermission();
      // Only one of the two resolvers above is non-null on a given
      // platform — treat "not applicable here" as granted so the other
      // platform's real answer isn't masked by a null-coalesced false.
      return (ios ?? true) && (android ?? true);
    } catch (error) {
      debugPrint('Workout reminder permission request failed: $error');
      return false;
    }
  }

  /// Cancels every currently-scheduled workout reminder and, if
  /// [profile.reminderEnabled] and at least one day is selected, schedules
  /// the next occurrence for each selected weekday over the coming week —
  /// skipping today when [hasWorkoutToday] is true or the reminder time has
  /// already passed, and skipping every day entirely if the reminder time
  /// falls inside quiet hours. Call this again whenever anything that
  /// feeds into that decision changes: the schedule itself, or a workout
  /// just logged today.
  Future<void> rescheduleAll({
    required UserProfile profile,
    required bool hasWorkoutToday,
    required AppLocalizations l10n,
    DateTime? now,
  }) async {
    await _ensureInitialized();
    for (final day in Weekday.values) {
      await _plugin.cancel(id: _notificationIdFor(day));
    }

    if (!profile.reminderEnabled) return;
    final reminderTime = parseTimeOfDay(profile.workoutReminderTime);
    if (reminderTime == null) return;

    final workoutDays = workoutDaysFromApi(profile.workoutDays);
    final occurrences = computeUpcomingReminderOccurrences(
      workoutDays: workoutDays,
      reminderTime: reminderTime,
      now: now ?? DateTime.now(),
      hasWorkoutToday: hasWorkoutToday,
      quietHoursEnabled: profile.quietHoursEnabled,
      quietHoursStart: parseTimeOfDay(profile.quietHoursStart),
      quietHoursEnd: parseTimeOfDay(profile.quietHoursEnd),
    );

    for (final occurrence in occurrences) {
      await _scheduleOne(occurrence, l10n);
    }
  }

  Future<void> _scheduleOne(
    ReminderOccurrence occurrence,
    AppLocalizations l10n,
  ) async {
    try {
      final scheduledDate = tz.TZDateTime.from(occurrence.dateTime, tz.local);
      await _plugin.zonedSchedule(
        id: _notificationIdFor(occurrence.day),
        // Same copy as the in-app "haven't trained today yet" notification
        // (see `notification_models.dart`) — one consistent voice for the
        // same nudge, whether it's a local scheduled alert or the inbox.
        title: l10n.notificationWorkoutReminderTitle,
        body: l10n.notificationWorkoutReminderBody,
        scheduledDate: scheduledDate,
        notificationDetails: const NotificationDetails(
          android: AndroidNotificationDetails(
            _androidChannelId,
            'Workout reminders',
            channelDescription: 'Reminders for the workout days and time you chose',
            importance: Importance.defaultImportance,
            priority: Priority.defaultPriority,
          ),
          iOS: DarwinNotificationDetails(),
        ),
        // Inexact on purpose: exact alarms need a separate, more sensitive
        // Android 12+ permission ("Alarms & reminders") that's overkill
        // for a workout nudge — being off by a few minutes is fine here.
        androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
        payload: 'workout_reminder',
      );
    } catch (error) {
      debugPrint('Scheduling workout reminder failed: $error');
    }
  }

  /// Cancels every workout reminder outright — used when the user turns
  /// `reminderEnabled` off, distinct from [rescheduleAll] finding nothing
  /// to schedule (same effect, but this skips the profile/plugin-state
  /// dance when the caller already knows the answer is "cancel all").
  Future<void> cancelAll() async {
    await _ensureInitialized();
    for (final day in Weekday.values) {
      await _plugin.cancel(id: _notificationIdFor(day));
    }
  }
}

@Riverpod(keepAlive: true)
WorkoutReminderScheduler workoutReminderScheduler(Ref ref) {
  return WorkoutReminderScheduler(ref);
}
