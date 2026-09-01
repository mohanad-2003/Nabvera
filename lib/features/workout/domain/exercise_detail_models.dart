import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';

/// Passed via GoRouter `extra` to the generic [ExerciseDetailPage] —
/// replaces 5 near-identical legacy screens (squat_page, kettlball,
/// video_advance, details_page, details_dumple_setup) that only differed
/// by these values.
class ExerciseDetailData {
  const ExerciseDetailData({
    required this.headerTitle,
    required this.heroImage,
    required this.title,
    this.description =
        'Keep your core braced and move through the full range of motion with control. Focus on steady breathing and stop if you feel sharp pain.',
    this.duration = '30 seconds',
    this.reps = '3 Rep',
    this.level = 'Beginner',
    this.muscleGroup = 'Full Body',
    this.equipment = 'Bodyweight',
    this.videoUrl,
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
}

/// A single tappable round entry inside a [CategoryDetailData] round group.
class RoundExerciseItem {
  const RoundExerciseItem({
    required this.name,
    required this.time,
    required this.reps,
    required this.accent,
    this.exerciseDetail,
  });

  final String name;
  final String time;
  final String reps;
  final Color accent;

  /// When set, tapping this round item pushes [ExerciseDetailPage] with
  /// this data; otherwise the item is inert (matches legacy behavior where
  /// most round items had no `onTap`).
  final ExerciseDetailData? exerciseDetail;
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
  });

  final String headerTitle;
  final String heroImage;
  final String heroLabel;
  final String time;
  final String calories;
  final String levelLabel;
  final List<RoundGroup> rounds;

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
      time: '${json['durationMinutes'] ?? '—'} Minutes',
      calories: '${json['estimatedCalories'] ?? '—'} Kcal',
      levelLabel: _difficultyLabels[difficulty] ?? 'Beginner',
      rounds: [RoundGroup(title: 'Exercises', items: items)],
    );
  }

  static RoundExerciseItem _roundItemFromEntry(
    Map<String, dynamic> entry,
    int index,
  ) {
    final exercise = entry['exercise'] as Map<String, dynamic>;
    final name = (exercise['name'] as String?) ?? '';
    final sets = (entry['sets'] as num?) ?? (exercise['defaultSets'] as num?) ?? 3;
    final reps = (entry['reps'] as num?) ?? (exercise['defaultReps'] as num?) ?? 12;
    final image = (exercise['imageUrl'] as String?) ?? 'assets/workout.png';

    return RoundExerciseItem(
      name: name,
      time: '$sets sets',
      reps: '${reps}x Reps',
      accent: _accents[index % _accents.length],
      exerciseDetail: ExerciseDetailData(
        headerTitle: name,
        heroImage: image,
        title: name,
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
