import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../data/health_repository.dart';
import '../../domain/health_models.dart';

part 'health_preferences_controller.g.dart';

/// Loads and saves `/api/health/preferences`. An [AsyncNotifier] so the
/// Health Data Settings screen shows a real loading/error state.
@riverpod
class HealthPreferencesController extends _$HealthPreferencesController {
  @override
  Future<HealthPreferences> build() => ref.read(healthRepositoryProvider).fetchPreferences();

  Future<void> save(HealthPreferences preferences) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(
      () => ref.read(healthRepositoryProvider).updatePreferences(preferences.toJson()),
    );
  }

  /// Turns sync off entirely — a one-tap "disconnect" distinct from
  /// deleting already-stored data (see [HealthSyncController.disconnectAndDeleteData]).
  Future<void> disableSync() async {
    final current = state.value ?? const HealthPreferences();
    await save(current.copyWith(syncEnabled: false, shareSteps: false, shareActivity: false, shareSleep: false));
  }
}
