import 'dart:async';

import 'package:nabvera/core/analytics/analytics_service.dart';
import 'package:nabvera/core/network/app_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/localization/generated/app_localizations.dart';
import '../../../../core/routing/app_routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_theme_extension.dart';
import '../../../../core/widgets/featured_card.dart';
import '../../../../core/widgets/premium_scaffold.dart';
import '../../domain/challenge_badges.dart';
import '../../domain/community_models.dart';
import '../providers/community_controller.dart';
import '../widgets/challenge_progress_card.dart';
import 'forum_detail_page.dart';

class CommunityPage extends ConsumerWidget {
  const CommunityPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tab = ref.watch(communityTabControllerProvider);
    final challenges = ref.watch(communityChallengesProvider);
    final forums = ref.watch(communityForumsProvider);
    final l10n = AppLocalizations.of(context);
    final compact = MediaQuery.sizeOf(context).height < 720;

    return PremiumScaffold(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          PremiumHeader(
            title: l10n.navCommunityTitle,
            subtitle: l10n.communitySubtitle,
          ),
          SizedBox(height: compact ? 10 : 14),
          Row(
            children: [
              Expanded(
                child: PremiumPill(
                  label: l10n.communityTabForum,
                  icon: Icons.forum_rounded,
                  selected: tab == CommunityTab.forum,
                  onTap:
                      () => ref
                          .read(communityTabControllerProvider.notifier)
                          .select(CommunityTab.forum),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: PremiumPill(
                  label: l10n.communityTabChallenges,
                  icon: Icons.emoji_events_rounded,
                  selected: tab == CommunityTab.challenges,
                  onTap:
                      () => ref
                          .read(communityTabControllerProvider.notifier)
                          .select(CommunityTab.challenges),
                ),
              ),
            ],
          ),
          SizedBox(height: compact ? 12 : 16),
          Expanded(
            // Smooth cross-fade when switching between the two tabs.
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 240),
              child: KeyedSubtree(
                key: ValueKey(tab),
                child:
                    tab == CommunityTab.forum
                        ? _ForumTab(
                          forums: forums,
                          featuredChallenge:
                              challenges.isEmpty ? null : challenges.first,
                          compact: compact,
                          onToggleLike:
                              (id) => ref
                                  .read(communityForumsProvider.notifier)
                                  .toggleLike(id),
                        )
                        : const _ChallengesTab(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ForumTab extends StatelessWidget {
  const _ForumTab({
    required this.forums,
    required this.featuredChallenge,
    required this.compact,
    required this.onToggleLike,
  });

  final List<ForumThread> forums;
  final ChallengeItem? featuredChallenge;
  final bool compact;
  final ValueChanged<String> onToggleLike;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final challenge = featuredChallenge;

    // One CustomScrollView: the hero challenge card + section header live
    // in a SliverToBoxAdapter, and "Forums" is a SliverList right below it
    // — a single real scroll view, so overflow is structurally impossible.
    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              FeaturedCard(
                image: challenge?.image ?? 'assets/workout.png',
                badge: l10n.communityChallengeBadge,
                // Community's secondary accent per the design system.
                badgeColor: AppColors.aquaBlue,
                title: challenge?.name ?? l10n.communityFeaturedChallengeName,
                metas: [
                  FeaturedCardMeta(
                    icon: AppIcons.time,
                    label:
                        challenge?.durationLabel ??
                        l10n.communityFeaturedChallengeDuration,
                  ),
                  FeaturedCardMeta(
                    icon: AppIcons.calories,
                    label:
                        challenge?.caloriesLabel ??
                        l10n.communityFeaturedChallengeCalories,
                  ),
                ],
                height: compact ? 170 : 220,
              ),
              const SizedBox(height: 20),
              PremiumSectionHeader(title: l10n.communityForums),
              const SizedBox(height: 12),
            ],
          ),
        ),
        SliverList.separated(
          itemCount: forums.length,
          separatorBuilder:
              (context, _) => Divider(
                height: 1,
                color:
                    Theme.of(
                      context,
                    ).extension<AppThemeExtension>()!.glassBorder,
              ),
          itemBuilder:
              (context, index) => _ForumThreadCard(
                thread: forums[index],
                onToggleLike: () => onToggleLike(forums[index].id),
              ),
        ),
        const SliverToBoxAdapter(child: SizedBox(height: 8)),
      ],
    );
  }
}

