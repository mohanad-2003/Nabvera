import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';

/// Passed via GoRouter `extra` to the generic [ExerciseDetailPage] —
/// replaces 5 near-identical legacy screens (squat_page, kettlball,
/// video_advance, details_page, details_dumple_setup) that only differed
/// by these values.
class ExerciseDetailData {
  /// Shown for a curated/mock exercise with no [description] of its own,
  /// and reused by [RoundExerciseItem]-building code (see
  /// `_roundItemFromEntry`) as the fallback when a real `Exercise` simply
  /// hasn't had a description written for it yet.
  static const defaultDescription =
      'Keep your core braced and move through the full range of motion with control. Focus on steady breathing and stop if you feel sharp pain.';

  const ExerciseDetailData({
    required this.headerTitle,
    required this.heroImage,
    required this.title,
    this.description = defaultDescription,
    this.duration = '30 seconds',
    this.reps = '3 Rep',
    this.level = 'Beginner',
    this.muscleGroup = 'Full Body',
    this.equipment = 'Bodyweight',
    this.videoUrl,
    this.titleAr = '',
    this.descriptionAr = '',
  });

  final String headerTitle;
  final String heroImage;
  final String title;
  final String description;
  final String duration;
  final String reps;
  final String level;
  final String muscleGroup;
  final String equipment;

  /// From the backend's `Exercise.videoUrl` — null for curated/mock content
  /// that has no real exercise behind it.
  final String? videoUrl;

  /// Arabic translation, from `Exercise.nameAr` — empty for an exercise an
  /// admin hasn't translated yet, in which case [localizedTitle] falls
  /// back to [title] (same pattern as `ArticleTip.localizedTitle`).
  final String titleAr;

  /// Arabic translation of [description], from `Exercise.descriptionAr` —
  /// same fallback contract as [titleAr].
  final String descriptionAr;

  String localizedTitle(BuildContext context) =>
      Localizations.localeOf(context).languageCode == 'ar' && titleAr.isNotEmpty
          ? titleAr
          : title;

  String localizedDescription(BuildContext context) =>
      Localizations.localeOf(context).languageCode == 'ar' &&
              descriptionAr.isNotEmpty
          ? descriptionAr
          : description;
}

/// A single tappable round entry inside a [CategoryDetailData] round group.
class RoundExerciseItem {
  const RoundExerciseItem({
    required this.name,
    required this.time,
    required this.reps,
    required this.accent,
    this.exerciseDetail,
    this.nameAr = '',
    this.setsCount = 3,
  });

  final String name;
  final String time;
  final String reps;
  final Color accent;

  /// The real number of sets backing [time]'s "N sets" display text — used
  /// to render one tappable set-completion pill per set during an active
  /// workout session (see [CategoryDetailPage]/`_SessionExerciseTile`).
  /// Defaults to 3 for curated/mock content and legacy call sites that
  /// never populate it (weekly challenges, workout_category_data.dart's
  /// static rounds) — those never reach an active session anyway, since
  /// Start/Finish only ever appears for a real, workoutId-backed workout.
  final int setsCount;

  /// When set, tapping this round item pushes [ExerciseDetailPage] with
  /// this data; otherwise the item is inert (matches legacy behavior where
  /// most round items had no `onTap`).
  final ExerciseDetailData? exerciseDetail;

  /// Arabic translation, from `Exercise.nameAr` — same fallback contract
  /// as [ExerciseDetailData.titleAr].
  final String nameAr;

  String localizedName(BuildContext context) =>
      Localizations.localeOf(context).languageCode == 'ar' && nameAr.isNotEmpty
          ? nameAr
          : name;
}

class RoundGroup {
  const RoundGroup({required this.title, required this.items});

  final String title;
  final List<RoundExerciseItem> items;
}

/// Passed via GoRouter `extra` to the generic [CategoryDetailPage] —
/// replaces 3 near-identical legacy screens (advance_category,
/// intermediate_category, functional_page).
class CategoryDetailData {
  const CategoryDetailData({
    required this.headerTitle,
    required this.heroImage,
    required this.heroLabel,
    required this.time,
    required this.calories,
    required this.levelLabel,
    required this.rounds,
    this.workoutId,
    this.durationMinutes = 0,
    this.estimatedCalories = 0,
    this.heroLabelAr = '',
  });

  final String headerTitle;
  final String heroImage;
  final String heroLabel;
  final String time;
  final String calories;
  final String levelLabel;
  final List<RoundGroup> rounds;

  /// The backing `/api/workouts` document id, plus its raw numeric duration
  /// and calories — kept alongside the already-formatted display strings
  /// above (`time`, `calories`) so "Finish Workout" can log a real
  /// [WorkoutLog] without re-parsing display text. Null/zero for curated
  /// content that has no real workout behind it (finishing is hidden then).
  final String? workoutId;
  final int durationMinutes;
  final int estimatedCalories;

