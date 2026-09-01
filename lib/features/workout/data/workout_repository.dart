import 'package:fitness_app/core/network/api_client.dart';
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
    bool? featured,
    bool? popular,
  }) async {
    final params = <String, String>{
      if (difficulty != null) 'difficulty': difficulty,
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

  Future<List<Map<String, dynamic>>> fetchWorkoutLogs() async {
    final response = await _client.get('/workout-logs');
    final body = _client.decode(response);
    return (body['data'] as List).cast<Map<String, dynamic>>();
  }
}

@Riverpod(keepAlive: true)
WorkoutRepository workoutRepository(Ref ref) {
  return WorkoutRepository(ref.watch(apiClientProvider));
}
