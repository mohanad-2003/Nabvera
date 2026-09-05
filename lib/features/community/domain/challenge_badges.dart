import 'package:nabvera/features/community/domain/community_models.dart';

/// Simple, local retention badges earned by completing challenges — no
/// reward store, no currency, no leaderboard/social ranking (per the
/// brief). Purely a function of the user's own completed challenges, so
/// it's directly unit-testable with a plain list.
enum ChallengeBadge { firstChallenge, consistencyBuilder, weeklyWinner }

/// Deterministic, pure: given every one of the user's [ChallengeProgressItem]s
/// (any status), returns the set of badges earned so far.
///
/// - [ChallengeBadge.firstChallenge]: at least one challenge ever completed.
/// - [ChallengeBadge.consistencyBuilder]: at least one completed
///   `workout_streak` challenge — sticking with training day after day.
/// - [ChallengeBadge.weeklyWinner]: at least one completed
///   `weekly_consistency` challenge — hit a weekly target before it expired.
Set<ChallengeBadge> computeEarnedBadges(List<ChallengeProgressItem> challenges) {
  final completed = challenges.where((c) => c.isCompleted).toList();
  if (completed.isEmpty) return const {};

  final badges = <ChallengeBadge>{ChallengeBadge.firstChallenge};
  if (completed.any((c) => c.type == 'workout_streak')) {
    badges.add(ChallengeBadge.consistencyBuilder);
  }
  if (completed.any((c) => c.type == 'weekly_consistency')) {
    badges.add(ChallengeBadge.weeklyWinner);
  }
  return badges;
}
