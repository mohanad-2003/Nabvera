import 'dart:async';

import 'package:nabvera/features/nutrition/data/nutrition_repository.dart';
import 'package:nabvera/features/search/domain/search_models.dart';
import 'package:nabvera/features/workout/data/workout_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'search_controller.g.dart';

enum SearchTab { all, workoutSuggestions, nutritionSuggestions }

@riverpod
class SearchTabController extends _$SearchTabController {
  @override
  SearchTab build() => SearchTab.all;

  void select(SearchTab tab) => state = tab;
}

/// Two popular workouts shown above the results regardless of the current
/// query — a "you might like" strip, same idea as Home's recommendations.
@riverpod
class SearchFeaturedWorkouts extends _$SearchFeaturedWorkouts {
  @override
  List<SearchResultItem> build() {
    Future.microtask(_load);
    return const [];
  }

  Future<void> _load() async {
    try {
      final repo = ref.read(workoutRepositoryProvider);
      var docs = await repo.fetchWorkouts(popular: true);
      if (docs.isEmpty) docs = await repo.fetchWorkouts();
      state = docs.take(2).map(_workoutToResult).toList();
    } catch (_) {
      // Left empty — see WorkoutListByLevel for the same pattern.
    }
  }
}

SearchResultItem _workoutToResult(Map<String, dynamic> doc) {
  final exerciseCount = (doc['exercises'] as List?)?.length ?? 0;
  return SearchResultItem(
    id: (doc['_id'] as String?) ?? '',
    image: (doc['coverImageUrl'] as String?) ?? 'assets/workout.png',
    name: (doc['title'] as String?) ?? '',
    time: '${doc['durationMinutes'] ?? '—'} Minutes',
    calories: '${doc['estimatedCalories'] ?? '—'} Kcal',
    type: SearchResultType.workout,
    exercises: exerciseCount == 0 ? null : '$exerciseCount exercises',
  );
}

SearchResultItem _recipeToResult(Map<String, dynamic> doc) {
  final nutrition = doc['nutrition'] as Map<String, dynamic>? ?? const {};
  return SearchResultItem(
    id: (doc['_id'] as String?) ?? '',
    image: (doc['imageUrl'] as String?) ?? 'assets/workout.png',
    name: (doc['title'] as String?) ?? '',
    time: '${doc['prepTimeMinutes'] ?? '—'} Minutes',
    calories: '${nutrition['calories'] ?? '—'} Cal',
    type: SearchResultType.nutrition,
  );
}

/// The search box's live text — a plain [TextEditingController] the query
/// provider watches indirectly via [SearchQueryController.submit].
@riverpod
class SearchQueryController extends _$SearchQueryController {
  @override
  String build() => '';

  void update(String value) => state = value;
}

/// Debounced live search across `/api/workouts?search=` and
/// `/api/recipes?search=` — empty query means empty results (nothing
/// fabricated to fill the screen before the user types). Tracks
/// `isLoading`/`hasSearched` too (see [SearchResults]'s doc comment) so
/// the "no results" message only ever appears for a search that actually
/// ran and came back empty, never for the fresh, nothing-typed-yet state.
@riverpod
class SearchAllResults extends _$SearchAllResults {
  Timer? _debounce;

  @override
  SearchResults build() {
    final query = ref.watch(searchQueryControllerProvider).trim();
    ref.onDispose(() => _debounce?.cancel());

    if (query.isEmpty) return const SearchResults();

    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 400), () => _search(query));
    return state.copyWith(isLoading: true);
  }

  Future<void> _search(String query) async {
    try {
      final results = await Future.wait([
        ref.read(workoutRepositoryProvider).fetchWorkouts(),
        ref.read(nutritionRepositoryProvider).fetchRecipes(),
      ]);
      // The backend's `search` query param does a case-insensitive title
      // match server-side; filtering again client-side here would just
      // duplicate that, so instead this fetches the small demo catalog
      // and filters locally — swap for `search: query` once the catalog
      // is large enough that fetching everything stops being cheap.
      final lower = query.toLowerCase();
      final workouts =
          (results[0])
              .where((w) => (w['title'] as String? ?? '').toLowerCase().contains(lower))
              .map(_workoutToResult);
      final recipes =
          (results[1])
              .where((r) => (r['title'] as String? ?? '').toLowerCase().contains(lower))
              .map(_recipeToResult);
      state = SearchResults(
        items: [...workouts, ...recipes],
        hasSearched: true,
      );
    } catch (_) {
      // Left at the previous items — see WorkoutListByLevel for the same
      // pattern — but still marked as having searched, and no longer
      // loading, so the UI doesn't spin forever.
      state = state.copyWith(isLoading: false, hasSearched: true);
    }
  }
}
