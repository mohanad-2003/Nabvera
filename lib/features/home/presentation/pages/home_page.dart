import 'dart:async';
import 'package:nabvera/core/analytics/analytics_service.dart';
import 'package:nabvera/core/localization/generated/app_localizations.dart';
import 'package:nabvera/core/routing/app_routes.dart';
import 'package:nabvera/core/theme/app_colors.dart';
import 'package:nabvera/core/theme/app_theme_extension.dart';
import 'package:nabvera/core/widgets/fade_slide_in.dart';
import 'package:nabvera/core/widgets/pressable_scale.dart';
import 'package:nabvera/core/widgets/smart_image.dart';
import 'package:nabvera/core/widgets/user_avatar.dart';
import 'package:nabvera/features/home/domain/home_models.dart';
import 'package:nabvera/features/home/presentation/providers/home_controller.dart';
import 'package:nabvera/features/home/presentation/providers/home_dashboard_controller.dart';
import 'package:nabvera/features/health/presentation/widgets/health_snapshot_card.dart';
import 'package:nabvera/features/home/presentation/widgets/workout_schedule_card.dart';
import 'package:nabvera/features/notification/presentation/providers/notification_controller.dart';
import 'package:nabvera/features/nutrition/presentation/providers/nutrition_controller.dart';
import 'package:nabvera/features/nutrition/presentation/widgets/log_water_sheet.dart';
import 'package:nabvera/features/profile/domain/profile_models.dart';
import 'package:nabvera/features/profile/presentation/providers/profile_controller.dart';
import 'package:nabvera/features/profile/presentation/providers/workout_schedule_controller.dart';
import 'package:nabvera/features/workout/data/workout_repository.dart';
import 'package:nabvera/features/workout/domain/exercise_detail_models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// A daily activity-minutes target used to frame the raw "minutes trained"
/// number as progress toward a goal. No backend field carries a per-user
/// target yet, so this mirrors common fitness-app defaults.
const int _kDailyMinutesGoal = 30;

