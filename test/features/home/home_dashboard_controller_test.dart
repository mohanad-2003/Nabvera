import 'package:nabvera/features/home/presentation/providers/home_dashboard_controller.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('MuscleGroupRecovery.listFromJson', () {
    test('parses each group\'s status correctly', () {
      final list = MuscleGroupRecovery.listFromJson({
        'chest': {'status': 'needs_recovery', 'lastTrainedAt': '2026-01-01T00:00:00.000Z'},
        'legs': {'status': 'ready', 'lastTrainedAt': null},
      });

      final chest = list.firstWhere((g) => g.group == 'chest');
      final legs = list.firstWhere((g) => g.group == 'legs');
      expect(chest.status, RecoveryStatus.needsRecovery);
      expect(legs.status, RecoveryStatus.ready);
    });

    test('returns an empty list for null input', () {
      expect(MuscleGroupRecovery.listFromJson(null), isEmpty);
    });

    test('treats a missing/unrecognized status as ready (never blocks by default)', () {
      final list = MuscleGroupRecovery.listFromJson({
        'core': <String, dynamic>{},
      });
      expect(list.single.status, RecoveryStatus.ready);
    });
  });

  group('AlternativeWorkoutSuggestion.fromJson', () {
    test('parses a full alternative document', () {
      final alt = AlternativeWorkoutSuggestion.fromJson({
        'workout': {'_id': 'w1', 'title': 'Leg Day'},
        'reasonCode': 'muscle_recovery_alternative',
      });
      expect(alt, isNotNull);
      expect(alt!.id, 'w1');
      expect(alt.title, 'Leg Day');
      expect(alt.reasonCode, 'muscle_recovery_alternative');
    });

    test('returns null for a null or workout-less document', () {
      expect(AlternativeWorkoutSuggestion.fromJson(null), isNull);
      expect(AlternativeWorkoutSuggestion.fromJson({'reasonCode': 'x'}), isNull);
    });
  });
}
