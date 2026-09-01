/// Replaces the `Map<String, dynamic>`/`RxMap` items used throughout the
/// legacy workout controllers with typed, immutable value objects.
enum WorkoutLevel { beginner, intermediate, advanced }

/// Muscle-group filter used by the routine category chips. `all` is the
/// synthetic "show everything" chip, not a real muscle group.
enum MuscleGroup { all, chest, back, legs, arms, cardio, strength }

/// Maps the backend `Exercise.muscleGroup` enum (`chest`, `back`, `legs`,
/// `shoulders`, `arms`, `core`, `full_body`, `cardio`) onto the UI's
/// narrower [MuscleGroup] filter set — groups without a direct UI chip
/// (shoulders/core/full_body) fall back to `strength`.
MuscleGroup muscleGroupFromApi(String? value) => switch (value) {
  'chest' => MuscleGroup.chest,
  'back' => MuscleGroup.back,
  'legs' => MuscleGroup.legs,
  'arms' => MuscleGroup.arms,
  'cardio' => MuscleGroup.cardio,
  _ => MuscleGroup.strength,
};

/// Training goal selectable when building a custom routine.
enum RoutineGoal { muscleGain, fatLoss, strength, endurance }

/// Day of the week used by the routine's weekly day picker.
enum Weekday { monday, tuesday, wednesday, thursday, friday, saturday, sunday }

class WorkoutListItem {
  const WorkoutListItem({
    this.id = '',
    required this.image,
    required this.name,
    this.time,
    this.calories,
    this.exercises,
    this.isFavorite = false,
  });

  /// Backend `Workout._id` — empty for the few remaining pieces of curated
  /// (non-backend) content, e.g. home screen highlights.
  final String id;
  final String image;
  final String name;
  final String? time;
  final String? calories;
  final String? exercises;
  final bool isFavorite;

  WorkoutListItem copyWith({bool? isFavorite}) => WorkoutListItem(
    id: id,
    image: image,
    name: name,
    time: time,
    calories: calories,
    exercises: exercises,
    isFavorite: isFavorite ?? this.isFavorite,
  );

  /// Builds a display item from a `/api/workouts` JSON document — falls
  /// back to a generic local illustration since seeded/admin workouts
  /// rarely have a `coverImageUrl` set yet.
  factory WorkoutListItem.fromJson(
    Map<String, dynamic> json, {
    required bool isFavorite,
  }) {
    final exerciseCount = (json['exercises'] as List?)?.length ?? 0;
    return WorkoutListItem(
      id: json['_id'] as String? ?? '',
      image: (json['coverImageUrl'] as String?) ?? 'assets/workout.png',
      name: (json['title'] as String?) ?? '',
      time: '${json['durationMinutes'] ?? '—'} Minutes',
      calories: '${json['estimatedCalories'] ?? '—'} Kcal',
      exercises: exerciseCount == 0 ? null : '$exerciseCount exercises',
      isFavorite: isFavorite,
    );
  }
}

/// A catalog entry in the "Choose Exercises" library. [id] must be unique —
/// it's used to look the exercise up when it's added to [SelectedExercise].
class RoutineExercise {
  const RoutineExercise({
    required this.id,
    required this.image,
    required this.name,
    required this.muscleGroup,
    required this.time,
    this.defaultSets = 3,
    this.defaultReps = 12,
    this.isFavorite = false,
  });

  final String id;
  final String image;
  final String name;
  final MuscleGroup muscleGroup;
  final String time;
  final int defaultSets;
  final int defaultReps;
  final bool isFavorite;

  RoutineExercise copyWith({bool? isFavorite}) => RoutineExercise(
    id: id,
    image: image,
    name: name,
    muscleGroup: muscleGroup,
    time: time,
    defaultSets: defaultSets,
    defaultReps: defaultReps,
    isFavorite: isFavorite ?? this.isFavorite,
  );

  /// Builds a library entry from a `/api/exercises` JSON document.
  /// `isFavorite` has no backend equivalent (there's no per-exercise
  /// favorites endpoint) — it stays a local-only UI toggle.
  factory RoutineExercise.fromJson(Map<String, dynamic> json) {
    return RoutineExercise(
      id: json['_id'] as String? ?? '',
      image: (json['imageUrl'] as String?) ?? 'assets/workout.png',
      name: (json['name'] as String?) ?? '',
      muscleGroup: muscleGroupFromApi(json['muscleGroup'] as String?),
      time: '${json['defaultSets'] ?? 3} sets',
      defaultSets: json['defaultSets'] as int? ?? 3,
      defaultReps: json['defaultReps'] as int? ?? 12,
    );
  }
}

