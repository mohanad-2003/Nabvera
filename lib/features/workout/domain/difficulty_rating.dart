/// How a completed workout felt — collected right after finishing via
/// [WorkoutRatingSheet], stored on the backend's `WorkoutLog.difficultyRating`.
/// Feeds the Phase 2 recommendation engine (not implemented in this batch).
enum DifficultyRating { tooEasy, appropriate, hard, tooHard }

extension DifficultyRatingApi on DifficultyRating {
  /// The exact string the backend's `WorkoutLog.difficultyRating` enum
  /// expects.
  String get apiValue => switch (this) {
    DifficultyRating.tooEasy => 'too_easy',
    DifficultyRating.appropriate => 'appropriate',
    DifficultyRating.hard => 'hard',
    DifficultyRating.tooHard => 'too_hard',
  };
}

/// Parses a backend `difficultyRating` value back into the enum — `null`
/// for a missing/unrecognized value (a log the user skipped rating, or one
/// from before this field existed).
DifficultyRating? difficultyRatingFromApi(String? value) => switch (value) {
  'too_easy' => DifficultyRating.tooEasy,
  'appropriate' => DifficultyRating.appropriate,
  'hard' => DifficultyRating.hard,
  'too_hard' => DifficultyRating.tooHard,
  _ => null,
};
