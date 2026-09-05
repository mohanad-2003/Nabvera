import 'package:nabvera/core/analytics/analytics_service.dart';
import 'package:nabvera/core/localization/generated/app_localizations.dart';
import 'package:nabvera/core/localization/locale_controller.dart';
import 'package:nabvera/core/notifications/workout_reminder_scheduler.dart';
import 'package:nabvera/features/profile/presentation/providers/profile_controller.dart';
import 'package:nabvera/features/workout/data/workout_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Whether any workout log's `completedAt` falls on the same *local*
/// calendar day as [now] — the "already trained today" signal
/// [WorkoutReminderScheduler.rescheduleAll] needs to skip today's
/// reminder.
bool _hasLogToday(List<Map<String, dynamic>> logs, DateTime now) {
  return logs.any((log) {
    final completedAt = DateTime.tryParse(log['completedAt'] as String? ?? '');
    if (completedAt == null) return false;
    final local = completedAt.toLocal();
    return local.year == now.year &&
        local.month == now.month &&
        local.day == now.day;
  });
}

/// Re-derives and reschedules every local workout reminder from the
/// current profile — the single call site every trigger below funnels
/// through, so "cancel the old ones, schedule the new ones" always happens
/// together (never one without the other).
///
/// [hasWorkoutTodayOverride] skips the extra `fetchWorkoutLogs()` call for
/// the one caller that already knows the answer for certain: right after
/// logging today's workout (see `category_detail_page.dart`).
Future<void> syncWorkoutReminders(
  WidgetRef ref, {
  bool? hasWorkoutTodayOverride,
}) async {
  final profile = ref.read(currentUserProfileProvider);
  if (profile.id.isEmpty) return; // Not signed in / not loaded yet.

  final hasWorkoutToday =
      hasWorkoutTodayOverride ??
      await _fetchHasWorkoutToday(ref);

  final l10n = lookupAppLocalizations(ref.read(localeControllerProvider));
  await ref
      .read(workoutReminderSchedulerProvider)
      .rescheduleAll(
        profile: profile,
        hasWorkoutToday: hasWorkoutToday,
        l10n: l10n,
      );
}

Future<bool> _fetchHasWorkoutToday(WidgetRef ref) async {
  try {
    final logs = await ref.read(workoutRepositoryProvider).fetchWorkoutLogs();
    return _hasLogToday(logs, DateTime.now());
  } catch (_) {
    // Unknown — default to "not trained yet" so a reminder still gets
    // scheduled rather than silently skipped on a network hiccup.
    return false;
  }
}

/// Saves the Workout Schedule section (Edit Profile and the Home quick-edit
/// sheet both call this — see `edit_profile_page.dart` and
/// `workout_schedule_sheet.dart`) and re-syncs local reminders + analytics
/// to match, all in one place so the two entry points can never drift.
Future<void> saveWorkoutSchedule(
  WidgetRef ref, {
  required Map<String, dynamic> patch,
  required bool previousReminderEnabled,
}) async {
  await ref.read(currentUserProfileProvider.notifier).update(patch);
  await ref.requestPermissionThenSync();

  final analytics = ref.read(analyticsServiceProvider);
  final daysCount = (patch['workoutDays'] as List?)?.length;
  await analytics.logEvent(AnalyticsEvent.workoutScheduleUpdated, {
    if (daysCount != null) 'daysCount': daysCount,
  });

  final nextReminderEnabled = patch['reminderEnabled'] as bool?;
  if (nextReminderEnabled != null && nextReminderEnabled != previousReminderEnabled) {
    await analytics.logEvent(
      nextReminderEnabled
          ? AnalyticsEvent.workoutReminderEnabled
          : AnalyticsEvent.workoutReminderDisabled,
      {'reminderEnabled': nextReminderEnabled},
    );
  }
}

/// Small private extension so [saveWorkoutSchedule] reads as one flat
/// sequence of steps rather than nesting the permission request inside it.
extension on WidgetRef {
  Future<void> requestPermissionThenSync() async {
    await read(workoutReminderSchedulerProvider).requestPermission();
    await syncWorkoutReminders(this);
  }
}