/// Weekly workout-count target for the "Weekly Progress" section, for the
/// same reason as [_kDailyMinutesGoal].
const int _kWeeklyWorkoutGoal = 5;

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categories = ref.watch(homeCategoriesProvider);
    final recommendations = ref.watch(homeRecommendationsProvider);
    final articles = ref.watch(homeArticlesProvider);
    final profile = ref.watch(currentUserProfileProvider);
    final ext = Theme.of(context).extension<AppThemeExtension>()!;
    final l10n = AppLocalizations.of(context);
    final unreadNotificationCount = ref.watch(unreadNotificationCountProvider);
    // Fires once per sign-in (empty -> loaded), re-syncing local workout
    // reminders against whatever schedule is on the freshly-loaded
    // profile — the "app just opened" trigger alongside the explicit ones
    // in `edit_profile_page.dart`/`category_detail_page.dart`.
    ref.listen<UserProfile>(currentUserProfileProvider, (previous, next) {
      if ((previous == null || previous.id.isEmpty) && next.id.isNotEmpty) {
        unawaited(syncWorkoutReminders(ref));
      }
    });
    // AppBottomNav floats over the body (Scaffold.extendBody) at ~66dp tall
    // plus its own bottom safe-area margin — pad the list an extra amount
    // beyond that so the last section never sits under the glass pill.
    final navClearance = MediaQuery.paddingOf(context).bottom + 66 + 46;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(gradient: ext.backgroundGradient),
        child: SafeArea(
          bottom: false,
          child: RefreshIndicator(
            color: ext.accentGlow,
            backgroundColor: ext.cardColor,
            onRefresh: () => _pullToRefresh(ref),
            child: ListView(
              padding: EdgeInsets.fromLTRB(20, 18, 20, navClearance),
              children: [
                FadeSlideIn(
                  child: _HomeHeader(
                    firstName: _firstName(profile.name),
                    avatarUrl: profile.avatarUrl,
                    streak: profile.currentStreak,
                    onNotificationTap:
                        () => context.push(AppRoutes.notifications),
                    unreadNotificationCount: unreadNotificationCount,
                  ),
                ),
                const SizedBox(height: 22),
                FadeSlideIn(
                  delay: const Duration(milliseconds: 60),
                  child: _TodayHeroCard(
                    onOpen: () => _openTodayWorkout(context, ref),
                    onSwitchTo: (id) => _switchToAlternative(context, ref, id),
                  ),
                ),
                const SizedBox(height: 18),
                FadeSlideIn(
                  delay: const Duration(milliseconds: 90),
                  child: const WorkoutScheduleCard(),
                ),
                const SizedBox(height: 18),
                FadeSlideIn(
                  delay: const Duration(milliseconds: 95),
                  child: const HealthSnapshotCard(),
                ),
                const SizedBox(height: 18),
                FadeSlideIn(
                  delay: const Duration(milliseconds: 100),
                  child: const _MetricGrid(),
                ),
                const SizedBox(height: 22),
                FadeSlideIn(
                  delay: const Duration(milliseconds: 115),
                  child: const _RecoveryMapRow(),
                ),
                const SizedBox(height: 22),
                FadeSlideIn(
                  delay: const Duration(milliseconds: 130),
                  child: _NextStepCard(
                    onOpen: (route) => _openNextStep(context, ref, route),
                  ),
                ),
                const SizedBox(height: 26),
                _SectionHeader(
                  title: l10n.homeWorkoutCategories,
                  action: l10n.actionExplore,
                  onActionTap: () => context.go(AppRoutes.workout),
                ),
                const SizedBox(height: 14),
                _CategoryRail(
                  categories: categories,
                  onTap: (index) => _openCategory(context, index),
                ),
                const SizedBox(height: 26),
                _SectionHeader(
                  title: l10n.homeRecommended,
                  action: l10n.actionSeeAll,
                  onActionTap: () => context.push(AppRoutes.workoutRecommended),
                ),
                const SizedBox(height: 14),
                SizedBox(
                  height: 216,
                  child: _RecommendedRow(
                    section: recommendations,
                    onTap: (workout) => _openWorkout(context, ref, workout.id),
                    onRetry:
                        () =>
                            ref
                                .read(homeRecommendationsProvider.notifier)
                                .reload(),
                  ),
                ),
                const SizedBox(height: 26),
                const _WeeklyProgressCard(),
                const SizedBox(height: 26),
                _SectionHeader(title: l10n.homeArticlesAndTips),
                const SizedBox(height: 14),
                SizedBox(
                  height: 160,
                  child: _ArticlesRow(
                    section: articles,
                    onTap:
                        (article) => context.push(
                          AppRoutes.articleDetail,
                          extra: article,
                        ),
                    onRetry:
                        () => ref.read(homeArticlesProvider.notifier).reload(),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Awaits a real reload of every provider this page's cards read from,
  /// so the [RefreshIndicator] spinner stays up until fresh data has
  /// actually arrived — not just an optimistic instant dismiss. Calls each
  /// controller's own `refresh()` directly (rather than `refreshHomeProviders`'s
  /// invalidate) since Home already keeps all of these alive via its own
  /// `watch`es, so there's no risk of a provider being torn down mid-reload.
  Future<void> _pullToRefresh(WidgetRef ref) {
    return Future.wait([
      ref.read(homeFeaturedWorkoutControllerProvider.notifier).refresh(),
      ref.read(recoveryMapControllerProvider.notifier).refresh(),
      ref.read(weeklyActivityControllerProvider.notifier).refresh(),
      ref.read(weeklyProgressStatsControllerProvider.notifier).refresh(),
      ref.read(currentUserProfileProvider.notifier).refresh(),
      ref.read(dailyNutritionSummaryControllerProvider.notifier).refresh(),
    ]);
  }

  static String _firstName(String fullName) {
    if (fullName.trim().isEmpty) return '';
    return fullName.trim().split(RegExp(r'\s+')).first;
  }

  void _openCategory(BuildContext context, int index) {
    switch (index) {
      case 0:
        context.go(AppRoutes.workout);
      case 1:
        context.push(AppRoutes.workoutLogs);
      case 2:
        context.go(AppRoutes.nutrition);
      case 3:
        context.go(AppRoutes.community);
    }
  }

  void _openNextStep(
    BuildContext context,
    WidgetRef ref,
    _NextStepRoute route,
  ) {
    switch (route) {
      case _NextStepRoute.water:
        // Logs a real amount right here instead of navigating to a tab
        // with no way to actually record water — see log_water_sheet.dart.
        showLogWaterSheet(context, ref);
      case _NextStepRoute.meal:
        context.go(AppRoutes.nutrition);
      case _NextStepRoute.workout:
        _openTodayWorkout(context, ref);
      case _NextStepRoute.none:
        break;
    }
  }

  Future<void> _openTodayWorkout(BuildContext context, WidgetRef ref) async {
    final featured = ref.read(homeFeaturedWorkoutControllerProvider);
    if (featured == null || featured.id.isEmpty) {
      context.go(AppRoutes.workout);
      return;
    }
    await _openWorkout(context, ref, featured.id);
  }

  /// Fetches the full workout and opens it as a real [CategoryDetailData]
  /// — same as [WorkoutPage]'s cards — instead of faking a single-exercise
  /// [ExerciseDetailData] for what is actually a whole workout (which is
  /// why "Start Workout" always reported no video: a workout itself has
  /// none, only its individual exercises do).
  Future<void> _openWorkout(
    BuildContext context,
    WidgetRef ref,
    String workoutId,
  ) async {
    if (workoutId.isEmpty) return;
    try {
      final json = await ref
          .read(workoutRepositoryProvider)
          .fetchWorkoutById(workoutId);
      if (!context.mounted) return;
      context.push(
        AppRoutes.workoutCategoryDetail,
        extra: CategoryDetailData.fromWorkoutJson(json),
      );
    } catch (_) {
      // Backend unreachable / workout deleted — silently do nothing.
    }
  }

  /// The recovery-aware "switch to this instead" action — logs which
  /// alternative was picked, then opens it exactly like any other workout.
  Future<void> _switchToAlternative(
    BuildContext context,
    WidgetRef ref,
    String workoutId,
  ) async {
    ref.read(analyticsServiceProvider).logEvent(
      AnalyticsEvent.alternativeWorkoutSelected,
      {'alternativeWorkoutId': workoutId},
    );
    await _openWorkout(context, ref, workoutId);
  }
}

class _HomeHeader extends StatelessWidget {
  const _HomeHeader({
    required this.firstName,
    required this.avatarUrl,
    required this.streak,
    required this.onNotificationTap,
    required this.unreadNotificationCount,
  });

  final String firstName;
  final String? avatarUrl;
  final int streak;
  final VoidCallback onNotificationTap;

  final int unreadNotificationCount;

  /// Picks a time-of-day appropriate greeting instead of an always-"Good
  /// Morning" that reads oddly by evening.
  String _greeting(AppLocalizations l10n) {
    final hour = DateTime.now().hour;
    if (hour < 12) return l10n.homeGreetingMorningPlain;
    if (hour < 18) return l10n.homeGreetingAfternoonPlain;
    return l10n.homeGreetingEveningPlain;
  }

  @override
  Widget build(BuildContext context) {
    final ext = Theme.of(context).extension<AppThemeExtension>()!;
    final l10n = AppLocalizations.of(context);
    return Row(
      children: [
        UserAvatar(
          radius: 26,
          borderColor: Theme.of(context).colorScheme.primary,
          borderWidth: 2,
          imageUrl: avatarUrl,
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _greeting(l10n),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(color: ext.textMuted),
              ),
              Text(
                firstName.isEmpty ? '...' : firstName,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: ext.textPrimary,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 4),
              if (streak > 0)
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.local_fire_department_rounded,
                      size: 15,
                      color: AppColors.electricOrange,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      l10n.homeStreakDays(streak),
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppColors.electricOrange,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                )
              else
                Text(
                  l10n.homeTagline,
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.copyWith(color: ext.textMuted),
                ),
            ],
          ),
        ),
        const SizedBox(width: 10),
        _HeaderIcon(
          icon: Icons.search_rounded,
          onTap: () => context.push(AppRoutes.search),
        ),
        const SizedBox(width: 10),
        _HeaderIcon(
          icon: Icons.notifications_none_rounded,
          onTap: onNotificationTap,
          badgeCount: unreadNotificationCount,
        ),
      ],
    );
  }
}

class _HeaderIcon extends StatelessWidget {
  const _HeaderIcon({
    required this.icon,
    required this.onTap,
    this.badgeCount = 0,
  });

  final IconData icon;
  final VoidCallback onTap;

  final int badgeCount;

  @override
  Widget build(BuildContext context) {
    final ext = Theme.of(context).extension<AppThemeExtension>()!;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: SizedBox(
        width: 44,
        height: 44,
        child: Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.center,
          children: [
            Icon(icon, color: ext.textPrimary, size: 22),
            if (badgeCount > 0)
              Positioned(
                top: 4,
                right: 4,
                child: Container(
                  constraints: const BoxConstraints(
                    minWidth: 18,
                    minHeight: 18,
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.error,
                    borderRadius: BorderRadius.circular(9),
                    border: Border.all(color: ext.cardColor, width: 1.5),
                  ),
                  child: Text(
                    badgeCount > 99 ? '99+' : '$badgeCount',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.w800,
                      height: 1,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

/// The single hero card on the page — "Today's Plan" — a clean, flat
/// (no-photo) premium card, fully tappable, with a clear primary CTA that
/// reflects real progress: "Start" when nothing is logged today, "Continue"
/// once some (but not all) of the plan's minutes are in, "Completed" once
/// today's trained minutes reach the plan's target.
class _TodayHeroCard extends ConsumerWidget {
  const _TodayHeroCard({required this.onOpen, required this.onSwitchTo});

  final VoidCallback onOpen;

  /// Opens a specific workout id — used by the recovery-aware alternative
  /// suggestion, separate from [onOpen] (which opens whatever is currently
  /// featured).
  final ValueChanged<String> onSwitchTo;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final ext = Theme.of(context).extension<AppThemeExtension>()!;
    final featured = ref.watch(homeFeaturedWorkoutControllerProvider);
    final todayMinutes =
        ref.watch(weeklyActivityControllerProvider.notifier).todayMinutes;
    ref.watch(weeklyActivityControllerProvider);

    // Still loading (or the backend genuinely has nothing to recommend) —
    // rather than filling the meta/progress rows with fabricated numbers
    // (a fixed "42 minutes", "380 kcal") that don't correspond to anything
    // real, those rows are hidden entirely below until real data lands.
    final hasFeatured = featured != null;
    final difficulty = featured?.difficulty ?? 'intermediate';
    final title = featured?.localizedTitle(context) ?? l10n.homeHeroTitle;
    final duration = featured?.durationMinutes;
    final calories = featured?.estimatedCalories;
    final exerciseCount = featured?.exerciseCount;
    final profile = ref.watch(currentUserProfileProvider);
    final level = switch (difficulty) {
      'intermediate' => l10n.workoutLevelIntermediate,
      'advanced' => l10n.workoutLevelAdvanced,
      'beginner' => l10n.workoutLevelBeginner,
      _ => l10n.workoutLevelIntermediate,
    };

    final progress =
        duration == null || duration <= 0
            ? 0.0
            : (todayMinutes / duration).clamp(0.0, 1.0);
    final isCompleted = hasFeatured && progress >= 1.0;
    final hasStarted = hasFeatured && todayMinutes > 0;
    final completedExercises =
        exerciseCount == null || exerciseCount <= 0
            ? 0
            : (progress * exerciseCount).round().clamp(0, exerciseCount);
    final ctaLabel =
        isCompleted
            ? l10n.homeCtaCompleted
            : hasStarted
            ? l10n.homeCtaContinue
            : l10n.homeCtaStart;
    final ctaIcon =
        isCompleted ? Icons.check_rounded : Icons.play_arrow_rounded;
    // The same strong brand orange used by the badges/CTAs elsewhere in the
    // app (e.g. FeaturedCard's badge, the primary CTA button below) rather
    // than the muted bronze `ext.accentGlow` token reserved for quiet
    // filter-pill/label accents — this card's accent should read as the
    // app's one recognizable orange, not a duller variant of it.
    final metaBg = AppColors.electricOrange.withValues(alpha: 0.12);
    final trackColor =
        isCompleted
            ? ext.success.withValues(alpha: 0.16)
            : AppColors.electricOrange.withValues(alpha: 0.16);

    final hasPhoto = hasFeatured && featured.image.isNotEmpty;
    // A faint wash of the same two brand colors as this card's own
    // badge/CTA gradient — instead of `ext.cardColor` flat (plain white in
    // light mode), which read as a stark, disconnected slab under this
    // card's own photo/badge/CTA accent color. Barely-there (5% alpha) so
    // text contrast is unaffected; in dark mode it warms `ext.cardColor`'s
    // graphite by the same small amount rather than looking untouched.
    final surfaceStart = Color.alphaBlend(
      AppColors.electricOrange.withValues(alpha: 0.05),
      ext.cardColor,
    );
    final surfaceEnd = Color.alphaBlend(
      AppColors.seedLime.withValues(alpha: 0.05),
      ext.cardColor,
    );
    final badge = _HeroBadge(isCompleted: isCompleted, l10n: l10n, ext: ext);
    // Built once, reused by whichever of the two header layouts below is
    // active (never both) — `overlay` swaps its chrome between a solid
    // low-contrast chip (flat header) and a translucent-dark pill (photo
    // header, which needs real contrast against an arbitrary photo).
    _HeroTuneButton? tuneButton({required bool overlay}) =>
        hasFeatured && !isCompleted
            ? _HeroTuneButton(
              onTap:
                  () =>
                      ref
                          .read(homeFeaturedWorkoutControllerProvider.notifier)
                          .chooseEasierWorkout(),
              tooltip: l10n.homeHeroTooHard,
              label: l10n.homeHeroTooHardShort,
              overlay: overlay,
              ext: ext,
            )
            : null;

    return PressableScale(
      child: InkWell(
        onTap: onOpen,
        borderRadius: BorderRadius.circular(26),
        child: Container(
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [surfaceStart, surfaceEnd],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(26),
            // A soft success-green ring once today's plan is done — a
            // clear "you're finished" signal at a glance, rather than the
            // card looking identical to its not-started state.
            border: Border.all(
              color:
                  isCompleted
                      ? ext.success.withValues(alpha: 0.45)
                      : ext.cardBorderColor,
              width: isCompleted ? 1.4 : 1,
            ),
            boxShadow: ext.cardShadow,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // The card's own cover photo, fading into its flat surface
              // color below — gives the page's single most important card
              // a visual identity instead of reading as flatter than every
              // other (photo-backed) card on this page. Falls back to the
              // original all-flat header row while there's no featured
              // workout yet (nothing to show a photo of) or it has none.
              if (hasPhoto)
                _HeroPhotoBand(
                  image: featured.image,
                  // The photo fades into the same tinted surface the rest
                  // of the card uses below, not raw `ext.cardColor` — a
                  // visible seam otherwise where the photo meets the flat
                  // content area.
                  cardColor: surfaceEnd,
                  badge: badge,
                  tuneButton: tuneButton(overlay: true),
                ),
              Padding(
                padding: EdgeInsets.fromLTRB(20, hasPhoto ? 18 : 20, 20, 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (!hasPhoto)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: Row(
                          children: [
                            badge,
                            const Spacer(),
                            if (tuneButton(overlay: false) case final btn?) btn,
                          ],
                        ),
                      ),
                    Text(
                      l10n.homeHeroSuggestedForYou,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: ext.textMuted,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(
                        context,
                      ).textTheme.headlineMedium?.copyWith(
                        color: ext.textPrimary,
                        fontWeight: FontWeight.w800,
                        height: 1.08,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      _recommendationReason(
                        l10n,
                        featured?.reasonCode,
                        profile.availableMinutes,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: ext.textMuted,
                        height: 1.35,
                      ),
                    ),
                    if (hasFeatured) ...[
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          if (duration != null)
                            Expanded(
                              child: _MetaChip(
                                icon: Icons.timer_outlined,
                                label: l10n.homeHeroDuration(duration),
                                background: metaBg,
                                iconColor: AppColors.electricOrange,
                                textColor: ext.textPrimary,
                              ),
                            ),
                          if (duration != null && calories != null)
                            const SizedBox(width: 8),
                          if (calories != null)
                            Expanded(
                              child: _MetaChip(
                                icon: Icons.local_fire_department_outlined,
                                label: l10n.homeHeroCalories(calories),
                                background: metaBg,
                                iconColor: AppColors.electricOrange,
                                textColor: ext.textPrimary,
                              ),
                            ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: _MetaChip(
                              icon: Icons.signal_cellular_alt_rounded,
                              label: level,
                              background: metaBg,
                              iconColor: AppColors.electricOrange,
                              textColor: ext.textPrimary,
                            ),
                          ),
                        ],
                      ),
                    ],
                    if (featured?.alternative != null) ...[
                      const SizedBox(height: 16),
                      _AlternativeSuggestion(
                        alternative: featured!.alternative!,
                        onSwitchTo: onSwitchTo,
                      ),
                    ],
                    if (hasFeatured && exerciseCount != null) ...[
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Text(
                            l10n.homeHeroExercises(exerciseCount),
                            style: Theme.of(
                              context,
                            ).textTheme.bodyMedium?.copyWith(
                              color: ext.textPrimary,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const Spacer(),
                          Text(
                            l10n.homeHeroExerciseProgress(
                              completedExercises,
                              exerciseCount,
                            ),
                            style: Theme.of(
                              context,
                            ).textTheme.bodyMedium?.copyWith(
                              color: ext.textMuted,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(999),
                        child: SizedBox(
                          height: 8,
                          child: Stack(
                            children: [
                              Container(color: trackColor),
                              // Animates toward the new fraction whenever
                              // `progress` changes instead of snapping instantly,
                              // so logging a workout visibly fills the bar rather
                              // than just appearing already-filled next rebuild.
                              TweenAnimationBuilder<double>(
                                duration: const Duration(milliseconds: 600),
                                curve: Curves.easeOutCubic,
                                tween: Tween(
                                  begin: 0,
                                  end: progress <= 0 ? 0 : progress,
                                ),
                                builder:
                                    (context, value, _) => FractionallySizedBox(
                                      widthFactor: value,
                                      child: Container(
                                        decoration: BoxDecoration(
                                          gradient:
                                              isCompleted
                                                  ? null
                                                  : ext.accentGradient,
                                          color:
                                              isCompleted ? ext.success : null,
                                        ),
                                      ),
                                    ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      height: 54,
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          gradient: isCompleted ? null : ext.accentGradient,
                          color: isCompleted ? ext.success : null,
                          borderRadius: BorderRadius.circular(18),
                        ),
                        child: Material(
                          type: MaterialType.transparency,
                          child: InkWell(
                            onTap: onOpen,
                            borderRadius: BorderRadius.circular(18),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  ctaIcon,
                                  color:
                                      isCompleted ? Colors.white : ext.onAccent,
                                  size: 20,
                                ),
                                const SizedBox(width: 8),
                                Flexible(
                                  child: Text(
                                    ctaLabel,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      color:
                                          isCompleted
                                              ? Colors.white
                                              : ext.onAccent,
                                      fontWeight: FontWeight.w900,
                                      fontSize: 15,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Translates the backend's `reasonCode` (a plain enum-like string — see
  /// `recommendationEngine.js`) into localized copy. The backend never
  /// sends pre-rendered text, only this code.
  String _recommendationReason(
    AppLocalizations l10n,
    String? reasonCode,
    int? availableMinutes,
  ) {
    return switch (reasonCode) {
      'last_workout_too_hard' => l10n.homeReasonLastWorkoutTooHard,
      'two_easy_in_a_row' => l10n.homeReasonTwoEasyInARow,
      'user_requested_easier' => l10n.homeReasonUserRequestedEasier,
      'no_workouts_available' => l10n.homeReasonNoWorkoutsAvailable,
      'on_track' => l10n.homeReasonOnTrack,
      'no_history' => l10n.homeHeroPersonalizedReason(availableMinutes ?? 30),
      _ => l10n.homeHeroFallbackReason,
    };
  }
}

/// The hero card's "Today's Plan"/completion badge — split out of
/// [_TodayHeroCard] so the exact same widget can sit either inline (flat
/// header, no photo) or overlaid on [_HeroPhotoBand]'s cover photo.
class _HeroBadge extends StatelessWidget {
  const _HeroBadge({
    required this.isCompleted,
    required this.l10n,
    required this.ext,
  });

  final bool isCompleted;
  final AppLocalizations l10n;
  final AppThemeExtension ext;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 7),
      decoration: BoxDecoration(
        gradient: isCompleted ? null : ext.accentGradient,
        color: isCompleted ? ext.success : null,
        borderRadius: BorderRadius.circular(999),
        boxShadow:
            isCompleted
                ? null
                : [
                  BoxShadow(
                    color: ext.accentGlow.withValues(alpha: 0.3),
                    blurRadius: 14,
                    offset: const Offset(0, 6),
                  ),
                ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isCompleted
                ? Icons.check_circle_rounded
                : Icons.local_fire_department_rounded,
            size: 15,
            color: isCompleted ? Colors.white : ext.onAccent,
          ),
          const SizedBox(width: 6),
          Text(
            isCompleted
                ? l10n.homeHeroCompletionPercent(100)
                : l10n.homeTodayPlanLabel,
            style: TextStyle(
              color: isCompleted ? Colors.white : ext.onAccent,
              fontSize: 12,
              fontWeight: FontWeight.w900,
              letterSpacing: 0.4,
            ),
          ),
        ],
      ),
    );
  }
}

/// The "this is too hard, suggest something easier" action. [overlay] picks
/// between two chrome treatments: a quiet icon-only circle against the
/// card's own flat surface (unchanged from before this card had a photo),
/// or a labeled, translucent-dark pill with real contrast against an
/// arbitrary cover photo — an icon alone read ambiguously there.
class _HeroTuneButton extends StatelessWidget {
  const _HeroTuneButton({
    required this.onTap,
    required this.tooltip,
    required this.label,
    required this.overlay,
    required this.ext,
  });

  final VoidCallback onTap;
  final String tooltip;
  final String label;
  final bool overlay;
  final AppThemeExtension ext;

  @override
  Widget build(BuildContext context) {
    if (!overlay) {
      return Tooltip(
        message: tooltip,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(999),
          child: Container(
            width: 32,
            height: 32,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: ext.cardBorderColor,
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.tune_rounded, size: 16, color: ext.textMuted),
          ),
        ),
      );
    }
    return Tooltip(
      message: tooltip,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(999),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 7),
          decoration: BoxDecoration(
            color: Colors.black.withValues(alpha: 0.4),
            borderRadius: BorderRadius.circular(999),
            border: Border.all(color: Colors.white.withValues(alpha: 0.18)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.tune_rounded, size: 14, color: Colors.white),
              const SizedBox(width: 6),
              Text(
                label,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// The hero card's cover-photo band: the featured workout's real photo,
/// fading into the card's own flat surface color at the bottom so the
/// existing flat content below reads as one continuous card rather than a
/// photo pasted on top of an unrelated surface. [badge]/[tuneButton]
/// overlay it directly instead of sitting on their own row above it.
class _HeroPhotoBand extends StatelessWidget {
  const _HeroPhotoBand({
    required this.image,
    required this.cardColor,
    required this.badge,
    required this.tuneButton,
  });

  final String image;
  final Color cardColor;
  final Widget badge;
  final Widget? tuneButton;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 148,
      child: Stack(
        fit: StackFit.expand,
        children: [
          SmartImage(image),
          DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [cardColor, cardColor.withValues(alpha: 0.0)],
                stops: const [0, 0.75],
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
              ),
            ),
          ),
          PositionedDirectional(top: 14, start: 14, child: badge),
          if (tuneButton != null)
            PositionedDirectional(top: 12, end: 12, child: tuneButton!),
        ],
      ),
    );
  }
}

/// Shown under the hero card's reason line when the primary recommendation
/// touches a muscle group that needs recovery but a fully-recovered
/// alternative is available — a swap, not a warning.
class _AlternativeSuggestion extends StatelessWidget {
  const _AlternativeSuggestion({
    required this.alternative,
    required this.onSwitchTo,
  });

  final AlternativeWorkoutSuggestion alternative;
  final ValueChanged<String> onSwitchTo;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final ext = Theme.of(context).extension<AppThemeExtension>()!;
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.electricOrange.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.electricOrange.withValues(alpha: 0.16),
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.self_improvement_rounded,
            size: 18,
            color: AppColors.electricOrange,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.homeAlternativeAvailable,
                  style: TextStyle(color: ext.textMuted, fontSize: 11),
                ),
                Text(
                  alternative.localizedTitle(context),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: ext.textPrimary,
                    fontWeight: FontWeight.w800,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          TextButton(
            onPressed: () => onSwitchTo(alternative.id),
            style: TextButton.styleFrom(
              foregroundColor: AppColors.electricOrange,
              backgroundColor: AppColors.electricOrange.withValues(alpha: 0.12),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(999),
              ),
            ),
            child: Text(
              l10n.homeSwitchToAlternative,
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w800),
            ),
          ),
        ],
      ),
    );
  }
}

/// One compact metadata pill in the hero card's stat row (duration,
/// calories, level) — a subtle tinted background, never the loud glass
/// style the old photo-backed card needed for contrast.
class _MetaChip extends StatelessWidget {
  const _MetaChip({
    required this.icon,
    required this.label,
    required this.background,
    required this.iconColor,
    required this.textColor,
  });

  final IconData icon;
  final String label;
  final Color background;
  final Color iconColor;
  final Color textColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 15, color: iconColor),
          const SizedBox(width: 5),
          Flexible(
            child: Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: textColor,
                fontSize: 11,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _MetricGrid extends ConsumerWidget {
  const _MetricGrid();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final ext = Theme.of(context).extension<AppThemeExtension>()!;
    final nutrition = ref.watch(dailyNutritionSummaryControllerProvider);
    final streak = ref.watch(currentUserProfileProvider).currentStreak;
    final todayMinutes =
        ref.watch(weeklyActivityControllerProvider.notifier).todayMinutes;
    // Watch the list too so this rebuilds once the async load resolves —
    // `.notifier` alone wouldn't trigger a rebuild on state change.
    ref.watch(weeklyActivityControllerProvider);

    final remaining = (nutrition.goalCalories - nutrition.consumedCalories)
        .clamp(0, nutrition.goalCalories);
    final caloriesValue = remaining <= 0 ? '🎉' : '$remaining';
    final caloriesLabel =
        remaining <= 0 ? l10n.homeCaloriesGoalReached : l10n.homeUnitKcal;
    final caloriesSub =
        remaining <= 0
            ? ''
            : l10n.homeCaloriesConsumedOf(
              nutrition.consumedCalories,
              nutrition.goalCalories,
            );

    final streakLabel =
        streak <= 0
            ? l10n.homeStreakStartMessage
            : streak >= 7
            ? l10n.homeStreakOnFire
            : l10n.homeStreakKeepGoing;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: _MetricStat(
            label: caloriesLabel,
            value: caloriesValue,
            sublabel: caloriesSub,
            icon: Icons.local_fire_department_rounded,
            color: AppColors.electricOrange,
          ),
        ),
        const _MetricDivider(),
        Expanded(
          child: _MetricStat(
            label: l10n.profileStatStreak,
            value: '$streak',
            sublabel: streakLabel,
            icon: Icons.bolt_rounded,
            color: ext.accentGlow,
          ),
        ),
        const _MetricDivider(),
        Expanded(
          child: _MetricStat(
            label: l10n.homeMetricDuration,
            value: '$todayMinutes',
            sublabel: l10n.homeActivityProgress(
              todayMinutes,
              _kDailyMinutesGoal,
            ),
            icon: Icons.timer_rounded,
            color: AppColors.aquaBlue,
          ),
        ),
      ],
    );
  }
}

/// A metric shown directly on the page background — no card container —
/// separated from its neighbors by a thin [_MetricDivider] instead. Frames
/// the raw number with a goal-relative [sublabel] ("120 of 2000 kcal",
/// "Keep it going!") instead of a bare unit tag.
class _MetricStat extends StatelessWidget {
  const _MetricStat({
    required this.label,
    required this.value,
    required this.sublabel,
    required this.icon,
    required this.color,
  });

  final String label;
  final String value;
  final String sublabel;
  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final ext = Theme.of(context).extension<AppThemeExtension>()!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: color, size: 22),
        const SizedBox(height: 10),
        Text(
          value,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            color: ext.textPrimary,
            fontWeight: FontWeight.w900,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: Theme.of(
            context,
          ).textTheme.labelSmall?.copyWith(color: ext.textMuted),
        ),
        if (sublabel.isNotEmpty) ...[
          const SizedBox(height: 2),
          Text(
            sublabel,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: color,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ],
    );
  }
}

class _MetricDivider extends StatelessWidget {
  const _MetricDivider();

  @override
  Widget build(BuildContext context) {
    final ext = Theme.of(context).extension<AppThemeExtension>()!;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Container(width: 1, height: 52, color: ext.glassBorder),
    );
  }
}

/// Compact, always-visible row of every muscle group's recovery status —
/// independent of the hero card's own recommendation, from
/// `GET /api/recovery-map`. Purely "trained recently vs not"; no medical
/// claim, just a plain readiness signal.
class _RecoveryMapRow extends ConsumerWidget {
  const _RecoveryMapRow();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final groups = ref.watch(recoveryMapControllerProvider);
    if (groups.isEmpty) return const SizedBox.shrink();
    final ext = Theme.of(context).extension<AppThemeExtension>()!;
    final l10n = AppLocalizations.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.homeRecoveryTitle,
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
            color: ext.textPrimary,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 10),
        SizedBox(
          height: 34,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: groups.length,
            separatorBuilder: (_, _) => const SizedBox(width: 8),
            itemBuilder:
                (context, index) => _RecoveryChip(group: groups[index]),
          ),
        ),
      ],
    );
  }
}