/// An exercise the user has added to "My Routine", with its own editable
/// sets/reps (independent of the library's [RoutineExercise.defaultSets]).
class SelectedExercise {
  const SelectedExercise({
    required this.exerciseId,
    required this.sets,
    required this.reps,
  });

  final String exerciseId;
  final int sets;
  final int reps;

  SelectedExercise copyWith({int? sets, int? reps}) => SelectedExercise(
    exerciseId: exerciseId,
    sets: sets ?? this.sets,
    reps: reps ?? this.reps,
  );
}

class RoutineItem {
  const RoutineItem({
    required this.image,
    required this.title,
    required this.time,
    required this.rep,
    this.muscleGroup = MuscleGroup.strength,
    this.isFavorite = false,
    this.videoUrl,
  });

  final String image;
  final String title;
  final String time;
  final String rep;
  final MuscleGroup muscleGroup;
  final bool isFavorite;

  /// From the backend's `Exercise.videoUrl` — null for exercises without one.
  final String? videoUrl;

  RoutineItem copyWith({bool? isFavorite}) => RoutineItem(
    image: image,
    title: title,
    time: time,
    rep: rep,
    muscleGroup: muscleGroup,
    isFavorite: isFavorite ?? this.isFavorite,
    videoUrl: videoUrl,
  );
}

class ActivityLogItem {
  const ActivityLogItem({
    required this.image,
    required this.name,
    required this.calories,
    required this.date,
    required this.duration,
  });

  final String image;
  final String name;
  final String calories;
  final String date;
  final String duration;
}

class PopularExerciseItem {
  const PopularExerciseItem({
    required this.image,
    required this.name,
    required this.time,
    required this.calories,
    this.difficulty = 'Easy',
    this.videoUrl,
  });

  final String image;
  final String name;
  final String time;
  final String calories;
  final String difficulty;

  /// From the backend's `Exercise.videoUrl` — null for exercises without one.
  final String? videoUrl;
}

class WeeklyRound {
  const WeeklyRound({
    required this.name,
    required this.time,
    required this.intensity,
  });

  final String name;
  final String time;
  final String intensity;
}

/// Full state of the "Create Routine" builder screen: the routine's own
/// metadata (name/goal/difficulty/days), the exercise catalog (with
/// favorite flags), and the ordered list of exercises the user has picked.
class CreateRoutineState {
  const CreateRoutineState({
    this.name = '',
    this.goal,
    this.difficulty,
    this.selectedDays = const {},
    required this.library,
    this.selected = const [],
  });

  final String name;
  final RoutineGoal? goal;
  final WorkoutLevel? difficulty;
  final Set<Weekday> selectedDays;
  final List<RoutineExercise> library;
  final List<SelectedExercise> selected;

  RoutineExercise libraryEntry(String exerciseId) =>
      library.firstWhere((e) => e.id == exerciseId);

  /// Parses the leading integer out of a "10 Minutes" style label; falls
  /// back to 10 if the library entry has no parseable time.
  int _minutesOf(RoutineExercise entry) =>
      int.tryParse(RegExp(r'^\d+').stringMatch(entry.time) ?? '') ?? 10;

  int get totalDurationMinutes => selected.fold(
    0,
    (sum, s) => sum + _minutesOf(libraryEntry(s.exerciseId)),
  );

  /// Rough estimate (≈7 kcal/min of resistance training) — display-only.
  int get estimatedCalories => totalDurationMinutes * 7;

  CreateRoutineState copyWith({
    String? name,
    RoutineGoal? goal,
    WorkoutLevel? difficulty,
    Set<Weekday>? selectedDays,
    List<RoutineExercise>? library,
    List<SelectedExercise>? selected,
  }) => CreateRoutineState(
    name: name ?? this.name,
    goal: goal ?? this.goal,
    difficulty: difficulty ?? this.difficulty,
    selectedDays: selectedDays ?? this.selectedDays,
    library: library ?? this.library,
    selected: selected ?? this.selected,
  );
}
