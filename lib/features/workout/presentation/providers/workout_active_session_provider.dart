import 'package:nabvera/features/profile/data/user_repository.dart';
import 'package:nabvera/features/profile/presentation/providers/profile_controller.dart';
import 'package:nabvera/features/workout/domain/workout_progress_entry.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'workout_active_session_provider.g.dart';

/// The Workout tab's "continue where you left off" state — sourced from
/// `CurrentUserProfile.activeWorkoutSession` (backend-persisted, syncs
/// across devices), not local storage. Optimistic updates mirror
/// `WorkoutListByLevel.toggleFavorite`: apply locally first, sync in the
/// background, revert on failure.
@riverpod
class WorkoutActiveSession extends _$WorkoutActiveSession {
  @override
  WorkoutProgressEntry? build() => WorkoutProgressEntry.fromMap(
    ref.watch(currentUserProfileProvider).activeWorkoutSession,
  );

  Future<void> recordSets(WorkoutProgressEntry entry) async {
    final previous = state;
    state = entry;
    try {
      await ref
          .read(userRepositoryProvider)
          .setActiveWorkoutSession(
            workoutId: entry.workoutId,
            title: entry.title,
            titleAr: entry.titleAr,
            image: entry.image,
            completedSets: entry.completedSets,
            totalSets: entry.totalSets,
          );
      ref.invalidate(currentUserProfileProvider);
    } catch (_) {
      state = previous;
    }
  }

  Future<void> clear() async {
    final previous = state;
    state = null;
    try {
      await ref.read(userRepositoryProvider).clearActiveWorkoutSession();
      ref.invalidate(currentUserProfileProvider);
    } catch (_) {
      state = previous;
    }
  }
}
