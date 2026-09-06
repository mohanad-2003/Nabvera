import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/network/api_client.dart';
import '../domain/health_models.dart';

part 'health_repository.g.dart';

/// Talks to `/api/health/...` (see `backend/src/routes/healthRoutes.js`).
/// Returns decoded domain models — the platform-side reading of Health
/// Connect/HealthKit itself lives in [HealthService], kept entirely
/// separate so each side can be mocked independently.
class HealthRepository {
  HealthRepository(this._client);

  final ApiClient _client;

  Future<HealthPreferences> fetchPreferences() async {
    final response = await _client.get('/health/preferences');
    final body = _client.decode(response);
    return HealthPreferences.fromJson(body['data'] as Map<String, dynamic>);
  }

  Future<HealthPreferences> updatePreferences(Map<String, dynamic> payload) async {
    final response = await _client.patch('/health/preferences', body: payload);
    final body = _client.decode(response);
    return HealthPreferences.fromJson(body['data'] as Map<String, dynamic>);
  }

  Future<HealthOverview> fetchSummary({required DateTime from, required DateTime to}) async {
    String dateKey(DateTime d) =>
        '${d.year.toString().padLeft(4, '0')}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';
    final response = await _client.get('/health/summary?from=${dateKey(from)}&to=${dateKey(to)}');
    final body = _client.decode(response);
    return HealthOverview.fromJson(body['data'] as Map<String, dynamic>);
  }

  Future<void> sync({required String source, required List<HealthMetricsDay> days}) async {
    final response = await _client.post(
      '/health/sync',
      body: {'source': source, 'days': days.map((d) => d.toSyncJson()).toList()},
    );
    _client.decode(response);
  }

  Future<void> deleteHealthData() async {
    final response = await _client.delete('/health/data');
    _client.decode(response);
  }
}

@Riverpod(keepAlive: true)
HealthRepository healthRepository(Ref ref) => HealthRepository(ref.watch(apiClientProvider));
