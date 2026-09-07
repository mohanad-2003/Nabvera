import 'dart:io' show Platform;

import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../data/health_repository.dart';
import '../../data/health_service.dart';
import '../../domain/health_models.dart';
import 'health_preferences_controller.dart';
import 'health_summary_controller.dart';

part 'health_sync_controller.g.dart';

/// Outcome of [HealthSyncController.connectAndSync] — the onboarding
/// screen renders a distinct state for each (see the Phase 7 brief's
/// explicit requirement for a clear "denied" and "not available" state).
enum HealthConnectResult { success, permissionDenied, platformUnavailable }

/// Orchestrates connecting to and syncing from the device's health store.
/// Never reads/writes anything if the user hasn't opted in — every path
/// here either starts from an explicit "Connect" tap or is a no-op when
/// `syncEnabled` is false (see [syncNow]).
@Riverpod(keepAlive: true)
class HealthSyncController extends _$HealthSyncController {
  @override
  FutureOr<void> build() {}

  /// Requests permission for exactly [kinds], and — only on success —
  /// saves preferences enabling exactly those and performs the first
  /// sync. Never requests a data type the user didn't select.
  Future<HealthConnectResult> connectAndSync(Set<HealthDataKind> kinds) async {
    final service = ref.read(healthServiceProvider);

    if (!await service.isPlatformAvailable()) {
      return HealthConnectResult.platformUnavailable;
    }

    final granted = await service.requestPermissions(kinds);
    if (!granted) return HealthConnectResult.permissionDenied;

    await ref
        .read(healthPreferencesControllerProvider.notifier)
        .save(
          HealthPreferences(
            syncEnabled: true,
            shareSteps: kinds.contains(HealthDataKind.steps),
            shareActivity: kinds.contains(HealthDataKind.activity),
            shareSleep: kinds.contains(HealthDataKind.sleep),
          ),
        );

    await syncNow();
    return HealthConnectResult.success;
  }

  /// Manual (pull-to-refresh) or post-connect sync — a no-op whenever sync
  /// is off or no data type is selected, so it's always safe to call.
  Future<void> syncNow() async {
    final prefs = await ref.read(healthPreferencesControllerProvider.future);
    if (!prefs.syncEnabled || !prefs.hasAnyDataTypeSelected) return;

    final kinds = <HealthDataKind>{
      if (prefs.shareSteps) HealthDataKind.steps,
      if (prefs.shareActivity) HealthDataKind.activity,
      if (prefs.shareSleep) HealthDataKind.sleep,
    };

    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final service = ref.read(healthServiceProvider);
      final days = await service.fetchDailyMetrics(kinds: kinds, days: 14);
      final source = Platform.isIOS ? 'healthkit' : 'health_connect';
      await ref.read(healthRepositoryProvider).sync(source: source, days: days);

      ref.invalidate(healthSummaryControllerProvider);
      ref.invalidate(healthPreferencesControllerProvider);
    });
  }

  /// Turns sync off and deletes every stored summary — the "disconnect
  /// and forget" action on the Health Data Settings screen.
  Future<void> disconnectAndDeleteData() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await ref.read(healthRepositoryProvider).deleteHealthData();
      await ref
          .read(healthPreferencesControllerProvider.notifier)
          .disableSync();
      ref.invalidate(healthSummaryControllerProvider);
    });
  }
}
