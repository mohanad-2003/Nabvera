import 'dart:async';

import 'package:nabvera/core/analytics/analytics_service.dart';
import 'package:nabvera/features/home/domain/weekly_progress_calculator.dart';
import 'package:nabvera/features/nutrition/presentation/providers/nutrition_controller.dart';
import 'package:nabvera/features/profile/presentation/providers/profile_controller.dart';
import 'package:nabvera/features/workout/data/workout_repository.dart';
import 'package:flutter/widgets.dart' show BuildContext, Localizations;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'home_dashboard_controller.g.dart';

enum RecoveryStatus { ready, needsRecovery }

/// One muscle group's recovery status, from `/api/recovery-map` (or the
/// `recoveryMap` embedded in a recommendation response) — see
/// `backend/src/services/recommendationEngine.js`'s `computeRecoveryMap`.
/// Purely "trained recently vs not" — no medical claim of any kind.
class MuscleGroupRecovery {
  const MuscleGroupRecovery({required this.group, required this.status});

  /// The backend's raw key: chest, back, legs, shoulders, arms, core,
  /// full_body, cardio — the UI maps this to a localized label.
  final String group;
  final RecoveryStatus status;

  static MuscleGroupRecovery _fromEntry(String group, dynamic json) {
    final status =
        json is Map && json['status'] == 'needs_recovery'
            ? RecoveryStatus.needsRecovery
            : RecoveryStatus.ready;
    return MuscleGroupRecovery(group: group, status: status);
  }

  static List<MuscleGroupRecovery> listFromJson(Map<String, dynamic>? json) {
    if (json == null) return const [];
    return [
      for (final entry in json.entries) _fromEntry(entry.key, entry.value),
    ];
  }
}

/// A recovery-safe alternative to the primary recommendation — surfaced
/// when the primary touches a muscle group that needs recovery and a
/// fully-recovered option is actually available (see
/// `pickRecommendedWorkout`'s `alternative` field).
class AlternativeWorkoutSuggestion {
  const AlternativeWorkoutSuggestion({
    required this.id,
    required this.title,
    required this.reasonCode,
    this.titleAr = '',
  });

  final String id;
  final String title;
  final String reasonCode;

  /// Arabic translation, from `Workout.titleAr` — empty when the admin
  /// hasn't translated this workout yet, in which case [localizedTitle]
  /// falls back to [title] (same pattern as `ArticleTip.localizedTitle`).
  final String titleAr;

  String localizedTitle(BuildContext context) =>
      Localizations.localeOf(context).languageCode == 'ar' && titleAr.isNotEmpty
          ? titleAr
          : title;

  static AlternativeWorkoutSuggestion? fromJson(Map<String, dynamic>? json) {
    if (json == null) return null;
    final workout = json['workout'] as Map<String, dynamic>?;
    if (workout == null) return null;
    return AlternativeWorkoutSuggestion(
      id: (workout['_id'] as String?) ?? '',
      title: (workout['title'] as String?) ?? '',
      reasonCode: (json['reasonCode'] as String?) ?? '',
      titleAr: (workout['titleAr'] as String?) ?? '',
    );
  }
}

/// Today's featured workout for the hero card — the whole document comes
/// from the backend's rule engine now (`GET /workouts/recommended`), not
/// client-side filtering; [reasonCode] and [recoveryMap] are enums/codes
/// the UI translates, never pre-rendered text from the server.
class HomeFeaturedWorkout {
  const HomeFeaturedWorkout({
    required this.id,
    required this.title,
    required this.durationMinutes,
    required this.estimatedCalories,
    required this.difficulty,
    required this.exerciseCount,
    required this.reasonCode,
    required this.recoveryMap,
    this.alternative,
    this.titleAr = '',
  });

  final String id;
  final String title;
  final int durationMinutes;
  final int estimatedCalories;
  final String difficulty;
  final int exerciseCount;
  final String reasonCode;
  final List<MuscleGroupRecovery> recoveryMap;
  final AlternativeWorkoutSuggestion? alternative;

  /// Arabic translation, from `Workout.titleAr` — empty when the admin
  /// hasn't translated this workout yet, in which case [localizedTitle]
  /// falls back to [title] (same pattern as `ArticleTip.localizedTitle`).
  final String titleAr;

  String localizedTitle(BuildContext context) =>
      Localizations.localeOf(context).languageCode == 'ar' && titleAr.isNotEmpty
          ? titleAr
          : title;
}

@riverpod
class HomeFeaturedWorkoutController extends _$HomeFeaturedWorkoutController {
  @override
  HomeFeaturedWorkout? build() {
    Future.microtask(_load);
    return null;
  }

  Future<void> _load({bool easier = false}) async {
    try {
      final data = await ref
          .read(workoutRepositoryProvider)
          .fetchRecommendedWorkout(
            easier: easier,
            excludeId: easier ? state?.id : null,
          );
      final workout = data['workout'] as Map<String, dynamic>?;
      if (workout == null) {
        state = null;
        return;
      }
      state = HomeFeaturedWorkout(
        id: (workout['_id'] as String?) ?? '',
        title: (workout['title'] as String?) ?? '',
        titleAr: (workout['titleAr'] as String?) ?? '',
        durationMinutes: (workout['durationMinutes'] as num?)?.toInt() ?? 0,
        estimatedCalories: (workout['estimatedCalories'] as num?)?.toInt() ?? 0,
        difficulty: (workout['difficulty'] as String?) ?? 'beginner',
        exerciseCount: (workout['exercises'] as List?)?.length ?? 0,
        reasonCode: (data['reasonCode'] as String?) ?? 'on_track',
        recoveryMap: MuscleGroupRecovery.listFromJson(
          data['recoveryMap'] as Map<String, dynamic>?,
        ),
        alternative: AlternativeWorkoutSuggestion.fromJson(
          data['alternative'] as Map<String, dynamic>?,
        ),
      );
      final shown = state;
      if (shown != null) {
        unawaited(
          ref.read(analyticsServiceProvider).logEvent(
            AnalyticsEvent.recommendationViewed,
            {
              'workoutId': shown.id,
              'reasonCode': shown.reasonCode,
              'durationMinutes': shown.durationMinutes,
            },
            // Same recommendation shown again (e.g. a widget rebuild, or
            // navigating back to Home) shouldn't log a second view — only
            // a genuinely different workout/reason combo counts as "viewed
            // again".
            '${shown.id}|${shown.reasonCode}',
          ),
        );
      }
    } catch (_) {
      // Left as-is — see WorkoutListByLevel for the same pattern.
    }
  }

