import 'package:nabvera/features/nutrition/data/nutrition_repository.dart';
import 'package:nabvera/features/nutrition/domain/nutrition_models.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'nutrition_controller.g.dart';

enum NutritionTab { mealPlans, mealIdeas }

@riverpod
class NutritionTabController extends _$NutritionTabController {
  @override
  NutritionTab build() => NutritionTab.mealPlans;

  void select(NutritionTab tab) => state = tab;
}

/// Loads `/api/recipes` once, sorted by rating desc — the shared source
/// behind both "Recommended" (top 2) and "Recipes for you" (the rest) on
/// [NutritionPage]. Public (rather than a private provider) so the page's
/// pull-to-refresh can call [refresh] directly. A plain state-holding
/// notifier (not an `AsyncNotifier`) on purpose — same pattern as
/// [SuggestedChallenges]/[MyChallenges]: a failed [refresh] leaves the
/// last successfully-loaded list in `state` untouched (never resets to
/// empty) while still rethrowing so the caller can show a real error.
@riverpod
class NutritionRecipesSource extends _$NutritionRecipesSource {
  @override
  List<Map<String, dynamic>> build() {
    Future.microtask(() async {
      try {
        await refresh();
      } catch (_) {
        // Initial load failure — left at the empty default, see
        // WorkoutListByLevel for the same pattern.
      }
    });
    return const [];
  }

  /// Used by [NutritionPage]'s pull-to-refresh. Awaits the real fetch so
  /// the `RefreshIndicator` spinner stays up until real data has come
  /// back, and rethrows on failure (after leaving `state` as it was) so
  /// the caller can surface a real, retriable error instead of pretending
  /// the refresh succeeded.
  Future<void> refresh() async {
    final recipes = await ref.read(nutritionRepositoryProvider).fetchRecipes();
    state = recipes..sort(
      (a, b) =>
          ((b['rating'] as num?) ?? 0).compareTo((a['rating'] as num?) ?? 0),
    );
  }
}

/// Loads `/api/recipes` once and splits it: the two highest-rated recipes
/// become "Recommended", the rest fill "Recipes for you".
@riverpod
class NutritionRecommended extends _$NutritionRecommended {
  @override
  List<MealItem> build() {
    final recipes = ref.watch(nutritionRecipesSourceProvider);
    return recipes.take(2).map(MealItem.fromJson).toList();
  }
}

@riverpod
class NutritionRecipes extends _$NutritionRecipes {
  @override
  List<MealItem> build() {
    final recipes = ref.watch(nutritionRecipesSourceProvider);
    return recipes.skip(2).map(MealItem.fromJson).toList();
  }
}

/// Loads the real `/api/nutrition/today` document and converts it into
/// display fractions/strings.
@riverpod
class DailyNutritionSummaryController
    extends _$DailyNutritionSummaryController {
  @override
  DailyNutritionSummary build() {
    Future.microtask(_load);
    // isLoading: true — the summary card shows a real loading state with
    // this, not these zeros treated as an actual (mis)reading.
    return const DailyNutritionSummary(
      consumedCalories: 0,
      goalCalories: 2000,
      proteinFraction: 0,
      carbsFraction: 0,
      fatFraction: 0,
      waterIntake: '0 / 8 cups',
      isLoading: true,
    );
  }

  Future<void> _load() async {
    try {
      final entry = await ref.read(nutritionRepositoryProvider).fetchToday();
      // This provider is autoDispose — the widget watching it (e.g. the
      // Nutrition page) can unmount, tearing this down, while the request
      // above is still in flight. Writing to `state` after that throws
      // UnmountedRefException; `ref.mounted` after every async gap is the
      // documented guard for exactly this race.
      if (!ref.mounted) return;
      state = DailyNutritionSummary.fromEntry(entry);
    } catch (_) {
      if (!ref.mounted) return;
      // Stop showing the loading state even on failure — see
      // WorkoutListByLevel for the same "left at a safe placeholder"
      // pattern, just no longer flagged as still-loading.
      state = state.copyWith(isLoading: false);
    }
  }

  /// Used by Home's `refreshHomeProviders` — the "next step" card reads
  /// today's water/calorie progress from this controller too.
  Future<void> refresh() => _load();

  /// Logs an actual amount of water via `POST /nutrition/water` and
  /// updates every screen watching this controller immediately (Home's
  /// next-step card, the Nutrition summary card) — no restart, no
  /// separate refetch. Errors propagate to the caller so the water-log
  /// sheet can show a real failure message instead of silently doing
  /// nothing.
  Future<void> logWater(int amountMl) async {
    final entry = await ref.read(nutritionRepositoryProvider).logWater(amountMl);
    // Same autoDispose race as _load() above — the log-water sheet can
    // close (unmounting this) right as the request resolves.
    if (!ref.mounted) return;
    state = DailyNutritionSummary.fromEntry(entry);
  }
}
