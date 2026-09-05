import 'dart:async';

import 'package:nabvera/core/analytics/analytics_service.dart';
import 'package:nabvera/core/network/app_icons.dart';
import 'package:nabvera/core/localization/generated/app_localizations.dart';
import 'package:nabvera/core/routing/app_routes.dart';
import 'package:nabvera/core/theme/app_theme_extension.dart';
import 'package:nabvera/core/widgets/featured_card.dart';
import 'package:nabvera/core/widgets/premium_scaffold.dart';
import 'package:nabvera/core/widgets/primary_button.dart';
import 'package:nabvera/features/community/presentation/providers/community_controller.dart';
import 'package:nabvera/features/home/presentation/providers/home_dashboard_controller.dart';
import 'package:nabvera/features/profile/presentation/providers/workout_schedule_controller.dart';
import 'package:nabvera/features/workout/data/workout_repository.dart';
import 'package:nabvera/features/workout/domain/difficulty_rating.dart';
import 'package:nabvera/features/workout/domain/exercise_detail_models.dart';
import 'package:nabvera/features/workout/presentation/widgets/round_item_tile.dart';
import 'package:nabvera/features/workout/presentation/widgets/workout_header.dart';
import 'package:nabvera/features/workout/presentation/widgets/workout_rating_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// A logged duration must be a real, plausible measurement — mirrors the
/// backend's own bounds (`backend/src/utils/workoutLogHelpers.js`) so a
/// client-side timer glitch (screen left open for days, or finished within
/// the same second it started) can't produce a rejected or nonsensical log.
const int _kMinLoggedMinutes = 1;
const int _kMaxLoggedMinutes = 300;

/// Generic workout-category screen — replaces the legacy AdvanceCategory,
/// IntermediateCategory, and FunctionalPage, which shared this exact
/// layout (hero card + round groups) and only differed by data.
class CategoryDetailPage extends ConsumerStatefulWidget {
  const CategoryDetailPage({super.key, required this.data});

  final CategoryDetailData data;

  @override
  ConsumerState<CategoryDetailPage> createState() => _CategoryDetailPageState();
}

class _CategoryDetailPageState extends ConsumerState<CategoryDetailPage> {
  bool _submitting = false;
  DateTime? _startedAt;
  Timer? _ticker;
  Duration _elapsed = Duration.zero;

  CategoryDetailData get data => widget.data;
  bool get _started => _startedAt != null;

  @override
  void dispose() {
    _ticker?.cancel();
    super.dispose();
  }

  void _startWorkout() {
    if (_started) return;
    setState(() {
      _startedAt = DateTime.now();
      _elapsed = Duration.zero;
    });
    _ticker = Timer.periodic(const Duration(seconds: 1), (_) {
      final startedAt = _startedAt;
      if (startedAt == null || !mounted) return;
      setState(() => _elapsed = DateTime.now().difference(startedAt));
    });
    unawaited(
      ref.read(analyticsServiceProvider).logEvent(AnalyticsEvent.workoutStarted, {
        if (data.workoutId != null) 'workoutId': data.workoutId,
        'durationMinutes': data.durationMinutes,
      }),
    );
  }

  /// Prompts for a difficulty rating (skippable), then logs the workout
  /// regardless of whether a rating was given. Rating collection and
  /// logging are one user action — asking again separately later would
  /// just add friction for something the rating sheet's Skip already covers.
  Future<void> _finishWorkout(
    BuildContext context,
    AppLocalizations l10n,
  ) async {
    if (_submitting) return;
    final rating = await showWorkoutRatingSheet(context);
    if (!context.mounted) return;

    setState(() => _submitting = true);
    _ticker?.cancel();
    // The real, measured elapsed time — never 0 (a workout finished within
    // the same minute it started still counts as at least one minute) and
    // capped well above any realistic single session.
    final actualMinutes = _startedAt == null
        ? null
        : _elapsed.inSeconds ~/ 60 == 0 && _elapsed.inSeconds > 0
            ? _kMinLoggedMinutes
            : _elapsed.inMinutes.clamp(_kMinLoggedMinutes, _kMaxLoggedMinutes);
    try {
      final analytics = ref.read(analyticsServiceProvider);
      await ref
          .read(workoutRepositoryProvider)
          .createWorkoutLog(
            title: data.heroLabel,
            durationMinutes: data.durationMinutes,
            caloriesBurned: data.estimatedCalories,
            workoutId: data.workoutId,
            difficultyRating: rating,
            actualDurationMinutes: actualMinutes,
          );
      unawaited(
        analytics.logEvent(AnalyticsEvent.workoutCompleted, {
          if (data.workoutId != null) 'workoutId': data.workoutId,
          'durationMinutes': data.durationMinutes,
          if (actualMinutes != null) 'actualDurationMinutes': actualMinutes,
        }),
      );
      if (rating != null) {
        unawaited(
          analytics.logEvent(AnalyticsEvent.workoutRated, {
            if (data.workoutId != null) 'workoutId': data.workoutId,
            'difficultyRating': rating.apiValue,
          }),
        );
      }
      // The workout log just changed today's minutes, this week's
      // progress, and (via a rating) tomorrow's recommendation — refresh
      // Home so it's current the moment the user navigates back, with no
      // restart or manual pull needed.
      refreshHomeProviders(ref);
      // The backend may have just advanced (or completed) one of the
      // user's active challenges from this same log — refresh those too.
      refreshChallengeProviders(ref);
      // A workout is now logged for today — cancel/skip today's local
      // reminder instead of nagging someone who already showed up.
      unawaited(syncWorkoutReminders(ref, hasWorkoutTodayOverride: true));
      if (!context.mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(l10n.workoutLogSavedSuccess)));
    } catch (_) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(l10n.workoutLogSaveFailed)));
    } finally {
      if (mounted) {
        setState(() {
          _submitting = false;
          _startedAt = null;
          _elapsed = Duration.zero;
        });
      }
    }
  }

  String _formatElapsed(Duration elapsed) {
    final minutes = elapsed.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = elapsed.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

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
                        FeaturedCardMeta(icon: AppIcons.time, label: data.time),
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
                        // Only a real backed-by-the-API workout has an id to
                        // log against — curated/mock content (no workoutId)
                        // has nothing for "start"/"finish" to actually save.
                        if (data.workoutId != null && !_started)
                          PrimaryButton(
                            label: l10n.workoutStartWorkout,
                            icon: Icons.play_circle_outline_rounded,
                            onPressed: _startWorkout,
                          ),
                        if (data.workoutId != null && _started) ...[
                          Center(
                            child: Text(
                              _formatElapsed(_elapsed),
                              style: TextStyle(
                                color: ext.textPrimary,
                                fontSize: 32,
                                fontWeight: FontWeight.w900,
                                fontFeatures: const [
                                  FontFeature.tabularFigures(),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),
                          PrimaryButton(
                            label: l10n.workoutFinishWorkout,
                            icon: Icons.check_circle_outline_rounded,
                            isLoading: _submitting,
                            onPressed: () => _finishWorkout(context, l10n),
                          ),
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
