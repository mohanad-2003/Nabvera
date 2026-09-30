import 'dart:io' show Platform;

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:health/health.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../domain/health_models.dart';

part 'health_service.g.dart';

/// The three data kinds this phase reads — steps, activity (active
/// minutes/calories), and sleep. Deliberately nothing else (no heart
/// rate, no location, no other vitals) — see the Phase 7 brief's explicit
/// scope limit.
enum HealthDataKind { steps, activity, sleep }

/// `EXERCISE_TIME` is an Apple HealthKit-only concept — the `health`
/// package's Android/Health Connect implementation has no mapping for it
/// at all (confirmed in its own source: absent from `dataTypeKeysAndroid`
/// and from every Kotlin data-type map). Requesting it on Android doesn't
/// just skip that one type — Health Connect rejects the *whole*
/// permission request, which is why every "Connect" tap failed with
/// "Datatype EXERCISE_TIME not found in HC" and a denied result. Active
/// minutes are simply unavailable on Android for now; active calories
/// still work everywhere.
List<HealthDataType> typesForHealthDataKind(HealthDataKind kind) => switch (kind) {
  HealthDataKind.steps => [HealthDataType.STEPS],
  HealthDataKind.activity => [
    HealthDataType.ACTIVE_ENERGY_BURNED,
    if (!kIsWeb && Platform.isIOS) HealthDataType.EXERCISE_TIME,
  ],
  HealthDataKind.sleep => [HealthDataType.SLEEP_ASLEEP],
};

/// Platform abstraction over Health Connect (Android) / HealthKit (iOS) —
/// every call to `package:health` is behind this interface specifically so
/// it can be swapped for a fake in tests (see health_service_test.dart)
/// without ever touching a real platform channel.
abstract class HealthService {
  /// False on Android when Health Connect isn't installed. Always true on
  /// iOS (HealthKit ships with the OS). Never throws.
  Future<bool> isPlatformAvailable();

  /// Opens the Play Store listing for Health Connect (Android only; a
  /// no-op on iOS).
  Future<void> openPlatformInstall();

  /// Requests read access for exactly the given [kinds] — never all three
  /// at once unless the caller asks for all three. Returns false if the
  /// user declined (or, on iOS, if the result can't be determined — see
  /// the `health` package's own caveat that HealthKit never discloses
  /// read-grant status for privacy reasons).
  Future<bool> requestPermissions(Set<HealthDataKind> kinds);

  /// Reads the last [days] calendar days (today inclusive) for the given
  /// [kinds] and buckets them into one [HealthMetricsDay] per day.
  Future<List<HealthMetricsDay>> fetchDailyMetrics({required Set<HealthDataKind> kinds, required int days});
}

/// Real implementation, backed by `package:health`. Kept thin — all the
/// actual bucketing logic is in the pure top-level functions below so it's
/// testable without a device.
class PluginHealthService implements HealthService {
  PluginHealthService([Health? health]) : _health = health ?? Health();

  final Health _health;
  bool _configured = false;

  Future<void> _ensureConfigured() async {
    if (_configured) return;
    await _health.configure();
    _configured = true;
  }

  List<HealthDataType> _typesFor(Set<HealthDataKind> kinds) =>
      kinds.expand(typesForHealthDataKind).toList();

  @override
  Future<bool> isPlatformAvailable() async {
    await _ensureConfigured();
    try {
      return await _health.isHealthConnectAvailable();
    } catch (_) {
      return false;
    }
  }

  @override
  Future<void> openPlatformInstall() async {
    await _ensureConfigured();
    await _health.installHealthConnect();
  }

  @override
  Future<bool> requestPermissions(Set<HealthDataKind> kinds) async {
    if (kinds.isEmpty) return false;
    await _ensureConfigured();

    // Android's Steps/Exercise data sits behind the Activity Recognition
    // runtime permission — requested here, right before the Health
    // Connect prompt, never on app launch (see AndroidManifest.xml).
    if (kinds.contains(HealthDataKind.steps) || kinds.contains(HealthDataKind.activity)) {
      await Permission.activityRecognition.request();
    }

    final types = _typesFor(kinds);
    try {
      return await _health.requestAuthorization(types);
    } catch (_) {
      return false;
    }
  }

