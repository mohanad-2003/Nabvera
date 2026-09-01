import 'package:fitness_app/core/localization/generated/app_localizations.dart';
import 'package:fitness_app/core/theme/app_theme_extension.dart';
import 'package:fitness_app/core/widgets/premium_scaffold.dart';
import 'package:fitness_app/features/workout/domain/workout_models.dart';
import 'package:fitness_app/features/workout/presentation/providers/workout_progress_controller.dart';
import 'package:fitness_app/features/workout/presentation/widgets/progress_tab_bar.dart';
import 'package:fitness_app/features/workout/presentation/widgets/workout_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// Weekly training charts — real data from `/api/workout-logs`: a calories
/// bar chart, a sessions/minutes/calories summary row, and the most recent
/// sessions. Replaces the previous entirely-hardcoded mock (fake step
/// counts, a static "January 12th" date, three fixed daily-detail cards).
class CategoryChartsPage extends ConsumerWidget {
  const CategoryChartsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final ext = theme.extension<AppThemeExtension>()!;
    final l10n = AppLocalizations.of(context);
    final days = ref.watch(weeklyChartProvider);
    final recentLogs = ref.watch(activityLogProvider).take(3).toList();

    final totalSessions = days.fold(0, (sum, d) => sum + d.sessions);
    final totalMinutes = days.fold(0, (sum, d) => sum + d.minutes);
    final totalCalories = days.fold(0, (sum, d) => sum + d.calories);
    final avgSession = totalSessions == 0 ? 0 : totalMinutes ~/ totalSessions;

    return PremiumScaffold(
      padding: EdgeInsets.zero,
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              WorkoutHeader(title: l10n.progressTitle, showBack: false),
              const SizedBox(height: 20),
              ProgressTabBar(
                selected: ProgressTab.charts,
                onLogsTap: () => context.pop(),
              ),
              const SizedBox(height: 24),
              Text(
                l10n.progressWeeklyOverview,
                style: theme.textTheme.titleLarge?.copyWith(
                  color: ext.textPrimary,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: _StatTile(
                      icon: Icons.fitness_center_rounded,
                      value: '$totalSessions',
                      label: l10n.progressStatSessions,
                    ),
                  ),
                  _StatDivider(),
                  Expanded(
                    child: _StatTile(
                      icon: Icons.timer_rounded,
                      value: '$totalMinutes',
                      label: l10n.progressStatMinutes,
                    ),
                  ),
                  _StatDivider(),
                  Expanded(
                    child: _StatTile(
                      icon: Icons.local_fire_department_rounded,
                      value: '$totalCalories',
                      label: l10n.profileStatCalories,
                    ),
                  ),
                  _StatDivider(),
                  Expanded(
                    child: _StatTile(
                      icon: Icons.speed_rounded,
                      value: '$avgSession',
                      label: l10n.progressStatAvgSession,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 28),
              _WeeklyCaloriesChart(days: days),
              const SizedBox(height: 28),
              Text(
                l10n.progressRecentSessions,
                style: theme.textTheme.titleLarge?.copyWith(
                  color: ext.textPrimary,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 12),
              if (recentLogs.isEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: Center(
                    child: Text(
                      l10n.progressNoSessionsYet,
                      style: TextStyle(color: ext.textMuted),
                    ),
                  ),
                )
              else
                for (var i = 0; i < recentLogs.length; i++) ...[
                  _RecentSessionRow(item: recentLogs[i]),
                  if (i != recentLogs.length - 1)
                    Divider(height: 1, color: ext.glassBorder),
                ],
            ],
          ),
        ),
      ),
    );
  }
}

class _StatDivider extends StatelessWidget {
  const _StatDivider();

  @override
  Widget build(BuildContext context) {
    final ext = Theme.of(context).extension<AppThemeExtension>()!;
    return Container(width: 1, height: 44, color: ext.glassBorder);
  }
}

class _StatTile extends StatelessWidget {
  const _StatTile({
    required this.icon,
    required this.value,
    required this.label,
  });

  final IconData icon;
  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    final ext = Theme.of(context).extension<AppThemeExtension>()!;
    return Column(
      children: [
        Icon(icon, color: Theme.of(context).colorScheme.primary, size: 20),
        const SizedBox(height: 6),
        Text(
          value,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            color: ext.textPrimary,
            fontWeight: FontWeight.w900,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.center,
          style: Theme.of(
            context,
          ).textTheme.labelSmall?.copyWith(color: ext.textMuted),
        ),
      ],
    );
  }
}

/// Calorie-burn bar chart for the last 7 days — same visual language as the
/// Home weekly-progress chart (theme-aware bars, today highlighted), so the
/// two "progress" surfaces in the app feel consistent.
class _WeeklyCaloriesChart extends StatelessWidget {
  const _WeeklyCaloriesChart({required this.days});

  final List<DayActivity> days;

  @override
  Widget build(BuildContext context) {
    final ext = Theme.of(context).extension<AppThemeExtension>()!;
    final l10n = AppLocalizations.of(context);
    final dayLabels = [
      l10n.homeDayMon,
      l10n.homeDayTue,
      l10n.homeDayWed,
      l10n.homeDayThu,
      l10n.homeDayFri,
      l10n.homeDaySat,
      l10n.homeDaySun,
    ];
    final todayIndex = DateTime.now().weekday - 1;
    final maxCalories = days.fold(0, (m, d) => d.calories > m ? d.calories : m);
    final heights = [
      for (final d in days)
        maxCalories == 0 ? 0.04 : (d.calories / maxCalories).clamp(0.04, 1.0),
    ];

    return SizedBox(
      height: 150,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          for (var i = 0; i < heights.length; i++)
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    if (days[i].calories > 0)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 4),
                        child: Text(
                          '${days[i].calories}',
                          style: TextStyle(
                            fontSize: 9,
                            fontWeight: FontWeight.w700,
                            color: ext.textMuted,
                          ),
                        ),
                      ),
                    Expanded(
                      child: Align(
                        alignment: Alignment.bottomCenter,
                        child: FractionallySizedBox(
                          heightFactor: heights[i],
                          widthFactor: 0.58,
                          child: DecoratedBox(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(999),
                              gradient:
                                  i == todayIndex
                                      ? ext.accentGradient
                                      : LinearGradient(
                                        colors: [ext.glassBorder, ext.glassFill],
                                        begin: Alignment.topCenter,
                                        end: Alignment.bottomCenter,
                                      ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      dayLabels[i],
                      style: TextStyle(
                        color: i == todayIndex ? ext.accentGlow : ext.textMuted,
                        fontWeight: FontWeight.w800,
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

class _RecentSessionRow extends StatelessWidget {
  const _RecentSessionRow({required this.item});

  final ActivityLogItem item;

  @override
  Widget build(BuildContext context) {
    final ext = Theme.of(context).extension<AppThemeExtension>()!;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: ext.accentGradient,
            ),
            child: Icon(Icons.fitness_center_rounded, color: ext.onAccent, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    color: ext.textPrimary,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  item.date,
                  style: TextStyle(fontSize: 12, color: ext.textMuted),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                item.duration,
                style: TextStyle(
                  color: ext.textPrimary,
                  fontWeight: FontWeight.w700,
                  fontSize: 13,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                item.calories,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.w700,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
