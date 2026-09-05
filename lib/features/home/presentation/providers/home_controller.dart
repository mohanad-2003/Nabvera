import 'package:nabvera/core/network/app_icons.dart';
import 'package:nabvera/features/home/data/home_repository.dart';
import 'package:nabvera/features/home/domain/home_models.dart';
import 'package:nabvera/features/workout/data/workout_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'home_controller.g.dart';

/// The four fixed nav tiles — see [HomeCategory]'s doc comment for why
/// these stay a plain list instead of a backend-fetched one.
@riverpod
List<HomeCategory> homeCategories(Ref ref) => [
  HomeCategory(image: AppIcons.workout, name: 'Workout'),
  HomeCategory(image: AppIcons.progress, name: 'Progress\nTracking'),
  HomeCategory(image: AppIcons.nutrition, name: 'Nutrition'),
  HomeCategory(image: AppIcons.community, name: 'Community'),
];

enum HomeLoadStatus { loading, loaded, error }

/// Wraps a home-screen list section with its fetch status so the UI can
/// render a skeleton while [HomeLoadStatus.loading], a friendly message
/// with a retry action on [HomeLoadStatus.error], and the real list once
/// [HomeLoadStatus.loaded] — plain empty lists alone can't tell those three
/// states apart.
class HomeSectionState<T> {
  const HomeSectionState({required this.status, required this.items});

  const HomeSectionState.loading() : this(status: HomeLoadStatus.loading, items: const []);

  final HomeLoadStatus status;
  final List<T> items;
}

/// Loads a few popular workouts from `/api/workouts?popular=true` for the
/// "Recommended" row.
@riverpod
class HomeRecommendations extends _$HomeRecommendations {
  @override
  HomeSectionState<RecommendedWorkout> build() {
    Future.microtask(_load);
    return const HomeSectionState.loading();
  }

  Future<void> reload() => _load();

  Future<void> _load() async {
    state = const HomeSectionState.loading();
    try {
      final repo = ref.read(workoutRepositoryProvider);
      var docs = await repo.fetchWorkouts(popular: true);
      if (docs.isEmpty) docs = await repo.fetchWorkouts();
      state = HomeSectionState(
        status: HomeLoadStatus.loaded,
        items: docs.take(6).map(RecommendedWorkout.fromJson).toList(),
      );
    } catch (_) {
      state = const HomeSectionState(status: HomeLoadStatus.error, items: []);
    }
  }
}

/// Loads `/api/articles` for the "Articles & Tips" row.
@riverpod
class HomeArticles extends _$HomeArticles {
  @override
  HomeSectionState<ArticleTip> build() {
    Future.microtask(_load);
    return const HomeSectionState.loading();
  }

  Future<void> reload() => _load();

  Future<void> _load() async {
    state = const HomeSectionState.loading();
    try {
      final docs = await ref.read(homeRepositoryProvider).fetchArticles();
      state = HomeSectionState(
        status: HomeLoadStatus.loaded,
        items: docs.map(ArticleTip.fromJson).toList(),
      );
    } catch (_) {
      state = const HomeSectionState(status: HomeLoadStatus.error, items: []);
    }
  }
}
