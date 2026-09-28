import 'package:nabvera/core/theme/app_colors.dart';
import 'package:nabvera/features/workout/data/workout_repository.dart';
import 'package:nabvera/features/workout/presentation/widgets/workout_surface.dart';
import 'package:nabvera/core/localization/generated/app_localizations.dart';
import 'package:nabvera/core/responsive/app_responsive.dart';
import 'package:nabvera/core/theme/app_theme_extension.dart';
import 'package:nabvera/core/widgets/primary_button.dart';
import 'package:nabvera/core/widgets/smart_image.dart';
import 'package:nabvera/features/workout/domain/exercise_detail_models.dart';
import 'package:nabvera/features/workout/presentation/widgets/exercise_video_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart' as intl;

/// Generic exercise video/detail screen — replaces the legacy squat_page,
/// kettlball, video_advance, details_page, and details_dumple_setup, which
/// were the same layout copy-pasted with different hardcoded strings.
class ExerciseDetailPage extends ConsumerStatefulWidget {
  const ExerciseDetailPage({super.key, required this.data});

  final ExerciseDetailData data;

  @override
  ConsumerState<ExerciseDetailPage> createState() => _ExerciseDetailPageState();
}

class _ExerciseDetailPageState extends ConsumerState<ExerciseDetailPage> {
  final _videoKey = GlobalKey<ExerciseVideoPlayerState>();
  final _scrollController = ScrollController();
  Future<List<Map<String, dynamic>>>? _historyFuture;

  ExerciseDetailData get data => widget.data;

  @override
  void initState() {
    super.initState();
    // Only a real, backend-backed exercise has any history to show —
    // curated/mock content (no exerciseId) never logged a set anywhere.
    final exerciseId = data.exerciseId;
    if (exerciseId != null) {
      _historyFuture = ref
          .read(workoutRepositoryProvider)
          .fetchExerciseHistory(exerciseId);
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _startWorkout(BuildContext context, AppLocalizations l10n) {
    if (data.videoUrl == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(l10n.workoutNoVideoAvailable)));
      return;
    }
    _scrollController.animateTo(
      0,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
    _videoKey.currentState?.play();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final ext = theme.extension<AppThemeExtension>()!;
    final l10n = AppLocalizations.of(context);

    return WorkoutScaffold(
      padding: EdgeInsets.zero,
      bottomBar: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 16),
          child: PrimaryButton(
            showShadow: false,
            label: l10n.workoutStartWorkout,
            icon: Icons.play_arrow_rounded,
            onPressed: () => _startWorkout(context, l10n),
          ),
        ),
      ),
      child: SingleChildScrollView(
        controller: _scrollController,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _Hero(data: data, videoKey: _videoKey),
            const SizedBox(height: 22),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    workoutCopy(context, 'نظرة عامة', 'Overview'),
                    style: TextStyle(
                      color: ext.accentGlow,
                      fontSize: 13,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 0.3,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    data.localizedDescription(context),
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: ext.textMuted,
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 22),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: _InfoStat(
                          icon: Icons.fitness_center_rounded,
                          label: l10n.workoutMuscleGroupLabel,
                          value: data.muscleGroup,
                          ext: ext,
                        ),
                      ),
                      Expanded(
                        child: _InfoStat(
                          icon: Icons.trending_up_rounded,
                          label: l10n.workoutDifficultyLabel,
                          value: data.level,
                          ext: ext,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Divider(height: 1, color: ext.glassBorder),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: _InfoStat(
                          icon: Icons.timer_outlined,
                          label: data.duration,
                          value: data.reps,
                          ext: ext,
                        ),
                      ),
                      Expanded(
                        child: _InfoStat(
                          icon: Icons.handyman_outlined,
                          label: l10n.workoutEquipmentLabel,
                          value: data.equipment,
                          ext: ext,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            if (_historyFuture != null) ...[
              const SizedBox(height: 22),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: _ExerciseHistorySection(future: _historyFuture!),
              ),
            ],
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

/// Full-bleed hero — the video/image fills the entire screen width (no
/// side margins, no rounded corners) with the back button and title
/// floating on top, matching the pattern already used for a recipe's hero
/// in `meal_detail_header.dart`. Replaces the old inset, rounded-card
/// video box plus a separate header row (which also carried search/
/// notifications icons that don't belong on a focused exercise screen).
class _Hero extends StatelessWidget {
  const _Hero({required this.data, required this.videoKey});

  final ExerciseDetailData data;
  final GlobalKey<ExerciseVideoPlayerState> videoKey;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final topInset = MediaQuery.paddingOf(context).top;
    final height = context.responsive(
      compact: 340.0,
      standard: 380.0,
      medium: 420.0,
      expanded: 460.0,
    );

    return SizedBox(
      height: height,
      width: double.infinity,
      child: Stack(
        fit: StackFit.expand,
        children: [
          data.videoUrl == null
              ? Hero(tag: data.heroImage, child: SmartImage(data.heroImage))
              : ExerciseVideoPlayer(
                key: videoKey,
                videoUrl: data.videoUrl!,
                poster: SmartImage(data.heroImage),
              ),
          IgnorePointer(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppColors.seedInk.withValues(alpha: 0.32),
                    AppColors.seedInk.withValues(alpha: 0),
                    AppColors.seedInk.withValues(alpha: 0.6),
                  ],
                  stops: const [0, 0.4, 1],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
          ),
          PositionedDirectional(
            top: topInset + 10,
            start: 14,
            child: GestureDetector(
              onTap: () => context.canPop() ? context.pop() : null,
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.36),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Directionality.of(context) == TextDirection.rtl
                      ? Icons.arrow_forward_ios_rounded
                      : Icons.arrow_back_ios_new_rounded,
                  color: Colors.white,
                  size: 18,
                ),
              ),
            ),
          ),
          PositionedDirectional(
            start: 16,
            end: 16,
            bottom: 16,
            child: Text(
              data.localizedTitle(context),
              style: theme.textTheme.headlineSmall?.copyWith(
                color: AppColors.lightSurface,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// This exercise's own weight/reps progress across past sessions —
/// answers "am I actually getting stronger at this?" for one specific
/// exercise, which the app's existing workout-level history/charts never
/// broke down to. Silently hides itself on a fetch failure, same as this
/// screen's "no history yet" empty state — a progress nicety failing to
/// load shouldn't read as an error on top of the exercise's own content.
class _ExerciseHistorySection extends StatelessWidget {
  const _ExerciseHistorySection({required this.future});

  final Future<List<Map<String, dynamic>>> future;

  @override
  Widget build(BuildContext context) {
    final ext = Theme.of(context).extension<AppThemeExtension>()!;
    final l10n = AppLocalizations.of(context);

    return FutureBuilder<List<Map<String, dynamic>>>(
      future: future,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const Padding(
            padding: EdgeInsets.symmetric(vertical: 12),
            child: Center(
              child: SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            ),
          );
        }
        if (snapshot.hasError) return const SizedBox.shrink();

        final sessions = snapshot.data ?? const [];
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.workoutHistoryTitle,
              style: TextStyle(
                color: ext.accentGlow,
                fontSize: 13,
                fontWeight: FontWeight.w800,
                letterSpacing: 0.3,
              ),
            ),
            const SizedBox(height: 10),
            if (sessions.isEmpty)
              Text(
                l10n.workoutHistoryEmpty,
                style: TextStyle(color: ext.textMuted, height: 1.4),
              )
            else
              for (final session in sessions) ...[
                _SessionHistoryRow(session: session, l10n: l10n, ext: ext),
                if (session != sessions.last) const SizedBox(height: 12),
              ],
          ],
        );
      },
    );
  }
}

class _SessionHistoryRow extends StatelessWidget {
  const _SessionHistoryRow({
    required this.session,
    required this.l10n,
    required this.ext,
  });

