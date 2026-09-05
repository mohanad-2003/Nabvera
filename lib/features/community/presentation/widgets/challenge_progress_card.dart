import 'package:nabvera/core/localization/generated/app_localizations.dart';
import 'package:nabvera/core/theme/app_colors.dart';
import 'package:nabvera/core/theme/app_theme_extension.dart';
import 'package:nabvera/core/widgets/premium_scaffold.dart';
import 'package:nabvera/core/widgets/smart_image.dart';
import 'package:nabvera/features/community/domain/community_models.dart';
import 'package:flutter/material.dart';

/// Localized "what this challenge asks for" line, from its `type` +
/// `targetValue` — the backend only ever sends the raw type/number pair
/// (see `Challenge.type`/`Challenge.targetValue`), never rendered text.
String challengeGoalText(AppLocalizations l10n, String? type, int? targetValue) {
  final target = targetValue ?? 0;
  switch (type) {
    case 'workouts_count':
      return l10n.communityChallengeGoalWorkoutsCount(target);
    case 'active_minutes':
      return l10n.communityChallengeGoalActiveMinutes(target);
    case 'workout_streak':
      return l10n.communityChallengeGoalWorkoutStreak(target);
    case 'weekly_consistency':
      return l10n.communityChallengeGoalWeeklyConsistency(target);
    default:
      return '';
  }
}

/// Localized suggestion rationale for a backend `reasonCode` — an
/// allowlist-style switch so an unrecognized/future code degrades to
/// nothing shown rather than a raw code leaking into the UI.
String? challengeReasonText(AppLocalizations l10n, String reasonCode) {
  switch (reasonCode) {
    case 'good_starting_challenge':
      return l10n.communityChallengeReasonGoodStartingChallenge;
    case 'builds_on_current_streak':
      return l10n.communityChallengeReasonBuildsOnCurrentStreak;
    case 'consistent_recent_activity':
      return l10n.communityChallengeReasonConsistentRecentActivity;
    case 'matches_activity_level':
      return l10n.communityChallengeReasonMatchesActivityLevel;
    default:
      return null;
  }
}

/// Renders a [Duration] as "N days left" / "Nh left" — the two grains the
/// only expiring type ([ChallengeProgressItem.remainingTime]) ever needs.
String challengeTimeLeftText(AppLocalizations l10n, Duration remaining) {
  if (remaining.inDays >= 1) {
    return l10n.communityChallengeTimeLeftDays(remaining.inDays);
  }
  return l10n.communityChallengeTimeLeftHours(remaining.inHours);
}

/// A challenge suggested to the user (from `/challenges/suggested`) — image,
/// name, goal, the reason it was suggested, and a Join action.
class SuggestedChallengeCard extends StatelessWidget {
  const SuggestedChallengeCard({
    super.key,
    required this.suggestion,
    required this.onJoin,
    required this.isJoining,
    this.onTap,
  });

  final ChallengeSuggestion suggestion;
  final VoidCallback onJoin;
  final bool isJoining;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final ext = Theme.of(context).extension<AppThemeExtension>()!;
    final challenge = suggestion.challenge;
    final reason = challengeReasonText(l10n, suggestion.reasonCode);

    return PremiumGlassCard(
      onTap: onTap,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: SmartImage(challenge.image, width: 64, height: 64),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  challenge.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    color: ext.textPrimary,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  challengeGoalText(l10n, challenge.type, challenge.targetValue),
                  style: TextStyle(fontSize: 13, color: ext.textMuted),
                ),
                if (reason != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    reason,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 12,
                      fontStyle: FontStyle.italic,
                      color: ext.accentGlow,
                    ),
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(width: 8),
          SizedBox(
            height: 34,
            child: OutlinedButton(
              onPressed: isJoining ? null : onJoin,
              style: OutlinedButton.styleFrom(
                foregroundColor: ext.accentGlow,
                side: BorderSide(color: ext.accentGlow),
                padding: const EdgeInsets.symmetric(horizontal: 14),
              ),
              child:
                  isJoining
                      ? const SizedBox(
                        width: 14,
                        height: 14,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                      : Text(l10n.communityJoinChallenge),
            ),
          ),
        ],
      ),
    );
  }
}

/// One of the user's own challenges (from `/challenges/my`) — progress bar,
/// `value / target`, remaining time (when it can expire), and a Leave
/// action, or a "Completed" badge once it's done.
class MyChallengeCard extends StatelessWidget {
  const MyChallengeCard({
    super.key,
    required this.progress,
    this.onLeave,
    this.isLeaving = false,
    this.onTap,
  });

  final ChallengeProgressItem progress;
  final VoidCallback? onLeave;
  final bool isLeaving;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final ext = Theme.of(context).extension<AppThemeExtension>()!;
    final challenge = progress.challenge;
    final remaining = progress.remainingTime(DateTime.now());

    return PremiumGlassCard(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: SmartImage(challenge.image, width: 56, height: 56),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      challenge.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        color: ext.textPrimary,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      challengeGoalText(l10n, progress.type, progress.targetValue),
                      style: TextStyle(fontSize: 13, color: ext.textMuted),
                    ),
                  ],
                ),
              ),
              if (progress.isCompleted)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [AppColors.seedLime, AppColors.electricOrange],
                    ),
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.check_circle_rounded,
                        size: 14,
                        color: AppColors.seedInk,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        l10n.communityChallengeCompletedBadge,
                        style: const TextStyle(
                          color: AppColors.seedInk,
                          fontWeight: FontWeight.w900,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                )
              else if (onLeave != null)
                TextButton(
                  onPressed: isLeaving ? null : onLeave,
                  child:
                      isLeaving
                          ? const SizedBox(
                            width: 14,
                            height: 14,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                          : Text(
                            l10n.communityLeaveChallenge,
                            style: TextStyle(color: ext.textMuted),
                          ),
                ),
            ],
          ),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(999),
            child: LinearProgressIndicator(
              value: progress.progressRatio,
              minHeight: 8,
              backgroundColor: ext.glassBorder,
              valueColor: AlwaysStoppedAnimation(ext.accentGlow),
            ),
          ),
          const SizedBox(height: 6),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                l10n.communityChallengeProgressLabel(
                  progress.progressValue,
                  progress.targetValue,
                ),
                style: TextStyle(
                  fontSize: 12,
                  color: ext.textMuted,
                  fontWeight: FontWeight.w700,
                ),
              ),
              if (remaining != null)
                Text(
                  challengeTimeLeftText(l10n, remaining),
                  style: TextStyle(fontSize: 12, color: ext.textMuted),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
