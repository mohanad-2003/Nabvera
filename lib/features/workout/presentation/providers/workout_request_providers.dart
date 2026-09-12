import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nabvera/features/workout/data/workout_repository.dart';
import 'package:nabvera/features/workout/domain/workout_models.dart';

/// Key for [workoutRequestProvider] — [category] is the raw backend value
/// (`strength`/`cardio`/`yoga`/`hiit`/`stretching`/`full_body`), or `null`
/// for "All" (see `WorkoutCategoryFilter`).
typedef WorkoutListRequest = ({WorkoutLevel level, String? category});

// Share each request with the existing controllers so loading/error UI does
// not issue a second request or change the repository's contract.
final workoutRequestProvider = FutureProvider.autoDispose
    .family<List<Map<String, dynamic>>, WorkoutListRequest>((ref, request) {
      return ref
          .watch(workoutRepositoryProvider)
          .fetchWorkouts(
            difficulty: request.level.name,
            category: request.category,
          );
    });

final exerciseLibraryRequestProvider =
    FutureProvider.autoDispose<List<Map<String, dynamic>>>((ref) {
      return ref.watch(workoutRepositoryProvider).fetchExercises();
    });

final routinesRequestProvider =
    FutureProvider.autoDispose<List<Map<String, dynamic>>>((ref) {
      return ref.watch(workoutRepositoryProvider).fetchRoutines();
    });