class _ForumThreadCard extends StatelessWidget {
  const _ForumThreadCard({required this.thread, required this.onToggleLike});

  final ForumThread thread;
  final VoidCallback onToggleLike;

  @override
  Widget build(BuildContext context) {
    final ext = Theme.of(context).extension<AppThemeExtension>()!;

    // No card container — the list separates threads with a divider
    // instead (see _ForumTab's SliverList).
    return InkWell(
      onTap:
          () => Navigator.of(context).push(
            MaterialPageRoute<void>(
              builder: (_) => ForumDetailPage(thread: thread),
            ),
          ),
      borderRadius: BorderRadius.circular(AppRadius.card),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Row(
          children: [
            Container(
              width: 46,
              height: 46,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: ext.accentGradient,
              ),
              child: Icon(Icons.forum_rounded, color: ext.onAccent),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    thread.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      color: ext.textPrimary,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    thread.subtitle.trim(),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(
                      context,
                    ).textTheme.bodySmall?.copyWith(color: ext.textMuted),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      GestureDetector(
                        onTap: onToggleLike,
                        child: Icon(
                          thread.liked
                              ? Icons.favorite_rounded
                              : Icons.favorite_border_rounded,
                          size: 16,
                          color:
                              thread.liked
                                  ? Theme.of(context).colorScheme.primary
                                  : ext.textMuted,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${thread.likesCount}',
                        style: TextStyle(fontSize: 12, color: ext.textMuted),
                      ),
                      const SizedBox(width: 12),
                      Icon(
                        Icons.mode_comment_outlined,
                        size: 15,
                        color: ext.textMuted,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${thread.commentsCount}',
                        style: TextStyle(fontSize: 12, color: ext.textMuted),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  thread.allLabel,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  thread.date,
                  style: Theme.of(
                    context,
                  ).textTheme.labelSmall?.copyWith(color: ext.textMuted),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// The "Challenges" tab body: suggested-for-you, the user's own active
/// challenges, and completed ones — each section reading its own provider
/// (see `community_controller.dart`) rather than one flat admin-content
/// list, since these are now real per-user state, not just browsable cards.
class _ChallengesTab extends ConsumerWidget {
  const _ChallengesTab();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final suggestions = ref.watch(suggestedChallengesProvider);
    final myChallenges = ref.watch(myChallengesProvider);

    final active =
        myChallenges.where((c) => c.status == ChallengeStatus.active).toList();
    final completed = myChallenges.where((c) => c.isCompleted).toList();
    final badges = computeEarnedBadges(myChallenges);

    Future<void> handleJoin(ChallengeItem challenge) async {
      try {
        await ref.read(myChallengesProvider.notifier).join(challenge.id);
        unawaited(
          ref
              .read(analyticsServiceProvider)
              .logEvent(AnalyticsEvent.challengeJoined, {
                'challengeId': challenge.id,
              }),
        );
      } catch (_) {
        if (!context.mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.communityChallengeJoinFailed)),
        );
      }
    }

    Future<void> handleLeave(ChallengeItem challenge) async {
      try {
        await ref.read(myChallengesProvider.notifier).leave(challenge.id);
        unawaited(
          ref
              .read(analyticsServiceProvider)
              .logEvent(AnalyticsEvent.challengeLeft, {
                'challengeId': challenge.id,
              }),
        );
      } catch (_) {
        if (!context.mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.communityChallengeLeaveFailed)),
        );
      }
    }

    return CustomScrollView(
      slivers: [
        if (badges.isNotEmpty)
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: _BadgesRow(badges: badges),
            ),
          ),
        SliverToBoxAdapter(
          child: PremiumSectionHeader(title: l10n.communitySuggestedForYou),
        ),
        const SliverToBoxAdapter(child: SizedBox(height: 10)),
        if (suggestions.isEmpty)
          SliverToBoxAdapter(
            child: _EmptySectionText(text: l10n.communityNoSuggestions),
          )
        else
          SliverList.separated(
            itemCount: suggestions.length,
            separatorBuilder: (context, _) => const SizedBox(height: 10),
            itemBuilder: (context, index) {
              final suggestion = suggestions[index];
              return SuggestedChallengeCard(
                suggestion: suggestion,
                isJoining: false,
                onJoin: () => handleJoin(suggestion.challenge),
                onTap:
                    () => context.push(
                      AppRoutes.communityChallenge,
                      extra: suggestion.challenge,
                    ),
              );
            },
          ),
        const SliverToBoxAdapter(child: SizedBox(height: 22)),
        SliverToBoxAdapter(
          child: PremiumSectionHeader(title: l10n.communityMyActiveChallenges),
        ),
        const SliverToBoxAdapter(child: SizedBox(height: 10)),
        if (active.isEmpty)
          SliverToBoxAdapter(
            child: _EmptySectionText(text: l10n.communityNoActiveChallenges),
          )
        else
          SliverList.separated(
            itemCount: active.length,
            separatorBuilder: (context, _) => const SizedBox(height: 10),
            itemBuilder: (context, index) {
              final progress = active[index];
              return MyChallengeCard(
                progress: progress,
                onLeave: () => handleLeave(progress.challenge),
                onTap:
                    () => context.push(
                      AppRoutes.communityChallenge,
                      extra: progress.challenge,
                    ),
              );
            },
          ),
        const SliverToBoxAdapter(child: SizedBox(height: 22)),
        SliverToBoxAdapter(
          child: PremiumSectionHeader(title: l10n.communityCompletedChallenges),
        ),
        const SliverToBoxAdapter(child: SizedBox(height: 10)),
        if (completed.isEmpty)
          SliverToBoxAdapter(
            child: _EmptySectionText(text: l10n.communityNoCompletedChallenges),
          )
        else
          SliverList.separated(
            itemCount: completed.length,
            separatorBuilder: (context, _) => const SizedBox(height: 10),
            itemBuilder:
                (context, index) => MyChallengeCard(
                  progress: completed[index],
                  onTap:
                      () => context.push(
                        AppRoutes.communityChallenge,
                        extra: completed[index].challenge,
                      ),
                ),
          ),
        const SliverToBoxAdapter(child: SizedBox(height: 8)),
      ],
    );
  }
}

class _EmptySectionText extends StatelessWidget {
  const _EmptySectionText({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    final ext = Theme.of(context).extension<AppThemeExtension>()!;
    return Text(text, style: TextStyle(color: ext.textMuted));
  }
}

class _BadgesRow extends StatelessWidget {
  const _BadgesRow({required this.badges});

  final Set<ChallengeBadge> badges;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final ext = Theme.of(context).extension<AppThemeExtension>()!;

    String labelFor(ChallengeBadge badge) => switch (badge) {
      ChallengeBadge.firstChallenge => l10n.communityBadgeFirstChallenge,
      ChallengeBadge.consistencyBuilder =>
        l10n.communityBadgeConsistencyBuilder,
      ChallengeBadge.weeklyWinner => l10n.communityBadgeWeeklyWinner,
    };

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.communityYourBadges,
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
            color: ext.textPrimary,
            fontWeight: FontWeight.w900,
          ),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            for (final badge in badges)
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  gradient: ext.accentGradient,
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.emoji_events_rounded,
                      size: 14,
                      color: ext.onAccent,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      labelFor(badge),
                      style: TextStyle(
                        color: ext.onAccent,
                        fontWeight: FontWeight.w800,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ],
    );
  }
}