class _RecoveryChip extends StatelessWidget {
  const _RecoveryChip({required this.group});

  final MuscleGroupRecovery group;

  static String _label(AppLocalizations l10n, String group) => switch (group) {
    'chest' => l10n.muscleGroupChest,
    'back' => l10n.muscleGroupBack,
    'legs' => l10n.muscleGroupLegs,
    'shoulders' => l10n.muscleGroupShoulders,
    'arms' => l10n.muscleGroupArms,
    'core' => l10n.muscleGroupCore,
    'full_body' => l10n.muscleGroupFullBody,
    'cardio' => l10n.muscleGroupCardio,
    _ => group,
  };

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final ext = Theme.of(context).extension<AppThemeExtension>()!;
    final needsRecovery = group.status == RecoveryStatus.needsRecovery;
    final color = needsRecovery ? AppColors.electricOrange : ext.accentGlow;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.14),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: color.withValues(alpha: 0.26)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            needsRecovery
                ? Icons.hourglass_bottom_rounded
                : Icons.check_circle_rounded,
            size: 13,
            color: color,
          ),
          const SizedBox(width: 6),
          Text(
            _label(l10n, group.group),
            style: TextStyle(
              color: ext.textPrimary,
              fontSize: 12,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

enum _NextStepRoute { water, meal, workout, none }

/// A single personalized suggestion — never more than one, so the user
/// always has exactly one obvious next action instead of a checklist.
/// Priority: start today's workout if untouched, then hydration, then
/// logging a meal if calorie intake is low this late in the day, else a
/// plain "great job" acknowledgement.
class _NextStepCard extends ConsumerWidget {
  const _NextStepCard({required this.onOpen});

  final void Function(_NextStepRoute route) onOpen;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final ext = Theme.of(context).extension<AppThemeExtension>()!;
    final todayMinutes =
        ref.watch(weeklyActivityControllerProvider.notifier).todayMinutes;
    ref.watch(weeklyActivityControllerProvider);
    final nutrition = ref.watch(dailyNutritionSummaryControllerProvider);
    final waterCups = nutrition.waterCupsConsumed;
    final hour = DateTime.now().hour;

    late final String text;
    late final IconData icon;
    late final _NextStepRoute route;

    if (todayMinutes <= 0) {
      text = l10n.homeNextStepStartWorkout;
      icon = Icons.play_circle_outline_rounded;
      route = _NextStepRoute.workout;
    } else if (waterCups < 4 && hour < 20) {
      text = l10n.homeNextStepDrinkWater;
      icon = Icons.water_drop_outlined;
      route = _NextStepRoute.water;
    } else if (nutrition.consumedCalories < nutrition.goalCalories * 0.5 &&
        hour >= 12) {
      text = l10n.homeNextStepLogMeal;
      icon = Icons.restaurant_menu_rounded;
      route = _NextStepRoute.meal;
    } else {
      text = l10n.homeNextStepAllDone;
      icon = Icons.emoji_events_outlined;
      route = _NextStepRoute.none;
    }

    return PressableScale(
      enabled: route != _NextStepRoute.none,
      child: InkWell(
        onTap: route == _NextStepRoute.none ? null : () => onOpen(route),
        borderRadius: BorderRadius.circular(20),
        child: Row(
          children: [
            Container(
              width: 46,
              height: 46,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: ext.accentGlow.withValues(alpha: 0.16),
              ),
              child: Icon(icon, color: ext.accentGlow),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.homeNextStepTitle,
                    style: Theme.of(
                      context,
                    ).textTheme.labelSmall?.copyWith(color: ext.textMuted),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    text,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      color: ext.textPrimary,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
            ),
            if (route != _NextStepRoute.none)
              Icon(
                Directionality.of(context) == TextDirection.rtl
                    ? Icons.chevron_left_rounded
                    : Icons.chevron_right_rounded,
                color: ext.textMuted,
              ),
          ],
        ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.title, this.action, this.onActionTap});

  final String title;
  final String? action;
  final VoidCallback? onActionTap;

  @override
  Widget build(BuildContext context) {
    final ext = Theme.of(context).extension<AppThemeExtension>()!;
    return Row(
      children: [
        // Flexible so a long section title (longer locale strings, larger
        // text scale) shrinks instead of pushing the action button off the
        // narrowest supported screens — Spacer alone can't help once the
        // title's own natural width already exceeds the row.
        Flexible(
          child: Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              color: ext.textPrimary,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
        const Spacer(),
        if (action != null)
          TextButton(onPressed: onActionTap, child: Text(action!)),
      ],
    );
  }
}

class _CategoryRail extends StatelessWidget {
  const _CategoryRail({required this.categories, required this.onTap});

  final List<HomeCategory> categories;
  final ValueChanged<int> onTap;

  @override
  Widget build(BuildContext context) {
    final ext = Theme.of(context).extension<AppThemeExtension>()!;
    final accents = [
      ext.accentGlow,
      AppColors.aquaBlue,
      AppColors.electricOrange,
      AppColors.seedViolet,
    ];
    return SizedBox(
      height: 104,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        separatorBuilder: (_, _) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          final category = categories[index];
          final accent = accents[index % accents.length];
          return PressableScale(
            child: InkWell(
              onTap: () => onTap(index),
              borderRadius: BorderRadius.circular(26),
              child: Container(
                width: 104,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: accent.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(26),
                  border: Border.all(color: accent.withValues(alpha: 0.22)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 42,
                      height: 42,
                      decoration: BoxDecoration(
                        color: ext.glassFill,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(9),
                        child: SmartImage(category.image),
                      ),
                    ),
                    const Spacer(),
                    Text(
                      category.name.replaceAll('\n', ' '),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: ext.textPrimary,
                        fontWeight: FontWeight.w800,
                        height: 1.05,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

/// Recommended-workouts row: skeleton while loading, a friendly retry
/// prompt on failure, an empty-state message, or the real horizontal list.
class _RecommendedRow extends StatelessWidget {
  const _RecommendedRow({
    required this.section,
    required this.onTap,
    required this.onRetry,
  });

  final HomeSectionState<RecommendedWorkout> section;
  final ValueChanged<RecommendedWorkout> onTap;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    switch (section.status) {
      case HomeLoadStatus.loading:
        return _SkeletonRow(width: 238);
      case HomeLoadStatus.error:
        return _SectionMessage(
          icon: Icons.cloud_off_rounded,
          message: l10n.homeRecommendedError,
          onRetry: onRetry,
        );
      case HomeLoadStatus.loaded:
        if (section.items.isEmpty) {
          return _SectionMessage(
            icon: Icons.inbox_outlined,
            message: l10n.homeRecommendedEmpty,
          );
        }
        return ListView.separated(
          scrollDirection: Axis.horizontal,
          itemCount: section.items.length,
          separatorBuilder: (_, _) => const SizedBox(width: 14),
          itemBuilder: (context, index) {
            final workout = section.items[index];
            return _WorkoutCard(workout: workout, onTap: () => onTap(workout));
          },
        );
    }
  }
}

class _ArticlesRow extends StatelessWidget {
  const _ArticlesRow({
    required this.section,
    required this.onTap,
    required this.onRetry,
  });

  final HomeSectionState<ArticleTip> section;
  final ValueChanged<ArticleTip> onTap;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    switch (section.status) {
      case HomeLoadStatus.loading:
        return _SkeletonRow(width: 232);
      case HomeLoadStatus.error:
        return _SectionMessage(
          icon: Icons.cloud_off_rounded,
          message: l10n.homeArticlesError,
          onRetry: onRetry,
        );
      case HomeLoadStatus.loaded:
        if (section.items.isEmpty) {
          return _SectionMessage(
            icon: Icons.article_outlined,
            message: l10n.homeArticlesEmpty,
          );
        }
        return ListView.separated(
          scrollDirection: Axis.horizontal,
          itemCount: section.items.length,
          separatorBuilder: (_, _) => const SizedBox(width: 14),
          itemBuilder:
              (context, index) => _ArticleCard(
                article: section.items[index],
                onTap: () => onTap(section.items[index]),
              ),
        );
    }
  }
}

/// A horizontally-scrolling row of shimmering placeholder cards, shown
/// while a section's real data is still loading.
class _SkeletonRow extends StatelessWidget {
  const _SkeletonRow({required this.width});

  final double width;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      scrollDirection: Axis.horizontal,
      itemCount: 3,
      separatorBuilder: (_, _) => const SizedBox(width: 14),
      itemBuilder: (context, index) => _ShimmerBox(width: width),
    );
  }
}

class _ShimmerBox extends StatefulWidget {
  const _ShimmerBox({required this.width});

  final double width;

  @override
  State<_ShimmerBox> createState() => _ShimmerBoxState();
}

class _ShimmerBoxState extends State<_ShimmerBox>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1100),
  )..repeat(reverse: true);

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ext = Theme.of(context).extension<AppThemeExtension>()!;
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        return Container(
          width: widget.width,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(26),
            color: Color.lerp(
              ext.glassFill,
              ext.glassBorder,
              _controller.value,
            ),
          ),
        );
      },
    );
  }
}

