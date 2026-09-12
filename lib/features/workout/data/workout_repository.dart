import 'package:nabvera/core/network/api_client.dart';
import 'package:nabvera/features/workout/domain/difficulty_rating.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'workout_repository.g.dart';

/// Talks to `/api/workouts`, `/api/exercises`, `/api/routines`, and
/// `/api/workout-logs` (see the matching files under `backend/src/routes`).
/// Returns raw decoded JSON — each feature provider maps it into its own
/// display model, since the UI's shapes (formatted strings, curated enums)
/// don't mirror the backend documents 1:1.
class WorkoutRepository {
  WorkoutRepository(this._client);

  final ApiClient _client;

  Future<List<Map<String, dynamic>>> fetchWorkouts({
    String? difficulty,
    String? category,
    bool? featured,
    bool? popular,
  }) async {
    final params = <String, String>{
      if (difficulty != null) 'difficulty': difficulty,
      if (category != null) 'category': category,
      if (featured != null) 'featured': '$featured',
      if (popular != null) 'popular': '$popular',
    };
    final query = params.isEmpty ? '' : '?${Uri(queryParameters: params).query}';
    final response = await _client.get('/workouts$query');
    final body = _client.decode(response);
    return (body['data'] as List).cast<Map<String, dynamic>>();
  }

  Future<Map<String, dynamic>> fetchWorkoutById(String id) async {
    final response = await _client.get('/workouts/$id');
    final body = _client.decode(response);
    return body['data'] as Map<String, dynamic>;
  }

  Future<List<Map<String, dynamic>>> fetchExercises() async {
    final response = await _client.get('/exercises');
    final body = _client.decode(response);
    return (body['data'] as List).cast<Map<String, dynamic>>();
  }

  Future<List<Map<String, dynamic>>> fetchRoutines() async {
    final response = await _client.get('/routines');
    final body = _client.decode(response);
    return (body['data'] as List).cast<Map<String, dynamic>>();
  }

  Future<Map<String, dynamic>> createRoutine(
    Map<String, dynamic> payload,
  ) async {
    final response = await _client.post('/routines', body: payload);
    final body = _client.decode(response);
    return body['data'] as Map<String, dynamic>;
  }

  Future<void> deleteRoutine(String id) async {
    final response = await _client.delete('/routines/$id');
    _client.decode(response);
  }

  Future<List<Map<String, dynamic>>> fetchWorkoutLogs() async {
    final response = await _client.get('/workout-logs');
    final body = _client.decode(response);
    return (body['data'] as List).cast<Map<String, dynamic>>();
  }

  /// Logs a finished workout — the `muscleGroups` snapshot used by the
  /// (future) recovery map is computed server-side from the workout's own
  /// exercises, not sent from here. [difficultyRating] is optional: the
  /// rating sheet lets the user skip it entirely.
  Future<Map<String, dynamic>> createWorkoutLog({
    required String title,
    required int durationMinutes,
    required int caloriesBurned,
    String? workoutId,
    DifficultyRating? difficultyRating,
    int? actualDurationMinutes,
  }) async {
    final response = await _client.post(
      '/workout-logs',
      body: {
        'title': title,
        'durationMinutes': durationMinutes,
        'caloriesBurned': caloriesBurned,
        if (workoutId != null) 'workout': workoutId,
        if (difficultyRating != null)
          'difficultyRating': difficultyRating.apiValue,
        if (actualDurationMinutes != null)
          'actualDurationMinutes': actualDurationMinutes,
      },
    );
    final body = _client.decode(response);
    return body['data'] as Map<String, dynamic>;
  }

  /// Attaches a difficulty rating to a log the user rates after the fact
  /// (they skipped the prompt when finishing the workout).
  Future<Map<String, dynamic>> updateWorkoutLogRating({
    required String logId,
    required DifficultyRating rating,
  }) async {
    final response = await _client.patch(
      '/workout-logs/$logId/rating',
      body: {'difficultyRating': rating.apiValue},
    );
    final body = _client.decode(response);
    return body['data'] as Map<String, dynamic>;
  }

  /// The rule-based recommendation from `backend/src/services/
  /// recommendationEngine.js` — a `{ workout, reasonCode, recoveryMap,
  /// alternative }` document. [easier] mirrors the old client-side "show an
  /// easier workout" action; [excludeId] skips a specific workout (the one
  /// already shown) when picking.
  Future<Map<String, dynamic>> fetchRecommendedWorkout({
    bool easier = false,
    String? excludeId,
  }) async {
    final params = <String, String>{
      if (easier) 'easier': 'true',
      if (excludeId != null && excludeId.isNotEmpty) 'excludeId': excludeId,
    };
    final query =
        params.isEmpty ? '' : '?${Uri(queryParameters: params).query}';
    final response = await _client.get('/workouts/recommended$query');
    final body = _client.decode(response);
    return body['data'] as Map<String, dynamic>;
  }

  /// Per-muscle-group `{ status, lastTrainedAt }` from the last 48h of
  /// workout logs — same shape as the `recoveryMap` field embedded in
  /// [fetchRecommendedWorkout]'s response.
  Future<Map<String, dynamic>> fetchRecoveryMap() async {
    final response = await _client.get('/recovery-map');
    final body = _client.decode(response);
    return body['data'] as Map<String, dynamic>;
  }
}

@Riverpod(keepAlive: true)
WorkoutRepository workoutRepository(Ref ref) {
  return WorkoutRepository(ref.watch(apiClientProvider));
}
