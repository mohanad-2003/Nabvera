import 'package:fitness_app/core/network/app_icons.dart';
import 'package:fitness_app/core/widgets/smart_image.dart';
import 'package:fitness_app/core/localization/generated/app_localizations.dart';
import 'package:fitness_app/core/theme/app_theme_extension.dart';
import 'package:fitness_app/core/widgets/premium_scaffold.dart';
import 'package:fitness_app/features/workout/domain/exercise_detail_models.dart';
import 'package:fitness_app/features/workout/domain/workout_models.dart';
import 'package:fitness_app/features/workout/presentation/providers/weekly_challenge_controller.dart';
import 'package:fitness_app/features/workout/presentation/widgets/round_item_tile.dart';
import 'package:fitness_app/features/workout/presentation/widgets/workout_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class WeeklyChallengePage extends ConsumerWidget {
  const WeeklyChallengePage({
    super.key,
    required this.image,
    required this.name,
  });

  final String image;
  final String name;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final roundOne = ref.watch(weeklyChallengeRoundOneProvider);
    final roundTwo = ref.watch(weeklyChallengeRoundTwoProvider);
    final theme = Theme.of(context);
    final ext = theme.extension<AppThemeExtension>()!;
    final l10n = AppLocalizations.of(context);

    return PremiumScaffold(
      padding: EdgeInsets.zero,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 10,
                horizontal: 20,
              ),
              child: WorkoutHeader(title: l10n.workoutWeeklyChallengeTitle),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.asset(
                      'assets/comm.png',
                      width: double.infinity,
                      height: 165,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    left: 0,
                    child: Container(
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(20),
                          bottomRight: Radius.circular(20),
                        ),
                        color: Colors.black38,
                      ),
                      padding: const EdgeInsets.symmetric(
                        vertical: 5,
                        horizontal: 10,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            name,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 14,
                              color: ext.accentGlow,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 5),
                          Row(
                            children: [
                              SmartImage(
AppIcons.time,
                                color: Colors.white,
                              ),
                              const SizedBox(width: 5),
                              const Text(
                                '25 Minute',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(width: 10),
                              SmartImage(
AppIcons.calories,
                                color: Colors.white,
                              ),
                              const SizedBox(width: 5),
                              const Text(
                                '750 Cal',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(width: 10),
                              SmartImage(
AppIcons.run,
                                color: Colors.white,
                              ),
                              const SizedBox(width: 5),
                              const Expanded(
                                child: Text(
                                  '5 Exercises',
                                  maxLines: 1,
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _RoundSection(
                    title: l10n.workoutRoundNumber(1),
                    rounds: roundOne,
                  ),
                  const SizedBox(height: 20),
                  _RoundSection(
                    title: l10n.workoutRoundNumber(2),
                    rounds: roundTwo,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _RoundSection extends StatelessWidget {
  const _RoundSection({required this.title, required this.rounds});

  final String title;
  final List<WeeklyRound> rounds;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final ext = theme.extension<AppThemeExtension>()!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 20,
            color: theme.colorScheme.primary,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 10),
        for (final round in rounds) ...[
          RoundItemTile(
            item: RoundExerciseItem(
              name: round.name,
              time: round.time,
              reps: round.intensity,
              accent: ext.accentGlow,
            ),
          ),
          const SizedBox(height: 10),
        ],
      ],
    );
  }
}
