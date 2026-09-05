import 'package:nabvera/core/analytics/event_dedupe_tracker.dart';
import 'package:nabvera/core/network/api_client.dart';
import 'package:nabvera/core/storage/preferences_service.dart';
import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'analytics_service.g.dart';

/// The only event names the backend accepts (see `backend/src/utils/
/// eventHelpers.js`'s `KNOWN_EVENT_NAMES`) — kept as an enum on this side
/// too so a call site can never typo a raw string past review.
enum AnalyticsEvent {
  recommendationViewed('recommendation_viewed'),
  workoutStarted('workout_started'),
  workoutCompleted('workout_completed'),
  workoutRated('workout_rated'),
  easierWorkoutRequested('easier_workout_requested'),
  alternativeWorkoutSelected('alternative_workout_selected'),
  workoutPreferencesUpdated('workout_preferences_updated'),
  challengeViewed('challenge_viewed'),
  challengeJoined('challenge_joined'),
  challengeLeft('challenge_left'),
  challengeCompleted('challenge_completed');

  const AnalyticsEvent(this.apiValue);
  final String apiValue;
}

/// Internal, best-effort product analytics — no external SDK, no AI. Every
/// call is fire-and-forget: a failed or slow analytics request must never
/// block or crash the feature that triggered it, so errors are swallowed
/// here rather than surfaced to the caller.
///
/// [properties] should only ever hold small, non-sensitive values (a
/// workout id, a reason code, a duration) — the backend enforces this with
/// its own allowlist regardless, but keep it that way from this side too,
/// and never pass email, weight, height, or detailed health-goal fields.
class AnalyticsService {
  AnalyticsService(this._client, this._preferences);

  final ApiClient _client;
  final PreferencesService _preferences;

  /// (event, dedupeKey) combos already sent this app session — see
  /// [logEvent]'s `dedupeKey` parameter. In-memory only (this service is a
  /// `keepAlive` singleton for the app's lifetime): a fresh app launch gets
  /// a fresh tracker, which is exactly "once per session".
  final EventDedupeTracker _dedupeTracker = EventDedupeTracker();

  Future<void> logEvent(
    AnalyticsEvent event, [
    Map<String, dynamic> properties = const {},
    // When provided, this exact (event, key) pair is sent at most once per
    // app session — e.g. the same workout recommendation shown across
    // several rebuilds shouldn't log `recommendation_viewed` every time.
    String? dedupeKey,
  ]) async {
    // Respects the "Usage analytics" toggle on the Manage Data page — an
    // opted-out user sends nothing at all, not even to the allowlisted
    // shape the backend otherwise accepts.
    if (!_preferences.analyticsEnabled) return;

    if (dedupeKey != null &&
        !_dedupeTracker.shouldSend(event.apiValue, dedupeKey)) {
      return;
    }

    try {
      await _client.post(
        '/events',
        body: {'name': event.apiValue, 'properties': properties},
      );
    } catch (error) {
      // Analytics is never allowed to disrupt the feature it's observing.
      debugPrint('Analytics event "${event.apiValue}" failed: $error');
    }
  }
}

@Riverpod(keepAlive: true)
AnalyticsService analyticsService(Ref ref) {
  return AnalyticsService(
    ref.watch(apiClientProvider),
    ref.watch(preferencesServiceProvider),
  );
}