/// Compact inline error/empty state for a horizontal section — an icon, a
/// message, and (when [onRetry] is given) a retry button, all centered in
/// the row's own height so it doesn't collapse the layout.
class _SectionMessage extends StatelessWidget {
  const _SectionMessage({
    required this.icon,
    required this.message,
    this.onRetry,
  });

  final IconData icon;
  final String message;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    final ext = Theme.of(context).extension<AppThemeExtension>()!;
    final l10n = AppLocalizations.of(context);
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: ext.textMuted, size: 26),
          const SizedBox(height: 8),
          Text(
            message,
            textAlign: TextAlign.center,
            style: Theme.of(
              context,
            ).textTheme.bodySmall?.copyWith(color: ext.textMuted),
          ),
          if (onRetry != null) ...[
            const SizedBox(height: 8),
            TextButton(onPressed: onRetry, child: Text(l10n.actionRetry)),
          ],
        ],
      ),
    );
  }
}

class _WorkoutCard extends StatelessWidget {
  const _WorkoutCard({required this.workout, required this.onTap});

  final RecommendedWorkout workout;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return PressableScale(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(30),
        child: Container(
          width: 238,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            image: DecorationImage(
              image: smartImageProvider(workout.image),
              fit: BoxFit.cover,
            ),
            border: Border.all(color: Colors.white.withValues(alpha: 0.12)),
          ),
          child: Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              // Clean black scrim (not the app's tinted scaffold background)
              // that only darkens the bottom half, so the photo stays vivid
              // up top instead of looking muddied over its full height.
              gradient: LinearGradient(
                colors: [
                  Colors.transparent,
                  Colors.transparent,
                  Colors.black.withValues(alpha: 0.75),
                ],
                stops: const [0, 0.45, 1],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                _StatusPill(
                  label: l10n.homeRecommendedBadge,
                  icon: Icons.star_rounded,
                ),
                const SizedBox(height: 12),
                Text(
                  workout.localizedTitle(context),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w900,
                    height: 1.02,
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Icon(
                      Icons.timer_outlined,
                      color: Colors.white.withValues(alpha: 0.70),
                      size: 18,
                    ),
                    const SizedBox(width: 5),
                    Text(
                      workout.localizedDuration(context),
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.70),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Icon(
                      Icons.local_fire_department_outlined,
                      color: AppColors.electricOrange,
                      size: 18,
                    ),
                    const SizedBox(width: 5),
                    Text(
                      workout.localizedCalories(context),
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.70),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _WeeklyProgressCard extends ConsumerWidget {
  const _WeeklyProgressCard();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ext = Theme.of(context).extension<AppThemeExtension>()!;
    final l10n = AppLocalizations.of(context);
    final days = [
      l10n.homeDayMon,
      l10n.homeDayTue,
      l10n.homeDayWed,
      l10n.homeDayThu,
      l10n.homeDayFri,
      l10n.homeDaySat,
      l10n.homeDaySun,
    ];
    final minutesByDay = ref.watch(weeklyActivityControllerProvider);
    final todayIndex = DateTime.now().weekday - 1;
    final workoutsThisWeek = minutesByDay.where((m) => m > 0).length;
    final goalProgress = (workoutsThisWeek / _kWeeklyWorkoutGoal).clamp(
      0.0,
      1.0,
    );
    final maxMinutes = minutesByDay.fold(0, (max, m) => m > max ? m : max);

    // Flat, on-page section — no boxed card — matching `_MetricGrid`/
    // `_RecoveryMapRow` just above it. A thin top divider is enough to
    // separate it from the recommendations row before it.
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Divider(color: ext.glassBorder, height: 1),
        const SizedBox(height: 22),
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.homeWeeklyProgress,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: ext.textPrimary,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    l10n.homeWeeklyGoalSummary(
                      workoutsThisWeek,
                      _kWeeklyWorkoutGoal,
                    ),
                    style: Theme.of(
                      context,
                    ).textTheme.bodySmall?.copyWith(color: ext.textMuted),
                  ),
                ],
              ),
            ),
            SizedBox(
              width: 68,
              height: 68,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  CircularProgressIndicator(
                    value: goalProgress,
                    strokeWidth: 7,
                    strokeCap: StrokeCap.round,
                    backgroundColor: ext.glassBorder,
                    valueColor: AlwaysStoppedAnimation(ext.accentGlow),
                  ),
                  Center(
                    child: Text(
                      '$workoutsThisWeek/$_kWeeklyWorkoutGoal',
                      style: TextStyle(
                        color: ext.textPrimary,
                        fontSize: 14,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        SizedBox(
          height: 78,
          child: Row(
            children: [
              for (var i = 0; i < minutesByDay.length; i++)
                Expanded(
                  child: _WeeklyDayTile(
                    label: days[i],
                    minutes: minutesByDay[i],
                    maxMinutes: maxMinutes,
                    isToday: i == todayIndex,
                    ext: ext,
                    minuteLabel: l10n.homeUnitMin,
                  ),
                ),
            ],
          ),
        ),
        const _WeeklyProgressStatsSection(),
      ],
    );
  }
}

/// Total minutes, week-over-week comparison, and longest streak — built
/// from real workout logs only ([WeeklyProgressStats], not client-side
/// heuristics). Shows a plain empty state for a brand-new account instead
/// of a misleading "0% vs last week".
class _WeeklyProgressStatsSection extends ConsumerWidget {
  const _WeeklyProgressStatsSection();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ext = Theme.of(context).extension<AppThemeExtension>()!;
    final l10n = AppLocalizations.of(context);
    final stats = ref.watch(weeklyProgressStatsControllerProvider);

