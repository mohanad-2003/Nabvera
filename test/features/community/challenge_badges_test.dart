import 'package:nabvera/features/community/domain/challenge_badges.dart';
import 'package:nabvera/features/community/domain/community_models.dart';
import 'package:flutter_test/flutter_test.dart';

ChallengeProgressItem _progress({
  required String status,
  required String type,
}) {
  return ChallengeProgressItem.fromJson({
    '_id': 'p',
    'challenge': {'_id': 'c', 'name': 'X', 'details': ''},
    'type': type,
    'status': status,
    'progressValue': 1,
    'targetValue': 1,
    'startedAt': '2026-01-01T00:00:00.000Z',
  });
}

void main() {
  group('computeEarnedBadges', () {
    test('returns nothing when no challenge has been completed', () {
      final badges = computeEarnedBadges([
        _progress(status: 'active', type: 'workouts_count'),
        _progress(status: 'abandoned', type: 'workout_streak'),
      ]);
      expect(badges, isEmpty);
    });

    test('returns an empty set for an empty list', () {
      expect(computeEarnedBadges(const []), isEmpty);
    });

    test('awards firstChallenge for any single completed challenge', () {
      final badges = computeEarnedBadges([
        _progress(status: 'completed', type: 'active_minutes'),
      ]);
      expect(badges, {ChallengeBadge.firstChallenge});
    });

    test('awards consistencyBuilder only for a completed workout_streak challenge', () {
      final badges = computeEarnedBadges([
        _progress(status: 'completed', type: 'workout_streak'),
      ]);
      expect(badges, {ChallengeBadge.firstChallenge, ChallengeBadge.consistencyBuilder});
    });

    test('awards weeklyWinner only for a completed weekly_consistency challenge', () {
      final badges = computeEarnedBadges([
        _progress(status: 'completed', type: 'weekly_consistency'),
      ]);
      expect(badges, {ChallengeBadge.firstChallenge, ChallengeBadge.weeklyWinner});
    });

    test('an active (not yet completed) matching type earns nothing', () {
      final badges = computeEarnedBadges([
        _progress(status: 'active', type: 'workout_streak'),
      ]);
      expect(badges, isEmpty);
    });

    test('awards all three when the user has completed one of each relevant type', () {
      final badges = computeEarnedBadges([
        _progress(status: 'completed', type: 'workouts_count'),
        _progress(status: 'completed', type: 'workout_streak'),
        _progress(status: 'completed', type: 'weekly_consistency'),
      ]);
      expect(badges, {
        ChallengeBadge.firstChallenge,
        ChallengeBadge.consistencyBuilder,
        ChallengeBadge.weeklyWinner,
      });
    });
  });
}
