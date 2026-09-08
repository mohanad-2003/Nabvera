import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nabvera/features/workout/data/workout_repository.dart';
import 'package:nabvera/features/workout/domain/workout_models.dart';

// Share each request with the existing controllers so loading/error UI does
// not issue a second request or change the repository's contract.
final workoutRequestProvider = FutureProvider.autoDispose
    .family<List<Map<String, dynamic>>, WorkoutLevel>((ref, level) {
      return ref
          .watch(workoutRepositoryProvider)
          .fetchWorkouts(difficulty: level.name);
    });

final exerciseLibraryRequestProvider =
    FutureProvider.autoDispose<List<Map<String, dynamic>>>((ref) {
      return ref.watch(workoutRepositoryProvider).fetchExercises();
    });

final routinesRequestProvider =
    FutureProvider.autoDispose<List<Map<String, dynamic>>>((ref) {
      return ref.watch(workoutRepositoryProvider).fetchRoutines();
    });