    if (!stats.hasAnyLogs) {
      return Padding(
        padding: const EdgeInsets.only(top: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.homeWeeklyEmptyStateTitle,
              style: TextStyle(
                color: ext.textPrimary,
                fontWeight: FontWeight.w800,
                fontSize: 13,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              l10n.homeWeeklyEmptyStateBody,
              style: TextStyle(color: ext.textMuted, fontSize: 12),
            ),
          ],
        ),
      );
    }

    final delta = stats.minutesDelta;
    final comparisonText =
        stats.totalMinutesLastWeek <= 0
            ? l10n.homeWeeklyNoLastWeekData
            : delta > 0
            ? l10n.homeWeeklyMoreThanLastWeek(delta)
            : delta < 0
            ? l10n.homeWeeklyLessThanLastWeek(-delta)
            : l10n.homeWeeklySameAsLastWeek;

    return Padding(
      padding: const EdgeInsets.only(top: 16),
      child: Wrap(
        spacing: 16,
        runSpacing: 8,
        children: [
          _WeeklyStatChip(
            icon: Icons.timer_outlined,
            label: l10n.homeWeeklyTotalMinutes(stats.totalMinutesThisWeek),
            ext: ext,
          ),
          _WeeklyStatChip(
            icon:
                delta >= 0
                    ? Icons.trending_up_rounded
                    : Icons.trending_down_rounded,
            label: comparisonText,
            ext: ext,
          ),
          _WeeklyStatChip(
            icon: Icons.local_fire_department_outlined,
            label: l10n.homeWeeklyLongestStreak(stats.longestStreakDays),
            ext: ext,
          ),
        ],
      ),
    );
  }
}

