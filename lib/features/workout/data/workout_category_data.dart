import 'package:nabvera/core/theme/app_colors.dart';
import 'package:nabvera/features/workout/domain/exercise_detail_models.dart';
import 'package:nabvera/features/workout/domain/workout_models.dart';

/// Static category/round content mirroring the legacy hardcoded values from
/// AdvanceCategory, IntermediateCategory, and FunctionalPage. Kept as a
/// small lookup table (not user data) so [CategoryDetailPage] can render
/// any of the three from one implementation.
abstract final class WorkoutCategoryData {
  static const _squat = ExerciseDetailData(
    headerTitle: 'Beginner',
    heroImage: 'assets/beg_gym.png',
    title: 'Squats',
  );

  static const _kettlebell = ExerciseDetailData(
    headerTitle: 'Intermediate',
    heroImage: 'assets/kett.png',
    title: 'Kettlebell swing',
  );

  static const _inclineBenchSitUp = ExerciseDetailData(
    headerTitle: 'Advance',
    heroImage: 'assets/incline.png',
    title: 'Incline Bench Sit up',
  );

  static const functional = CategoryDetailData(
    headerTitle: 'Beginner',
    heroImage: 'assets/woman.png',
    heroLabel: 'Functional Training',
    time: '45 Minutes',
    calories: '1450 Kcal',
    levelLabel: 'Beginner',
    rounds: [
      RoundGroup(
        title: 'Round 1',
        items: [
          RoundExerciseItem(
            name: 'Dumbbell Rows',
            time: '00:30',
            reps: '3x Reps',
            accent: AppColors.seedViolet,
          ),
          RoundExerciseItem(
            name: 'Russian Twists',
            time: '00:15',
            reps: '2x Reps',
            accent: AppColors.seedLime,
          ),
          RoundExerciseItem(
            name: 'Squats',
            time: '00:30',
            reps: '3x Reps',
            accent: AppColors.seedLime,
            exerciseDetail: _squat,
          ),
        ],
      ),
      RoundGroup(
        title: 'Round 2',
        items: [
          RoundExerciseItem(
            name: 'Tabata Intervals',
            time: '00:10',
            reps: '2x Reps',
            accent: AppColors.seedViolet,
          ),
          RoundExerciseItem(
            name: 'Bicycle Crunches',
            time: '00:10',
            reps: '4x Reps',
            accent: AppColors.seedViolet,
          ),
        ],
      ),
    ],
  );

  static const intermediate = CategoryDetailData(
    headerTitle: 'Intermediate',
    heroImage: 'assets/cardio.png',
    heroLabel: 'Cardio Fitness',
    time: '45 Minutes',
    calories: '120 Kcal',
    levelLabel: 'Intermediate',
    rounds: [
      RoundGroup(
        title: 'Round 1',
        items: [
          RoundExerciseItem(
            name: 'Kettlebell swing',
            time: '00:30',
            reps: '3x Reps',
            accent: AppColors.seedLime,
            exerciseDetail: _kettlebell,
          ),
          RoundExerciseItem(
            name: 'Shoulder Press',
            time: '00:15',
            reps: '2x Reps',
            accent: AppColors.seedLime,
          ),
          RoundExerciseItem(
            name: 'Hamstring Curls',
            time: '00:30',
            reps: '3x Reps',
            accent: AppColors.seedViolet,
          ),
        ],
      ),
      RoundGroup(
        title: 'Round 2',
        items: [
          RoundExerciseItem(
            name: 'Bicep Curls',
            time: '00:10',
            reps: '2x Reps',
            accent: AppColors.seedViolet,
          ),
          RoundExerciseItem(
            name: 'Barbell deadlift',
            time: '00:10',
            reps: '4x Reps',
            accent: AppColors.seedViolet,
          ),
        ],
      ),
    ],
  );

  static const advanced = CategoryDetailData(
    headerTitle: 'Advance',
    heroImage: 'assets/advance.png',
    heroLabel: 'Upper Body Strength',
    time: '60 Minutes',
    calories: '1450 Kcal',
    levelLabel: 'Advanced',
    rounds: [
      RoundGroup(
        title: 'Round 1',
        items: [
          RoundExerciseItem(
            name: 'Barbell Bench Press',
            time: '00:30',
            reps: '3x Reps',
            accent: AppColors.seedViolet,
          ),
          RoundExerciseItem(
            name: 'Tricep Dips',
            time: '00:15',
            reps: '2x Reps',
            accent: AppColors.seedViolet,
          ),
          RoundExerciseItem(
            name: 'Incline Bench Sit-up',
            time: '00:30',
            reps: '3x Reps',
            accent: AppColors.seedLime,
            exerciseDetail: _inclineBenchSitUp,
          ),
        ],
      ),
      RoundGroup(
        title: 'Round 2',
        items: [
          RoundExerciseItem(
            name: 'Romanian Deadlifts',
            time: '00:10',
            reps: '2x Reps',
            accent: AppColors.seedViolet,
          ),
          RoundExerciseItem(
            name: 'Foam Rolling',
            time: '00:10',
            reps: '4x Reps',
            accent: AppColors.seedViolet,
          ),
        ],
      ),
    ],
  );

  static CategoryDetailData forLevel(WorkoutLevel level) => switch (level) {
    WorkoutLevel.beginner => functional,
    WorkoutLevel.intermediate => intermediate,
    WorkoutLevel.advanced => advanced,
  };

  static const _headerImages = {
    WorkoutLevel.beginner: 'assets/woman.png',
    WorkoutLevel.intermediate: 'assets/cardio.png',
    WorkoutLevel.advanced: 'assets/advance.png',
  };

  static const _headerTitles = {
    WorkoutLevel.beginner: (
      'functional training',
      "Let's Go Beginner",
      'Explore Different Workout Styles',
      '45 Minutes',
      '1450 Kcal',
    ),
    WorkoutLevel.intermediate: (
      'cardio fitness',
      'Keep raising your level',
      'Explore Intermediate Workouts',
      '45 Minutes',
      '120 Kcal',
    ),
    WorkoutLevel.advanced: (
      'Upper Body Strength',
      'Unlock Your Potential',
      'Explore Advanced Fitness Routines',
      '60 Minutes',
      '120 Kcal',
    ),
  };

  static String heroImage(WorkoutLevel level) => _headerImages[level]!;

  static (
    String badge,
    String headline,
    String subHeadline,
    String time,
    String calories,
  )
  heroCopy(WorkoutLevel level) => _headerTitles[level]!;
}
