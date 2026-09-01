import 'package:fitness_app/core/network/app_icons.dart';
import 'package:fitness_app/core/localization/generated/app_localizations.dart';
import 'package:fitness_app/core/routing/app_routes.dart';
import 'package:fitness_app/core/theme/app_theme_extension.dart';
import 'package:fitness_app/core/widgets/featured_card.dart';
import 'package:fitness_app/core/widgets/premium_scaffold.dart';
import 'package:fitness_app/features/workout/domain/exercise_detail_models.dart';
import 'package:fitness_app/features/workout/presentation/widgets/round_item_tile.dart';
import 'package:fitness_app/features/workout/presentation/widgets/workout_header.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Generic workout-category screen — replaces the legacy AdvanceCategory,
/// IntermediateCategory, and FunctionalPage, which shared this exact
/// layout (hero card + round groups) and only differed by data.
class CategoryDetailPage extends StatelessWidget {
  const CategoryDetailPage({super.key, required this.data});

  final CategoryDetailData data;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final ext = Theme.of(context).extension<AppThemeExtension>()!;
    final compact = MediaQuery.sizeOf(context).height < 720;

    return PremiumScaffold(
      padding: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
            child: WorkoutHeader(title: data.headerTitle),
          ),
          // The hero + round list share one scrollable region so the hero
          // always renders at its intended, proportioned height regardless
          // of device — the list below simply scrolls, which also makes
          // vertical overflow structurally impossible.
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: FeaturedCard(
                      image: data.heroImage,
                      badge: l10n.workoutTrainingOfTheDay.toUpperCase(),
                      title: data.heroLabel,
                      metas: [
                        FeaturedCardMeta(
                          icon: AppIcons.time,
                          label: data.time,
                        ),
                        FeaturedCardMeta(
                          icon: AppIcons.calories,
                          label: data.calories,
                        ),
                        FeaturedCardMeta(
                          icon: AppIcons.run,
                          label: data.levelLabel,
                        ),
                      ],
                      height: compact ? 200 : 240,
                    ),
                  ),
                  const SizedBox(height: 15),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        for (final group in data.rounds) ...[
                          Text(
                            group.title,
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.primary,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          for (final item in group.items) ...[
                            RoundItemTile(
                              item: item,
                              onTap:
                                  item.exerciseDetail == null
                                      ? null
                                      : () => context.push(
                                        AppRoutes.exerciseDetail,
                                        extra: item.exerciseDetail,
                                      ),
                            ),
                            if (item != group.items.last)
                              Divider(height: 1, color: ext.glassBorder),
                          ],
                          const SizedBox(height: 18),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
