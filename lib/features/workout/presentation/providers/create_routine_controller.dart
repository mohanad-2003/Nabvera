import 'package:fitness_app/features/workout/data/workout_repository.dart';
import 'package:fitness_app/features/workout/domain/workout_models.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'create_routine_controller.g.dart';

@riverpod
class CreateRoutineController extends _$CreateRoutineController {
  @override
  CreateRoutineState build() {
    Future.microtask(_loadLibrary);
    return const CreateRoutineState(library: []);
  }

  Future<void> _loadLibrary() async {
    try {
      final docs = await ref.read(workoutRepositoryProvider).fetchExercises();
      state = state.copyWith(
        library: [for (final doc in docs) RoutineExercise.fromJson(doc)],
      );
    } catch (_) {
      // Left empty — the picker just shows nothing to choose from rather
      // than crashing when the backend is unreachable.
    }
  }

  void setName(String name) => state = state.copyWith(name: name);

  void setGoal(RoutineGoal goal) => state = state.copyWith(goal: goal);

  void setDifficulty(WorkoutLevel difficulty) =>
      state = state.copyWith(difficulty: difficulty);

  void toggleDay(Weekday day) {
    final days = {...state.selectedDays};
    if (!days.add(day)) days.remove(day);
    state = state.copyWith(selectedDays: days);
  }

  void toggleFavorite(String exerciseId) {
    state = state.copyWith(
      library: [
        for (final e in state.library)
          if (e.id == exerciseId) e.copyWith(isFavorite: !e.isFavorite) else e,
      ],
    );
  }

  bool isSelected(String exerciseId) =>
      state.selected.any((s) => s.exerciseId == exerciseId);

  void toggleExercise(String exerciseId) {
    if (isSelected(exerciseId)) {
      removeExercise(exerciseId);
      return;
    }
    final entry = state.library.firstWhere((e) => e.id == exerciseId);
    state = state.copyWith(
      selected: [
        ...state.selected,
        SelectedExercise(
          exerciseId: exerciseId,
          sets: entry.defaultSets,
          reps: entry.defaultReps,
        ),
      ],
    );
  }

  void removeExercise(String exerciseId) {
    state = state.copyWith(
      selected:
          state.selected.where((s) => s.exerciseId != exerciseId).toList(),
    );
  }

  void updateSets(String exerciseId, int delta) {
    state = state.copyWith(
      selected: [
        for (final s in state.selected)
          if (s.exerciseId == exerciseId)
            s.copyWith(sets: (s.sets + delta).clamp(1, 10))
          else
            s,
      ],
    );
  }

  void updateReps(String exerciseId, int delta) {
    state = state.copyWith(
      selected: [
        for (final s in state.selected)
          if (s.exerciseId == exerciseId)
            s.copyWith(reps: (s.reps + delta).clamp(1, 50))
          else
            s,
      ],
    );
  }

  /// [newIndex] is pre-adjusted by [SliverReorderableList.onReorderItem] for
  /// the removed item at [oldIndex] — insert directly, no offset needed.
  void reorder(int oldIndex, int newIndex) {
    final selected = [...state.selected];
    final item = selected.removeAt(oldIndex);
    selected.insert(newIndex, item);
    state = state.copyWith(selected: selected);
  }

  /// Submits the routine to `POST /api/routines`. Throws on failure — the
  /// page decides how to surface that (see CreateRoutinePage._handleCreate).
  Future<void> create(String name) async {
    final payload = <String, dynamic>{
      'name': name,
      if (state.goal != null) 'goal': _goalToApi(state.goal!),
      if (state.difficulty != null) 'difficulty': state.difficulty!.name,
      'weeklySchedule': [
        for (final day in state.selectedDays) _weekdayToApi(day),
      ],
      'exercises': [
        for (var i = 0; i < state.selected.length; i++)
          {
            'exercise': state.selected[i].exerciseId,
            'sets': state.selected[i].sets,
            'reps': state.selected[i].reps,
            'order': i,
          },
      ],
    };
    await ref.read(workoutRepositoryProvider).createRoutine(payload);
  }

  static String _goalToApi(RoutineGoal goal) => switch (goal) {
    RoutineGoal.muscleGain => 'gain_muscle',
    RoutineGoal.fatLoss => 'lose_weight',
    RoutineGoal.strength => 'keep_fit',
    RoutineGoal.endurance => 'endurance',
  };

  static String _weekdayToApi(Weekday day) => switch (day) {
    Weekday.monday => 'mon',
    Weekday.tuesday => 'tue',
    Weekday.wednesday => 'wed',
    Weekday.thursday => 'thu',
    Weekday.friday => 'fri',
    Weekday.saturday => 'sat',
    Weekday.sunday => 'sun',
  };
}
