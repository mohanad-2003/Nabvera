import 'package:nabvera/core/localization/generated/app_localizations.dart';
import 'package:nabvera/core/theme/app_colors.dart';
import 'package:nabvera/core/theme/app_theme_extension.dart';
import 'package:nabvera/features/home/presentation/providers/home_dashboard_controller.dart';
import 'package:nabvera/features/home/presentation/widgets/workout_schedule_sheet.dart';
import 'package:nabvera/features/profile/domain/profile_models.dart';
import 'package:nabvera/features/profile/domain/workout_schedule.dart';
import 'package:nabvera/features/profile/presentation/providers/profile_controller.dart';
import 'package:nabvera/features/profile/presentation/widgets/workout_schedule_form.dart'
    show weekdayShortLabel;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Home's "Your Schedule" card — the selected workout days for the week
/// (today highlighted), today's status (workout day / rest day /
/// completed), and quick access to the edit sheet. Reads
/// `currentUserProfileProvider` for the schedule itself and
/// `weeklyActivityControllerProvider` for which days already have a logged
/// workout, so it never fetches logs a second time.
class WorkoutScheduleCard extends ConsumerWidget {
  const WorkoutScheduleCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final ext = Theme.of(context).extension<AppThemeExtension>()!;
    final profile = ref.watch(currentUserProfileProvider);
    final minutesByDay = ref.watch(weeklyActivityControllerProvider);
    final workoutDays = workoutDaysFromApi(profile.workoutDays);

    if (workoutDays.isEmpty) {
      return _EmptyScheduleCard(profile: profile);
    }

    final weekPlan = computeWeekPlan(
      workoutDays: workoutDays,
      now: DateTime.now(),
      minutesByDay: minutesByDay,
    );
    final todayStatus = todayPlanStatus(weekPlan);
    final statusText = switch (todayStatus) {
      DayPlanStatus.completed => l10n.homeScheduleTodayCompleted,
      DayPlanStatus.workoutDay => l10n.homeScheduleTodayWorkout,
      DayPlanStatus.restDay => l10n.homeScheduleTodayRest,
    };

    // Flat, on-page section — no boxed card — matching every other Home
    // section (`_MetricGrid`, `_RecoveryMapRow`).
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                l10n.homeScheduleCardTitle,
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  color: ext.textPrimary,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
            GestureDetector(
              onTap: () => showWorkoutScheduleSheet(context, ref, profile),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    l10n.homeScheduleEdit,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.w800,
                      fontSize: 12.5,
                    ),
                  ),
                  Icon(
                    Directionality.of(context) == TextDirection.rtl
                        ? Icons.chevron_left_rounded
                        : Icons.chevron_right_rounded,
                    size: 18,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          statusText,
          style: TextStyle(
            color:
                todayStatus == DayPlanStatus.completed
                    ? AppColors.success
                    : ext.textMuted,
            fontWeight: FontWeight.w700,
            fontSize: 12.5,
          ),
        ),
        const SizedBox(height: 14),
        Row(
          children: [
            for (final day in weekPlan)
              Expanded(child: _DayDot(day: day, l10n: l10n)),
          ],
        ),
      ],
    );
  }
}

class _DayDot extends StatelessWidget {
  const _DayDot({required this.day, required this.l10n});

  final DayPlan day;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    final ext = Theme.of(context).extension<AppThemeExtension>()!;
    final (background, foreground, border) = switch (day.status) {
      DayPlanStatus.completed => (AppColors.seedLime, AppColors.seedInk, Colors.transparent),
      DayPlanStatus.workoutDay =>
        day.isToday
            ? (ext.accentGlow.withValues(alpha: 0.18), ext.accentGlow, ext.accentGlow)
            : (Colors.transparent, ext.textPrimary, ext.glassBorder),
      DayPlanStatus.restDay => (Colors.transparent, ext.textMuted, ext.glassBorder),
    };

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 3),
      child: Column(
        children: [
          Container(
            width: 32,
            height: 32,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: background,
              shape: BoxShape.circle,
              border: Border.all(color: border),
            ),
            child:
                day.status == DayPlanStatus.completed
                    ? Icon(Icons.check_rounded, size: 16, color: foreground)
                    : Text(
                      weekdayShortLabel(day.day, l10n).substring(0, 1),
                      style: TextStyle(color: foreground, fontWeight: FontWeight.w800),
                    ),
          ),
          if (day.isToday) ...[
            const SizedBox(height: 4),
            Container(
              width: 4,
              height: 4,
              decoration: BoxDecoration(
                color: ext.accentGlow,
                shape: BoxShape.circle,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _EmptyScheduleCard extends ConsumerWidget {
  const _EmptyScheduleCard({required this.profile});

  final UserProfile profile;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final ext = Theme.of(context).extension<AppThemeExtension>()!;

    // Flat, on-page row — no boxed card — same treatment as the filled state.
    return Row(
      children: [
        Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: ext.accentGlow.withValues(alpha: 0.14),
          ),
          child: Icon(Icons.event_available_rounded, color: ext.accentGlow),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.homeScheduleEmptyTitle,
                style: TextStyle(color: ext.textPrimary, fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: 2),
              Text(
                l10n.homeScheduleEmptyBody,
                style: TextStyle(color: ext.textMuted, fontSize: 12),
              ),
            ],
          ),
        ),
        TextButton(
          onPressed: () => showWorkoutScheduleSheet(context, ref, profile),
          child: Text(l10n.homeScheduleSetUp),
        ),
      ],
    );
  }
}