  final Map<String, dynamic> session;
  final AppLocalizations l10n;
  final AppThemeExtension ext;

  @override
  Widget build(BuildContext context) {
    final completedAt = DateTime.tryParse(
      (session['completedAt'] as String?) ?? '',
    );
    final sets =
        (session['sets'] as List? ?? const []).cast<Map<String, dynamic>>();

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 72,
          child: Text(
            completedAt == null
                ? '—'
                : intl.DateFormat('MMM d').format(completedAt),
            style: TextStyle(
              color: ext.textMuted,
              fontSize: 12,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        Expanded(
          child: Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final set in sets)
                if (set['weightKg'] != null && set['reps'] != null)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      color: ext.accentGlow.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: Text(
                      l10n.workoutHistorySetSummary(
                        _formatWeight(set['weightKg'] as num),
                        (set['reps'] as num).toInt(),
                      ),
                      style: TextStyle(
                        color: ext.accentGlow,
                        fontSize: 12,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
            ],
          ),
        ),
      ],
    );
  }

  static String _formatWeight(num value) =>
      value == value.roundToDouble() ? value.toInt().toString() : '$value';
}

class _InfoStat extends StatelessWidget {
  const _InfoStat({
    required this.icon,
    required this.label,
    required this.value,
    required this.ext,
  });

  final IconData icon;
  final String label;
  final String value;
  final AppThemeExtension ext;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 38,
          height: 38,
          decoration: BoxDecoration(
            color: ext.accentGlow.withValues(alpha: 0.14),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: ext.accentGlow, size: 19),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                value,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: ext.textPrimary,
                  fontWeight: FontWeight.w800,
                  fontSize: 13.5,
                ),
              ),
              Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(color: ext.textMuted, fontSize: 11),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
