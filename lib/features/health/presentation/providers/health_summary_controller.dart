import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../data/health_repository.dart';
import '../../domain/health_models.dart';

part 'health_summary_controller.g.dart';

/// The last 14 days of health summaries plus the weekly insights
/// comparison (see `GET /api/health/summary`). An [AsyncNotifier] so
/// Home/Progress can show real loading/error/empty states and support
/// pull-to-refresh via [refresh].
@riverpod
class HealthSummaryController extends _$HealthSummaryController {
  @override
  Future<HealthOverview> build() => _load();

  Future<HealthOverview> _load() {
    final now = DateTime.now();
    final to = DateTime(now.year, now.month, now.day);
    final from = to.subtract(const Duration(days: 13));
    return ref.read(healthRepositoryProvider).fetchSummary(from: from, to: to);
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(_load);
  }
}