  /// The "Too intense? Show an easier workout" action — forces the
  /// backend's difficulty-adjustment rule to `decrease` and excludes the
  /// currently-shown workout instead of re-picking the same one.
  Future<void> chooseEasierWorkout() async {
    final previousId = state?.id;
    unawaited(
      ref.read(analyticsServiceProvider).logEvent(
        AnalyticsEvent.easierWorkoutRequested,
        {if (previousId != null) 'workoutId': previousId},
      ),
    );
    await _load(easier: true);
  }

  /// Re-fetches today's recommendation from scratch — used by
  /// [refreshHomeProviders] (pull-to-refresh, and after anything that could
  /// change what "today's plan" should be).
  Future<void> refresh() => _load();
}

/// Standalone recovery-map fetch for the Home page's compact recovery row
/// — independent of [HomeFeaturedWorkoutController] so it still renders
/// even if that request fails, and so it isn't tied to any one
/// recommendation.
@riverpod
class RecoveryMapController extends _$RecoveryMapController {
  @override
  List<MuscleGroupRecovery> build() {
    Future.microtask(_load);
    return const [];
  }

  Future<void> _load() async {
    try {
      final json = await ref.read(workoutRepositoryProvider).fetchRecoveryMap();
      state = MuscleGroupRecovery.listFromJson(json);
    } catch (_) {
      // Left empty — see WorkoutListByLevel for the same pattern.
    }
  }

  Future<void> refresh() => _load();
}

/// This week's per-day trained minutes, built from `/api/workout-logs`, for
/// the weekly progress bar chart. Index 0 = Monday.
@riverpod
class WeeklyActivityController extends _$WeeklyActivityController {
  @override
  List<int> build() {
    Future.microtask(_load);
    return const [0, 0, 0, 0, 0, 0, 0];
  }

  Future<void> _load() async {
    try {
      final logs = await ref.read(workoutRepositoryProvider).fetchWorkoutLogs();
      final now = DateTime.now();
      final startOfWeek = DateTime(
        now.year,
        now.month,
        now.day,
      ).subtract(Duration(days: now.weekday - 1));

      final minutesByDay = List.filled(7, 0);
      for (final log in logs) {
        final completedAt = DateTime.tryParse(
          log['completedAt'] as String? ?? '',
        );
        if (completedAt == null) continue;
        final dayIndex = completedAt.difference(startOfWeek).inDays;
        if (dayIndex < 0 || dayIndex > 6) continue;
        minutesByDay[dayIndex] +=
            (log['durationMinutes'] as num?)?.toInt() ?? 0;
      }
      state = minutesByDay;
    } catch (_) {
      // Left at zeros — see WorkoutListByLevel for the same pattern.
    }
  }

  /// Today's total trained minutes — index of "now" within this week.
  int get todayMinutes {
    final todayIndex = DateTime.now().weekday - 1;
    return state[todayIndex];
  }

  Future<void> refresh() => _load();
}

/// The richer weekly-progress numbers (total minutes, week-over-week
/// comparison, longest streak, "any logs at all" for the empty state) —
/// kept as its own provider rather than folded into
/// [WeeklyActivityController] so that widget's existing, already-shipped
/// consumers (hero card, metrics grid) are untouched by this addition.
/// Costs one extra `fetchWorkoutLogs()` call, which is an accepted,
/// existing pattern in this codebase for independent per-feature fetches.
@riverpod
class WeeklyProgressStatsController extends _$WeeklyProgressStatsController {
  @override
  WeeklyProgressStats build() {
    Future.microtask(_load);
    return WeeklyProgressStats.empty;
  }

  Future<void> _load() async {
    try {
      final logs = await ref.read(workoutRepositoryProvider).fetchWorkoutLogs();
      state = computeWeeklyProgress(logs);
    } catch (_) {
      // Left at empty — see WorkoutListByLevel for the same pattern.
    }
  }

  Future<void> refresh() => _load();
}

/// Central "something important changed" refresh hook for the whole Home
/// screen. Invalidates every provider the hero card, weekly progress card,
/// and next-step card depend on, so a fresh watch anywhere on Home picks
/// up new data on its own — no app restart, no manual navigation. Used
/// after finishing/rating a workout, after saving workout preferences from
/// Edit Profile, and from Home's own pull-to-refresh.
///
/// Invalidating (rather than calling `.refresh()` directly) is deliberately
/// cheap and safe even when Home isn't the currently visible screen: an
/// unwatched autoDispose provider just discards its cached state and
/// recomputes lazily the next time something watches it.
void refreshHomeProviders(WidgetRef ref) {
  ref.invalidate(homeFeaturedWorkoutControllerProvider);
  ref.invalidate(recoveryMapControllerProvider);
  ref.invalidate(weeklyActivityControllerProvider);
  ref.invalidate(weeklyProgressStatsControllerProvider);
  ref.invalidate(currentUserProfileProvider);
  ref.invalidate(dailyNutritionSummaryControllerProvider);
}