class _WeeklyStatChip extends StatelessWidget {
  const _WeeklyStatChip({
    required this.icon,
    required this.label,
    required this.ext,
  });

  final IconData icon;
  final String label;
  final AppThemeExtension ext;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 15, color: ext.textMuted),
        const SizedBox(width: 5),
        Text(
          label,
          style: TextStyle(
            color: ext.textMuted,
            fontSize: 11.5,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}

class _WeeklyDayTile extends StatelessWidget {
  const _WeeklyDayTile({
    required this.label,
    required this.minutes,
    required this.maxMinutes,
    required this.isToday,
    required this.ext,
    required this.minuteLabel,
  });

  final String label;
  final int minutes;
  final int maxMinutes;
  final bool isToday;
  final AppThemeExtension ext;
  final String minuteLabel;

  @override
  Widget build(BuildContext context) {
    final isCompleted = minutes > 0;
    final height =
        maxMinutes == 0 ? 0.12 : (minutes / maxMinutes).clamp(0.12, 1.0);
    final activeColor = isToday ? ext.accentGlow : ext.success;

    return Column(
      children: [
        SizedBox(
          height: 28,
          child:
              isCompleted
                  ? Text(
                    '$minutes$minuteLabel',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: activeColor,
                      fontSize: 9,
                      fontWeight: FontWeight.w800,
                    ),
                  )
                  : null,
        ),
        Expanded(
          child: Align(
            alignment: Alignment.bottomCenter,
            child: FractionallySizedBox(
              widthFactor: 0.45,
              heightFactor: height,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(999),
                  color: isCompleted ? activeColor : ext.glassBorder,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 7),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 3),
          decoration: BoxDecoration(
            color: isToday ? ext.accentGlow.withValues(alpha: 0.16) : null,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            label,
            style: TextStyle(
              color: isToday ? ext.accentGlow : ext.textMuted,
              fontSize: 10,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
      ],
    );
  }
}

class _ArticleCard extends StatelessWidget {
  const _ArticleCard({required this.article, required this.onTap});

  final ArticleTip article;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final ext = Theme.of(context).extension<AppThemeExtension>()!;
    return PressableScale(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(26),
        child: Container(
          width: 232,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(26),
            image: DecorationImage(
              image: smartImageProvider(article.image),
              fit: BoxFit.cover,
            ),
            border: Border.all(color: ext.glassBorder),
          ),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(26),
              // Clean black scrim, bottom half only — see _WorkoutCard for
              // why this replaced the old scaffold-background-tinted one.
              gradient: LinearGradient(
                colors: [
                  Colors.transparent,
                  Colors.transparent,
                  Colors.black.withValues(alpha: 0.72),
                ],
                stops: const [0, 0.45, 1],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            alignment: Alignment.bottomLeft,
            child: Text(
              article.localizedTitle(context),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Status/badge pill. [color] defaults to the fixed brand accent (correct
/// for the two dark-scrim contexts it's used in — hero card, photo cards);
/// pass the theme's `colorScheme.primary` explicitly when placing it on a
/// theme-aware surface like the glass progress card, so it stays readable
/// in light mode too.
class _StatusPill extends StatelessWidget {
  const _StatusPill({required this.label, required this.icon});

  final String label;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    const pillColor = AppColors.seedLime;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 7),
      decoration: BoxDecoration(
        color: pillColor.withValues(alpha: 0.16),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: pillColor.withValues(alpha: 0.24)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 15, color: pillColor),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
              color: pillColor,
              fontSize: 12,
              fontWeight: FontWeight.w900,
              letterSpacing: 0.7,
            ),
          ),
        ],
      ),
    );
  }
}
