import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../data/nutrition_repository.dart';
import '../../domain/nutrition_models.dart';

part 'meal_breakfast_controller.g.dart';

/// Loads `/api/recipes?category=breakfast`. `isFavorite` has no backend
/// equivalent for this simplified option list (see [MealIdeaFavorites] for
/// the real favorites toggle used by the recipe detail flow) — it stays a
/// local-only UI toggle here.
@riverpod
class MealBreakfastController extends _$MealBreakfastController {
  @override
  List<BreakfastOption> build() {
    Future.microtask(_load);
    return const [];
  }

  Future<void> _load() async {
    try {
      final docs = await ref
          .read(nutritionRepositoryProvider)
          .fetchRecipes(category: 'breakfast');
      state = [
        for (final doc in docs)
          BreakfastOption(
            name: (doc['title'] as String?) ?? '',
            time: '${doc['prepTimeMinutes'] ?? '—'} Minutes',
            calories: '${(doc['nutrition'] as Map?)?['calories'] ?? '—'} Cal',
            image: (doc['imageUrl'] as String?) ?? 'assets/workout.png',
            ingredients: [
              for (final i in (doc['ingredients'] as List? ?? const []))
                '${i['amount'] ?? ''} ${i['name'] ?? ''}'.trim(),
            ],
            preparation: [
              for (final s in (doc['steps'] as List? ?? const []))
                (s['instruction'] as String?) ?? '',
            ],
          ),
      ];
    } catch (_) {
      // Left empty — see WorkoutListByLevel for the same pattern.
    }
  }

  void toggleFavorite(int index) {
    state = [
      for (var i = 0; i < state.length; i++)
        if (i == index)
          state[i].copyWith(isFavorite: !state[i].isFavorite)
        else
          state[i],
    ];
  }
}

@riverpod
class SelectedBreakfastIndex extends _$SelectedBreakfastIndex {
  @override
  int build() => -1;

  void select(int index) => state = index;
}
