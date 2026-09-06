import 'package:nabvera/features/health/domain/health_models.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('HealthMetricsDay', () {
    test('fromJson parses present fields and leaves missing ones null (never 0)', () {
      final day = HealthMetricsDay.fromJson({
        'date': '2026-09-06T00:00:00.000Z',
        'steps': 8000,
        'activeMinutes': 30,
      });
      expect(day.steps, 8000);
      expect(day.activeMinutes, 30);
      expect(day.activeCalories, isNull);
      expect(day.sleepMinutes, isNull);
    });

    test('toSyncJson only includes non-null fields, formatted as YYYY-MM-DD', () {
      final day = HealthMetricsDay(date: DateTime(2026, 9, 6), steps: 5000);
      final json = day.toSyncJson();
      expect(json['date'], '2026-09-06');
      expect(json['steps'], 5000);
      expect(json.containsKey('activeMinutes'), isFalse);
      expect(json.containsKey('sleepMinutes'), isFalse);
    });
  });

  group('HealthPreferences', () {
    test('defaults to fully opted-out', () {
      const prefs = HealthPreferences();
      expect(prefs.syncEnabled, isFalse);
      expect(prefs.hasAnyDataTypeSelected, isFalse);
    });

    test('fromJson/toJson round-trips the sharing flags', () {
      final prefs = HealthPreferences.fromJson({
        'syncEnabled': true,
        'shareSteps': true,
        'shareActivity': false,
        'shareSleep': true,
        'lastSyncedAt': '2026-09-06T08:00:00.000Z',
      });
      expect(prefs.syncEnabled, isTrue);
      expect(prefs.hasAnyDataTypeSelected, isTrue);
      expect(prefs.lastSyncedAt, isNotNull);

      final json = prefs.toJson();
      expect(json['shareSteps'], true);
      expect(json['shareActivity'], false);
      // lastSyncedAt is server-computed, never sent back by the client.
      expect(json.containsKey('lastSyncedAt'), isFalse);
    });

    test('copyWith changes only the given fields', () {
      const prefs = HealthPreferences(syncEnabled: true, shareSteps: true);
      final updated = prefs.copyWith(shareActivity: true);
      expect(updated.syncEnabled, isTrue);
      expect(updated.shareSteps, isTrue);
      expect(updated.shareActivity, isTrue);
    });
  });

  group('HealthOverview / HealthInsights', () {
    test('fromJson parses days and insight codes together', () {
      final overview = HealthOverview.fromJson({
        'days': [
          {'date': '2026-09-05T00:00:00.000Z', 'steps': 7000},
          {'date': '2026-09-06T00:00:00.000Z', 'steps': 9000},
        ],
        'insights': {
          'codes': ['activity_up', 'keep_momentum'],
          'currentWeek': {'avgSteps': 9000},
          'previousWeek': {'avgSteps': 7000},
          'disclaimerCode': 'not_medical_advice',
        },
      });
      expect(overview.days, hasLength(2));
      expect(overview.today?.steps, 9000);
      expect(overview.insights.codes, ['activity_up', 'keep_momentum']);
      expect(overview.insights.avgStepsCurrent, 9000);
      expect(overview.insights.avgStepsPrevious, 7000);
    });

    test('HealthOverview.empty has no days and no insight codes', () {
      expect(HealthOverview.empty.days, isEmpty);
      expect(HealthOverview.empty.today, isNull);
      expect(HealthOverview.empty.insights.codes, isEmpty);
    });
  });
}
