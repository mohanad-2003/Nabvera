import 'package:fitness_app/core/network/app_icons.dart';
import 'package:fitness_app/core/widgets/smart_image.dart';
import 'package:fitness_app/core/localization/generated/app_localizations.dart';
import 'package:fitness_app/core/routing/app_routes.dart';
import 'package:fitness_app/core/theme/app_theme_extension.dart';
import 'package:fitness_app/core/widgets/premium_scaffold.dart';
import 'package:fitness_app/core/widgets/user_avatar.dart';
import 'package:fitness_app/features/profile/domain/profile_models.dart';
import 'package:fitness_app/features/profile/presentation/providers/profile_controller.dart';
import 'package:fitness_app/features/workout/presentation/providers/workout_progress_controller.dart';
import 'package:fitness_app/features/workout/presentation/widgets/progress_tab_bar.dart';
import 'package:fitness_app/features/workout/presentation/widgets/workout_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class WorkoutLogsPage extends ConsumerWidget {
  const WorkoutLogsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final activities = ref.watch(activityLogProvider);
    final theme = Theme.of(context);
    final ext = theme.extension<AppThemeExtension>()!;
    final l10n = AppLocalizations.of(context);
    final accent = theme.colorScheme.primary;

    return PremiumScaffold(
      padding: EdgeInsets.zero,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
              child: WorkoutHeader(title: l10n.progressTitle),
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: _ProfileSummary(
                profile: ref.watch(currentUserProfileProvider),
              ),
            ),
            const SizedBox(height: 20),
            ProgressTabBar(
              selected: ProgressTab.logs,
              onChartsTap: () => context.push(AppRoutes.workoutCharts),
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 10),
                  Text(
                    l10n.progressActivities,
                    style: TextStyle(
                      fontSize: 20,
                      color: ext.textPrimary,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 6),
                  if (activities.isEmpty)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 30),
                      child: Center(
                        child: Column(
                          children: [
                            Icon(
                              Icons.fitness_center_outlined,
                              color: ext.textMuted,
                              size: 36,
                            ),
                            const SizedBox(height: 10),
                            Text(
                              l10n.progressEmptyState,
                              style: TextStyle(color: ext.textMuted),
                            ),
                          ],
                        ),
                      ),
                    )
                  else
                    ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: activities.length,
                      separatorBuilder:
                          (_, _) => Divider(height: 1, color: ext.glassBorder),
                      itemBuilder: (context, index) {
                        final item = activities[index];
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          child: Row(
                            children: [
                              Container(
                                width: 45,
                                height: 45,
                                decoration: BoxDecoration(
                                  gradient: ext.accentGradient,
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  Icons.fitness_center_rounded,
                                  color: ext.onAccent,
                                  size: 22,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      item.name,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        fontSize: 13,
                                        color: ext.textPrimary,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                    const SizedBox(height: 5),
                                    Row(
                                      children: [
                                        SmartImage(
                                          AppIcons.calories,
                                          color: accent,
                                          width: 13,
                                          height: 13,
                                        ),
                                        const SizedBox(width: 5),
                                        Text(
                                          item.calories,
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: ext.textMuted,
                                          ),
                                        ),
                                        const SizedBox(width: 10),
                                        Icon(
                                          Icons.schedule_rounded,
                                          size: 13,
                                          color: accent,
                                        ),
                                        const SizedBox(width: 5),
                                        Text(
                                          item.date,
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: ext.textMuted,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              Text(
                                item.duration,
                                style: TextStyle(
                                  fontSize: 14,
                                  color: ext.textPrimary,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                ],
              ),
            ),
            const SizedBox(height: 104),
          ],
        ),
      ),
    );
  }
}

class _ProfileSummary extends StatelessWidget {
  const _ProfileSummary({required this.profile});

  final UserProfile profile;

  @override
  Widget build(BuildContext context) {
    final ext = Theme.of(context).extension<AppThemeExtension>()!;
    final l10n = AppLocalizations.of(context);
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: ext.glassFill,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: ext.glassBorder),
      ),
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 24),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      profile.name.isEmpty ? '—' : profile.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 22,
                        color: ext.textPrimary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 5),
                Row(
                  children: [
                    Text(
                      '${l10n.workoutProfileAge} :',
                      style: TextStyle(
                        fontSize: 14,
                        color: ext.textMuted,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 5),
                    Text(
                      profile.ageYears,
                      style: TextStyle(fontSize: 14, color: ext.textMuted),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    _InfoItem(
                      value: profile.weightKg,
                      label: l10n.workoutProfileWeight,
                    ),
                    const SizedBox(width: 30),
                    _InfoItem(
                      value: profile.heightM,
                      label: l10n.workoutProfileHeight,
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            flex: 1,
            child: UserAvatar(radius: 42, imageUrl: profile.avatarUrl),
          ),
        ],
      ),
    );
  }
}

class _InfoItem extends StatelessWidget {
  const _InfoItem({required this.value, required this.label});
  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    final ext = Theme.of(context).extension<AppThemeExtension>()!;
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            width: 7,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          const SizedBox(width: 5),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                value,
                style: TextStyle(
                  fontSize: 14,
                  color: ext.textPrimary,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(label, style: TextStyle(fontSize: 14, color: ext.textMuted)),
            ],
          ),
        ],
      ),
    );
  }
}

