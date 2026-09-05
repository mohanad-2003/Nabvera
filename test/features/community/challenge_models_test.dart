import 'package:nabvera/features/community/domain/community_models.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ChallengeItem.fromJson', () {
    test('parses every field, including type/targetValue', () {
      final item = ChallengeItem.fromJson({
        '_id': 'c1',
        'name': '30-Day Push',
        'details': 'Complete 10 workouts',
        'imageUrl': 'assets/workout.png',
        'durationLabel': '30 days',
        'caloriesLabel': '5000 kcal',
        'type': 'workouts_count',
        'targetValue': 10,
      });

      expect(item.id, 'c1');
      expect(item.name, '30-Day Push');
      expect(item.type, 'workouts_count');
      expect(item.targetValue, 10);
      expect(item.isTrackable, isTrue);
    });

    test('a legacy challenge with no type/targetValue is not trackable', () {
      final item = ChallengeItem.fromJson({
        '_id': 'legacy',
        'name': 'Cycling Challenge',
        'details': 'Ride more',
      });
      expect(item.type, isNull);
      expect(item.targetValue, isNull);
      expect(item.isTrackable, isFalse);
    });

    test('falls back to the placeholder image and empty strings when missing', () {
      final item = ChallengeItem.fromJson(const {});
      expect(item.id, '');
      expect(item.image, 'assets/workout.png');
      expect(item.name, '');
      expect(item.details, '');
    });
  });

  group('challengeStatusFromApi', () {
    test('maps every known backend status', () {
      expect(challengeStatusFromApi('active'), ChallengeStatus.active);
      expect(challengeStatusFromApi('completed'), ChallengeStatus.completed);
      expect(challengeStatusFromApi('abandoned'), ChallengeStatus.abandoned);
      expect(challengeStatusFromApi('expired'), ChallengeStatus.expired);
    });

    test('defaults an unknown or missing status to active', () {
      expect(challengeStatusFromApi(null), ChallengeStatus.active);
      expect(challengeStatusFromApi('made_up'), ChallengeStatus.active);
    });
  });

  group('ChallengeProgressItem', () {
    Map<String, dynamic> progressJson({
      String status = 'active',
      int progressValue = 2,
      int targetValue = 5,
      String type = 'workouts_count',
      String startedAt = '2026-01-01T00:00:00.000Z',
      String? completedAt,
    }) => {
      '_id': 'p1',
      'challenge': {
        '_id': 'c1',
        'name': 'Push It',
        'details': 'Go',
        'type': type,
        'targetValue': targetValue,
      },
      'type': type,
      'status': status,
      'progressValue': progressValue,
      'targetValue': targetValue,
      'startedAt': startedAt,
      if (completedAt != null) 'completedAt': completedAt,
    };

    test('fromJson parses the nested challenge and every field', () {
      final progress = ChallengeProgressItem.fromJson(progressJson());
      expect(progress.id, 'p1');
      expect(progress.challenge.name, 'Push It');
      expect(progress.status, ChallengeStatus.active);
      expect(progress.progressValue, 2);
      expect(progress.targetValue, 5);
      expect(progress.isActive, isTrue);
      expect(progress.isCompleted, isFalse);
    });

    test('progressRatio divides value by target and clamps to [0, 1]', () {
      expect(
        ChallengeProgressItem.fromJson(
          progressJson(progressValue: 2, targetValue: 5),
        ).progressRatio,
        closeTo(0.4, 0.0001),
      );
      expect(
        ChallengeProgressItem.fromJson(
          progressJson(progressValue: 10, targetValue: 5),
        ).progressRatio,
        1.0,
      );
    });

    test('progressRatio is 0 for a zero or missing targetValue', () {
      expect(
        ChallengeProgressItem.fromJson(
          progressJson(progressValue: 3, targetValue: 0),
        ).progressRatio,
        0,
      );
    });

    test('isCompleted/isActive reflect status', () {
      expect(
        ChallengeProgressItem.fromJson(progressJson(status: 'completed')).isCompleted,
        isTrue,
      );
      expect(
        ChallengeProgressItem.fromJson(progressJson(status: 'abandoned')).isActive,
        isFalse,
      );
    });

    test('remainingTime is null for a type with no expiry window', () {
      final progress = ChallengeProgressItem.fromJson(
        progressJson(type: 'workouts_count'),
      );
      expect(progress.remainingTime(DateTime.now()), isNull);
    });

    test('remainingTime counts down a weekly_consistency window and floors at zero', () {
      final progress = ChallengeProgressItem.fromJson(
        progressJson(
          type: 'weekly_consistency',
          startedAt: '2026-01-01T00:00:00.000Z',
        ),
      );
      final remaining = progress.remainingTime(DateTime.utc(2026, 1, 3));
      expect(remaining, isNotNull);
      expect(remaining!.inDays, 5);

      final afterExpiry = progress.remainingTime(DateTime.utc(2026, 2, 1));
      expect(afterExpiry, Duration.zero);
    });
  });

  group('ChallengeSuggestion.fromJson', () {
    test('parses the nested challenge and the raw reasonCode, never rendered text', () {
      final suggestion = ChallengeSuggestion.fromJson({
        'challenge': {'_id': 'c1', 'name': 'Streak Starter', 'details': ''},
        'reasonCode': 'good_starting_challenge',
      });
      expect(suggestion.challenge.name, 'Streak Starter');
      expect(suggestion.reasonCode, 'good_starting_challenge');
    });
  });
}
