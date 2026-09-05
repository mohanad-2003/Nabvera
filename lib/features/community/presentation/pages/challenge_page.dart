import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:nabvera/core/analytics/analytics_service.dart';
import 'package:nabvera/core/localization/generated/app_localizations.dart';
import 'package:nabvera/core/routing/app_routes.dart';
import 'package:nabvera/core/theme/app_colors.dart';
import 'package:nabvera/core/widgets/premium_scaffold.dart';
import 'package:nabvera/core/widgets/smart_image.dart';
import 'package:nabvera/core/widgets/top_icon_actions.dart';
import 'package:nabvera/features/community/domain/community_models.dart';
import 'package:nabvera/features/community/presentation/providers/community_controller.dart';
import 'package:nabvera/features/community/presentation/widgets/challenge_progress_card.dart';

class ChallengePage extends ConsumerStatefulWidget {
  const ChallengePage({super.key, required this.challenge});

  final ChallengeItem challenge;
  @override
  ConsumerState<ChallengePage> createState() => _ChallengePageState();
}

class _ChallengePageState extends ConsumerState<ChallengePage> {
  bool _busy = false;
  @override
  void initState() {
    super.initState();
    // Once per screen visit — logEvent's own dedupe (keyed by challenge id)
    // additionally protects against rebuild-triggered re-firing this
    // session, matching the pattern used for recommendation_viewed.
    unawaited(
      ref.read(analyticsServiceProvider).logEvent(
        AnalyticsEvent.challengeViewed,
        {'challengeId': widget.challenge.id},
        widget.challenge.id,
      ),
    );
  }

  Future<void> _join() async {
    setState(() => _busy = true);
    try {
      await ref.read(myChallengesProvider.notifier).join(widget.challenge.id);
      unawaited(
        ref.read(analyticsServiceProvider).logEvent(
          AnalyticsEvent.challengeJoined,
          {'challengeId': widget.challenge.id},
        ),
      );
    } catch (_) {
      if (!mounted) return;
      final l10n = AppLocalizations.of(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.communityChallengeJoinFailed)),
      );
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _leave() async {
    setState(() => _busy = true);
    try {
      await ref.read(myChallengesProvider.notifier).leave(widget.challenge.id);
      unawaited(
        ref.read(analyticsServiceProvider).logEvent(
          AnalyticsEvent.challengeLeft,
          {'challengeId': widget.challenge.id},
        ),
      );
    } catch (_) {
      if (!mounted) return;
      final l10n = AppLocalizations.of(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.communityChallengeLeaveFailed)),
      );
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final challenge = widget.challenge;
    final myChallenges = ref.watch(myChallengesProvider);
    final suggestions = ref.watch(suggestedChallengesProvider);

    ChallengeProgressItem? progress;
    for (final entry in myChallenges) {
      if (entry.challenge.id == challenge.id) {
        progress = entry;
        break;
      }
    }
    String? reasonCode;
    for (final suggestion in suggestions) {
      if (suggestion.challenge.id == challenge.id) {
        reasonCode = suggestion.reasonCode;
        break;
      }
    }
    final reasonText =
        reasonCode == null ? null : challengeReasonText(l10n, reasonCode);
    final isJoinedActive = progress?.isActive == true;
    final isCompleted = progress?.isCompleted == true;