  /// Arabic translation, from `Workout.titleAr` — same fallback contract
  /// as `ExerciseDetailData.titleAr`.
  final String heroLabelAr;

  String localizedHeroLabel(BuildContext context) =>
      Localizations.localeOf(context).languageCode == 'ar' &&
              heroLabelAr.isNotEmpty
          ? heroLabelAr
          : heroLabel;

  static const _accents = [
    AppColors.seedViolet,
    AppColors.seedLime,
    AppColors.aquaBlue,
    AppColors.electricOrange,
  ];

  static const _difficultyLabels = {
    'beginner': 'Beginner',
    'intermediate': 'Intermediate',
    'advanced': 'Advanced',
  };

  static const _muscleGroupLabels = {
    'chest': 'Chest',
    'back': 'Back',
    'legs': 'Legs',
    'shoulders': 'Shoulders',
    'arms': 'Arms',
    'core': 'Core',
    'full_body': 'Full Body',
    'cardio': 'Cardio',
  };

  /// Builds a real workout's detail screen from a `/api/workouts/:id`
  /// (or list) JSON document — one round group listing its exercises, each
  /// tappable into its own [ExerciseDetailData] (with a real video when the
  /// underlying `Exercise` has one).
  factory CategoryDetailData.fromWorkoutJson(Map<String, dynamic> json) {
    final difficulty = json['difficulty'] as String? ?? 'beginner';
    final entries = (json['exercises'] as List? ?? const [])
        .cast<Map<String, dynamic>>();
    final items = [
      for (var i = 0; i < entries.length; i++)
        if (entries[i]['exercise'] is Map<String, dynamic>)
          _roundItemFromEntry(entries[i], i),
    ];

    return CategoryDetailData(
      headerTitle: _difficultyLabels[difficulty] ?? 'Workout',
      heroImage: (json['coverImageUrl'] as String?) ?? 'assets/workout.png',
      heroLabel: (json['title'] as String?) ?? '',
      heroLabelAr: (json['titleAr'] as String?) ?? '',
      time: '${json['durationMinutes'] ?? '—'} Minutes',
      calories: '${json['estimatedCalories'] ?? '—'} Kcal',
      levelLabel: _difficultyLabels[difficulty] ?? 'Beginner',
      rounds: [RoundGroup(title: 'Exercises', items: items)],
      workoutId: json['_id'] as String?,
      durationMinutes: (json['durationMinutes'] as num?)?.toInt() ?? 0,
      estimatedCalories: (json['estimatedCalories'] as num?)?.toInt() ?? 0,
    );
  }

  static RoundExerciseItem _roundItemFromEntry(
    Map<String, dynamic> entry,
    int index,
  ) {
    final exercise = entry['exercise'] as Map<String, dynamic>;
    final name = (exercise['name'] as String?) ?? '';
    final nameAr = (exercise['nameAr'] as String?) ?? '';
    final sets = (entry['sets'] as num?) ?? (exercise['defaultSets'] as num?) ?? 3;
    final reps = (entry['reps'] as num?) ?? (exercise['defaultReps'] as num?) ?? 12;
    final image = (exercise['imageUrl'] as String?) ?? 'assets/workout.png';
    // Only override the constructor's generic-tip default when the
    // backend actually has real copy for this exercise — an empty string
    // would otherwise blank out that fallback instead of using it.
    final description = exercise['description'] as String?;
    final descriptionAr = exercise['descriptionAr'] as String?;

    return RoundExerciseItem(
      name: name,
      nameAr: nameAr,
      time: '$sets sets',
      reps: '${reps}x Reps',
      accent: _accents[index % _accents.length],
      setsCount: sets.toInt().clamp(1, 20),
      exerciseDetail: ExerciseDetailData(
        headerTitle: name,
        heroImage: image,
        title: name,
        titleAr: nameAr,
        // Was never wired at all — every exercise fell back to
        // ExerciseDetailData's hardcoded generic default regardless of
        // its real Exercise.description (see the class doc comment).
        // Falls back to that same default (rather than blank text) for an
        // exercise that doesn't have one written yet.
        description:
            description == null || description.isEmpty
                ? ExerciseDetailData.defaultDescription
                : description,
        descriptionAr: descriptionAr ?? '',
        duration: '$sets sets',
        reps: '${reps}x Reps',
        muscleGroup:
            _muscleGroupLabels[exercise['muscleGroup'] as String?] ??
            'Full Body',
        videoUrl: exercise['videoUrl'] as String?,
      ),
    );
  }
}
