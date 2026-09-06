import 'package:health/health.dart';
import 'package:nabvera/features/health/data/health_service.dart';
import 'package:flutter_test/flutter_test.dart';

HealthDataPoint _point({
  required HealthDataType type,
  required num value,
  required DateTime dateFrom,
  required DateTime dateTo,
}) {
  return HealthDataPoint(
    uuid: 'u',
    value: NumericHealthValue(numericValue: value),
    type: type,
    unit: HealthDataUnit.NO_UNIT,
    dateFrom: dateFrom,
    dateTo: dateTo,
    sourcePlatform: HealthPlatformType.googleHealthConnect,
    sourceDeviceId: 'device',
    sourceId: 'source',
    sourceName: 'source',
  );
}

void main() {
  group('bucketHealthPointsByDay', () {
    test('sums steps per calendar day', () {
      final start = DateTime(2026, 9, 1);
      final points = [
        _point(type: HealthDataType.STEPS, value: 3000, dateFrom: DateTime(2026, 9, 1, 8), dateTo: DateTime(2026, 9, 1, 9)),
        _point(type: HealthDataType.STEPS, value: 4000, dateFrom: DateTime(2026, 9, 1, 18), dateTo: DateTime(2026, 9, 1, 19)),
        _point(type: HealthDataType.STEPS, value: 5000, dateFrom: DateTime(2026, 9, 2, 8), dateTo: DateTime(2026, 9, 2, 9)),
      ];
      final days = bucketHealthPointsByDay(points: points, start: start, days: 2);
      expect(days, hasLength(2));
      expect(days[0].steps, 7000);
      expect(days[1].steps, 5000);
    });

    test('a day with no matching points has null (not zero) for that metric', () {
      final start = DateTime(2026, 9, 1);
      final days = bucketHealthPointsByDay(points: const [], start: start, days: 3);
      for (final day in days) {
        expect(day.steps, isNull);
        expect(day.activeMinutes, isNull);
        expect(day.sleepMinutes, isNull);
      }
    });

    test('EXERCISE_TIME contributes to activeMinutes and ACTIVE_ENERGY_BURNED to activeCalories, both under "activity"', () {
      final start = DateTime(2026, 9, 1);
      final points = [
        _point(type: HealthDataType.EXERCISE_TIME, value: 30, dateFrom: DateTime(2026, 9, 1, 7), dateTo: DateTime(2026, 9, 1, 7, 30)),
        _point(type: HealthDataType.ACTIVE_ENERGY_BURNED, value: 250, dateFrom: DateTime(2026, 9, 1, 7), dateTo: DateTime(2026, 9, 1, 7, 30)),
      ];
      final days = bucketHealthPointsByDay(points: points, start: start, days: 1);
      expect(days[0].activeMinutes, 30);
      expect(days[0].activeCalories, 250);
    });

    test('SLEEP_ASLEEP durations across the same day are summed in minutes', () {
      final start = DateTime(2026, 9, 1);
      final points = [
        _point(type: HealthDataType.SLEEP_ASLEEP, value: 0, dateFrom: DateTime(2026, 9, 1, 23), dateTo: DateTime(2026, 9, 1, 23, 30)),
      ];
      final days = bucketHealthPointsByDay(points: points, start: start, days: 1);
      expect(days[0].sleepMinutes, 30);
    });

    test('points outside the [start, start+days) window are ignored', () {
      final start = DateTime(2026, 9, 1);
      final points = [
        _point(type: HealthDataType.STEPS, value: 1000, dateFrom: DateTime(2026, 8, 31, 8), dateTo: DateTime(2026, 8, 31, 9)),
        _point(type: HealthDataType.STEPS, value: 2000, dateFrom: DateTime(2026, 9, 5, 8), dateTo: DateTime(2026, 9, 5, 9)),
      ];
      final days = bucketHealthPointsByDay(points: points, start: start, days: 2);
      expect(days[0].steps, isNull);
      expect(days[1].steps, isNull);
    });
  });

  group('HealthDataKind', () {
    test('has exactly the three in-scope kinds — no heart rate, no location', () {
      expect(HealthDataKind.values, [HealthDataKind.steps, HealthDataKind.activity, HealthDataKind.sleep]);
    });
  });
}