  @override
  Future<List<HealthMetricsDay>> fetchDailyMetrics({required Set<HealthDataKind> kinds, required int days}) async {
    await _ensureConfigured();
    final types = _typesFor(kinds);
    if (types.isEmpty) return [];

    final now = DateTime.now();
    final start = DateTime(now.year, now.month, now.day).subtract(Duration(days: days - 1));

    List<HealthDataPoint> points;
    try {
      points = await _health.getHealthDataFromTypes(types: types, startTime: start, endTime: now);
    } catch (_) {
      return [];
    }

    return bucketHealthPointsByDay(points: points, start: start, days: days);
  }
}

/// Groups raw [HealthDataPoint]s into one [HealthMetricsDay] per calendar
/// day (local time), from [start] for [days] days. A pure function — kept
/// separate from [PluginHealthService] so it's unit-testable without any
/// platform channel involved, using real `HealthDataPoint` instances built
/// with plain constructors.
List<HealthMetricsDay> bucketHealthPointsByDay({
  required List<HealthDataPoint> points,
  required DateTime start,
  required int days,
}) {
  final buckets = List.generate(days, (i) => start.add(Duration(days: i)));
  final steps = List<int>.filled(days, 0);
  final activeMinutes = List<int>.filled(days, 0);
  final activeCalories = List<int>.filled(days, 0);
  final sleepMinutes = List<int>.filled(days, 0);
  final hasSteps = List<bool>.filled(days, false);
  final hasActivity = List<bool>.filled(days, false);
  final hasSleep = List<bool>.filled(days, false);

  int? dayIndexFor(DateTime at) {
    final day = DateTime(at.year, at.month, at.day);
    final index = day.difference(buckets.first).inDays;
    return (index >= 0 && index < days) ? index : null;
  }

  for (final point in points) {
    final index = dayIndexFor(point.dateFrom);
    if (index == null) continue;

    final value = point.value;
    final numeric = value is NumericHealthValue ? value.numericValue.toInt() : null;

    switch (point.type) {
      case HealthDataType.STEPS:
        if (numeric != null) {
          steps[index] += numeric;
          hasSteps[index] = true;
        }
      case HealthDataType.ACTIVE_ENERGY_BURNED:
        if (numeric != null) {
          activeCalories[index] += numeric;
          hasActivity[index] = true;
        }
      case HealthDataType.EXERCISE_TIME:
        final minutes = numeric ?? point.dateTo.difference(point.dateFrom).inMinutes;
        activeMinutes[index] += minutes;
        hasActivity[index] = true;
      case HealthDataType.SLEEP_ASLEEP:
        sleepMinutes[index] += point.dateTo.difference(point.dateFrom).inMinutes;
        hasSleep[index] = true;
      default:
        break;
    }
  }

  return List.generate(
    days,
    (i) => HealthMetricsDay(
      date: buckets[i],
      steps: hasSteps[i] ? steps[i] : null,
      activeMinutes: hasActivity[i] ? activeMinutes[i] : null,
      activeCalories: hasActivity[i] ? activeCalories[i] : null,
      sleepMinutes: hasSleep[i] ? sleepMinutes[i] : null,
    ),
  );
}

/// `package:health` has no web implementation at all — every call to it
/// (even `configure()`) throws `MissingPluginException` there, so
/// [PluginHealthService] can't be used as-is on web. This stands in as a
/// permanently-unavailable [HealthService] instead, matching how a real
/// device with no Health Connect installed already behaves for callers.
class UnsupportedHealthService implements HealthService {
  @override
  Future<bool> isPlatformAvailable() async => false;

  @override
  Future<void> openPlatformInstall() async {}

  @override
  Future<bool> requestPermissions(Set<HealthDataKind> kinds) async => false;

  @override
  Future<List<HealthMetricsDay>> fetchDailyMetrics({
    required Set<HealthDataKind> kinds,
    required int days,
  }) async => [];
}

@Riverpod(keepAlive: true)
HealthService healthService(Ref ref) =>
    kIsWeb ? UnsupportedHealthService() : PluginHealthService();
