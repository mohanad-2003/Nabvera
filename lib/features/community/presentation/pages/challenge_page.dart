import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/localization/generated/app_localizations.dart';
import '../../../../core/routing/app_routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/premium_scaffold.dart';
import '../../../../core/widgets/smart_image.dart';
import '../../../../core/widgets/top_icon_actions.dart';
import '../../domain/community_models.dart';

class ChallengePage extends StatelessWidget {
  const ChallengePage({super.key, required this.challenge});

  final ChallengeItem challenge;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return PremiumScaffold(
      padding: EdgeInsets.zero,
      safeArea: false,
      child: Stack(
        children: [
          Positioned.fill(
            child: SmartImage(challenge.image),
          ),
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
                        PremiumPill(
                          label: l10n.communityChallengeBadge,
                          icon: Icons.emoji_events_rounded,
                          selected: true,
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
                        const SizedBox(height: 18),
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
