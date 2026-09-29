import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/network/api_client.dart';

part 'coach_repository.g.dart';

/// Talks to `/api/coach/chat` (see `backend/src/routes/coachRoutes.js`) —
/// the AI fitness/nutrition coach chat.
class CoachRepository {
  CoachRepository(this._client);

  final ApiClient _client;

  // A chat reply goes through an LLM call server-side, same reasoning as
  // NutritionRepository's meal-plan generation — comfortably longer than
  // the default ApiClient timeout.
  static const _aiTimeout = Duration(seconds: 45);

  Future<String> sendMessage(
    String message,
    List<Map<String, String>> history,
  ) async {
    final response = await _client.post(
      '/coach/chat',
      body: {'message': message, 'history': history},
      timeout: _aiTimeout,
    );
    final body = _client.decode(response);
    return (body['data'] as Map<String, dynamic>)['reply'] as String;
  }
}

@Riverpod(keepAlive: true)
CoachRepository coachRepository(Ref ref) {
  return CoachRepository(ref.watch(apiClientProvider));
}
