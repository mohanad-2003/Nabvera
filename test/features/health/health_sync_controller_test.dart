import 'package:nabvera/features/health/data/health_repository.dart';
import 'package:nabvera/features/health/data/health_service.dart';
import 'package:nabvera/features/health/domain/health_models.dart';
import 'package:nabvera/features/health/presentation/providers/health_sync_controller.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

/// A hand-written test double for [HealthService] — this is exactly what
/// isolating platform calls behind the interface buys: no platform
/// channel, no device, no real Health Connect/HealthKit involved.
class FakeHealthService implements HealthService {
  FakeHealthService({this.available = true, this.permissionGranted = true});

  bool available;
  bool permissionGranted;
  Set<HealthDataKind>? requestedKinds;

  @override
  Future<bool> isPlatformAvailable() async => available;

  @override
  Future<void> openPlatformInstall() async {}

  @override
  Future<bool> requestPermissions(Set<HealthDataKind> kinds) async {
    requestedKinds = kinds;
    return permissionGranted;
  }

  @override
  Future<List<HealthMetricsDay>> fetchDailyMetrics({required Set<HealthDataKind> kinds, required int days}) async {
    return [HealthMetricsDay(date: DateTime(2026, 9, 6), steps: 5000)];
  }
}

class FakeHealthRepository implements HealthRepository {
  HealthPreferences preferences = const HealthPreferences();
  bool syncCalled = false;

  @override
  Future<HealthPreferences> fetchPreferences() async => preferences;

  @override
  Future<HealthPreferences> updatePreferences(Map<String, dynamic> payload) async {
    preferences = HealthPreferences(
      syncEnabled: payload['syncEnabled'] as bool? ?? preferences.syncEnabled,
      shareSteps: payload['shareSteps'] as bool? ?? preferences.shareSteps,
      shareActivity: payload['shareActivity'] as bool? ?? preferences.shareActivity,
      shareSleep: payload['shareSleep'] as bool? ?? preferences.shareSleep,
      lastSyncedAt: preferences.lastSyncedAt,
    );
    return preferences;
  }

  @override
  Future<HealthOverview> fetchSummary({required DateTime from, required DateTime to}) async => HealthOverview.empty;

  @override
  Future<void> sync({required String source, required List<HealthMetricsDay> days}) async {
    syncCalled = true;
  }

  @override
  Future<void> deleteHealthData() async {}
}

void main() {
  test('connectAndSync returns platformUnavailable and never requests permission when Health Connect/HealthKit is missing', () async {
    final fakeService = FakeHealthService(available: false);
    final container = ProviderContainer(overrides: [
      healthServiceProvider.overrideWithValue(fakeService),
      healthRepositoryProvider.overrideWithValue(FakeHealthRepository()),
    ]);
    addTearDown(container.dispose);

    final result = await container.read(healthSyncControllerProvider.notifier).connectAndSync({HealthDataKind.steps});

    expect(result, HealthConnectResult.platformUnavailable);
    expect(fakeService.requestedKinds, isNull);
  });

  test('connectAndSync returns permissionDenied and does not enable sync when the user declines', () async {
    final fakeService = FakeHealthService(permissionGranted: false);
    final fakeRepo = FakeHealthRepository();
    final container = ProviderContainer(overrides: [
      healthServiceProvider.overrideWithValue(fakeService),
      healthRepositoryProvider.overrideWithValue(fakeRepo),
    ]);
    addTearDown(container.dispose);

    final result = await container.read(healthSyncControllerProvider.notifier).connectAndSync({HealthDataKind.steps});

    expect(result, HealthConnectResult.permissionDenied);
    expect(fakeRepo.syncCalled, isFalse);
    expect(fakeRepo.preferences.syncEnabled, isFalse);
  });

  test('connectAndSync requests only the selected kinds, enables matching preferences, and syncs on success', () async {
    final fakeService = FakeHealthService();
    final fakeRepo = FakeHealthRepository();
    final container = ProviderContainer(overrides: [
      healthServiceProvider.overrideWithValue(fakeService),
      healthRepositoryProvider.overrideWithValue(fakeRepo),
    ]);
    addTearDown(container.dispose);

    final result = await container
        .read(healthSyncControllerProvider.notifier)
        .connectAndSync({HealthDataKind.steps, HealthDataKind.sleep});

    expect(result, HealthConnectResult.success);
    expect(fakeService.requestedKinds, {HealthDataKind.steps, HealthDataKind.sleep});
    expect(fakeRepo.preferences.syncEnabled, isTrue);
    expect(fakeRepo.preferences.shareSteps, isTrue);
    expect(fakeRepo.preferences.shareSleep, isTrue);
    expect(fakeRepo.preferences.shareActivity, isFalse);
    expect(fakeRepo.syncCalled, isTrue);
  });

  test('syncNow is a no-op when sync is disabled, even if called directly', () async {
    final fakeService = FakeHealthService();
    final fakeRepo = FakeHealthRepository()..preferences = const HealthPreferences(syncEnabled: false);
    final container = ProviderContainer(overrides: [
      healthServiceProvider.overrideWithValue(fakeService),
      healthRepositoryProvider.overrideWithValue(fakeRepo),
    ]);
    addTearDown(container.dispose);

    await container.read(healthSyncControllerProvider.notifier).syncNow();

    expect(fakeRepo.syncCalled, isFalse);
  });
}