    return PremiumScaffold(
      padding: EdgeInsets.zero,
      safeArea: false,
      child: Stack(
        children: [
          Positioned.fill(child: SmartImage(challenge.image)),
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.black.withValues(alpha: 0.28),
                    AppColors.seedInk.withValues(alpha: 0.86),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 14, 20, 20),
              child: Column(
                children: [
                  Row(
                    children: [
                      PremiumIconButton(
                        icon: Icons.arrow_back_ios_new_rounded,
                        onTap: () => context.canPop() ? context.pop() : null,
                      ),
                      const Spacer(),
                      const TopIconActions(color: Colors.white),
                    ],
                  ),
                  const Spacer(),
                  PremiumGlassCard(
                    color: AppColors.seedInk.withValues(alpha: 0.54),
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          children: [
                            PremiumPill(
                              label: l10n.communityChallengeBadge,
                              icon: Icons.emoji_events_rounded,
                              selected: true,
                            ),
                            if (isCompleted) ...[
                              const SizedBox(width: 8),
                              Icon(
                                Icons.check_circle_rounded,
                                color: AppColors.seedLime,
                                size: 20,
                              ),
                            ],
                          ],
                        ),
                        const SizedBox(height: 14),
                        Text(
                          challenge.name,
                          style: Theme.of(
                            context,
                          ).textTheme.headlineSmall?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w900,
                            height: 1.04,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          challenge.details,
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(
                            context,
                          ).textTheme.bodyMedium?.copyWith(
                            color: Colors.white.withValues(alpha: 0.76),
                          ),
                        ),
                        if (challenge.isTrackable) ...[
                          const SizedBox(height: 16),
                          Text(
                            l10n.communityChallengeGoalHeading,
                            style: const TextStyle(
                              color: Colors.white70,
                              fontWeight: FontWeight.w800,
                              fontSize: 12,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            challengeGoalText(
                              l10n,
                              challenge.type,
                              challenge.targetValue,
                            ),
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                        if (progress != null) ...[
                          const SizedBox(height: 14),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(999),
                            child: LinearProgressIndicator(
                              value: progress.progressRatio,
                              minHeight: 8,
                              backgroundColor: Colors.white24,
                              valueColor: const AlwaysStoppedAnimation(
                                AppColors.seedLime,
                              ),
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            l10n.communityChallengeProgressLabel(
                              progress.progressValue,
                              progress.targetValue,
                            ),
                            style: const TextStyle(
                              color: Colors.white70,
                              fontWeight: FontWeight.w700,
                              fontSize: 12,
                            ),
                          ),
                        ] else if (reasonText != null) ...[
                          const SizedBox(height: 14),
                          Text(
                            l10n.communityChallengeReasonWhy,
                            style: const TextStyle(
                              color: Colors.white70,
                              fontWeight: FontWeight.w800,
                              fontSize: 12,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            reasonText,
                            style: const TextStyle(
                              color: Colors.white,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ],
                        const SizedBox(height: 18),
                        if (challenge.isTrackable)
                          SizedBox(
                            width: double.infinity,
                            child: DecoratedBox(
                              decoration: BoxDecoration(
                                gradient:
                                    isCompleted
                                        ? null
                                        : const LinearGradient(
                                          colors: [
                                            AppColors.seedLime,
                                            AppColors.electricOrange,
                                          ],
                                        ),
                                color: isCompleted ? Colors.white24 : null,
                                borderRadius: BorderRadius.circular(999),
                              ),
                              child: Material(
                                color: Colors.transparent,
                                child: InkWell(
                                  borderRadius: BorderRadius.circular(999),
                                  onTap:
                                      isCompleted || _busy
                                          ? null
                                          : (isJoinedActive ? _leave : _join),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 14,
                                    ),
                                    child: Center(
                                      child:
                                          _busy
                                              ? const SizedBox(
                                                width: 20,
                                                height: 20,
                                                child:
                                                    CircularProgressIndicator(
                                                      strokeWidth: 2,
                                                      color: AppColors.seedInk,
                                                    ),
                                              )
                                              : Text(
                                                isCompleted
                                                    ? l10n
                                                        .communityChallengeCompletedBadge
                                                    : isJoinedActive
                                                    ? l10n
                                                        .communityLeaveChallenge
                                                    : l10n
                                                        .communityJoinChallenge,
                                                style: TextStyle(
                                                  color:
                                                      isCompleted
                                                          ? Colors.white
                                                          : AppColors.seedInk,
                                                  fontWeight: FontWeight.w900,
                                                  fontSize: 16,
                                                ),
                                              ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          )
                        else
                          SizedBox(
                            width: double.infinity,
                            child: DecoratedBox(
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  colors: [
                                    AppColors.seedLime,
                                    AppColors.electricOrange,
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(999),
                              ),
                              child: Material(
                                color: Colors.transparent,
                                child: InkWell(
                                  borderRadius: BorderRadius.circular(999),
                                  onTap:
                                      () => context.push(
                                        AppRoutes.weeklyChallenge,
                                        extra: {
                                          'image': challenge.image,
                                          'name': challenge.name,
                                        },
                                      ),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 14,
                                    ),
                                    child: Center(
                                      child: Text(
                                        l10n.communityStartNow,
                                        style: const TextStyle(
                                          color: AppColors.seedInk,
                                          fontWeight: FontWeight.w900,
                                          fontSize: 16,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                  SizedBox(height: MediaQuery.of(context).padding.bottom + 16),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
