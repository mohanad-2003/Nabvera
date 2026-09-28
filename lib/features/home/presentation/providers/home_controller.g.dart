// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'home_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// The four fixed nav tiles — see [HomeCategory]'s doc comment for why
/// these stay a plain list instead of a backend-fetched one.

@ProviderFor(homeCategories)
final homeCategoriesProvider = HomeCategoriesProvider._();

/// The four fixed nav tiles — see [HomeCategory]'s doc comment for why
/// these stay a plain list instead of a backend-fetched one.

final class HomeCategoriesProvider
    extends
        $FunctionalProvider<
          List<HomeCategory>,
          List<HomeCategory>,
          List<HomeCategory>
        >
    with $Provider<List<HomeCategory>> {
  /// The four fixed nav tiles — see [HomeCategory]'s doc comment for why
  /// these stay a plain list instead of a backend-fetched one.
  HomeCategoriesProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'homeCategoriesProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$homeCategoriesHash();

  @$internal
  @override
  $ProviderElement<List<HomeCategory>> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  List<HomeCategory> create(Ref ref) {
    return homeCategories(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(List<HomeCategory> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<List<HomeCategory>>(value),
    );
  }
}

String _$homeCategoriesHash() => r'9d9f326784533e4095908db8918d04552d53ce0a';

/// Loads a few popular workouts from `/api/workouts?popular=true` for the
/// "Recommended" row.

@ProviderFor(HomeRecommendations)
final homeRecommendationsProvider = HomeRecommendationsProvider._();

/// Loads a few popular workouts from `/api/workouts?popular=true` for the
/// "Recommended" row.
final class HomeRecommendationsProvider
    extends
        $NotifierProvider<
          HomeRecommendations,
          HomeSectionState<RecommendedWorkout>
        > {
  /// Loads a few popular workouts from `/api/workouts?popular=true` for the
  /// "Recommended" row.
  HomeRecommendationsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'homeRecommendationsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$homeRecommendationsHash();

  @$internal
  @override
  HomeRecommendations create() => HomeRecommendations();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(HomeSectionState<RecommendedWorkout> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride:
          $SyncValueProvider<HomeSectionState<RecommendedWorkout>>(value),
    );
  }
}

String _$homeRecommendationsHash() =>
    r'553561ef9a791bf10f302e29c187c38499e7eee2';

/// Loads a few popular workouts from `/api/workouts?popular=true` for the
/// "Recommended" row.

abstract class _$HomeRecommendations
    extends $Notifier<HomeSectionState<RecommendedWorkout>> {
  HomeSectionState<RecommendedWorkout> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref =
        this.ref
            as $Ref<
              HomeSectionState<RecommendedWorkout>,
              HomeSectionState<RecommendedWorkout>
            >;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                HomeSectionState<RecommendedWorkout>,
                HomeSectionState<RecommendedWorkout>
              >,
              HomeSectionState<RecommendedWorkout>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

/// Loads `/api/articles` for the "Articles & Tips" row.

@ProviderFor(HomeArticles)
final homeArticlesProvider = HomeArticlesProvider._();

/// Loads `/api/articles` for the "Articles & Tips" row.
final class HomeArticlesProvider
    extends $NotifierProvider<HomeArticles, HomeSectionState<ArticleTip>> {
  /// Loads `/api/articles` for the "Articles & Tips" row.
  HomeArticlesProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'homeArticlesProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$homeArticlesHash();

  @$internal
  @override
  HomeArticles create() => HomeArticles();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(HomeSectionState<ArticleTip> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<HomeSectionState<ArticleTip>>(value),
    );
  }
}

String _$homeArticlesHash() => r'f692ded42e06d8f9c2a80ea24fc0706f34d404ad';

/// Loads `/api/articles` for the "Articles & Tips" row.

abstract class _$HomeArticles extends $Notifier<HomeSectionState<ArticleTip>> {
  HomeSectionState<ArticleTip> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref =
        this.ref
            as $Ref<HomeSectionState<ArticleTip>, HomeSectionState<ArticleTip>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                HomeSectionState<ArticleTip>,
                HomeSectionState<ArticleTip>
              >,
              HomeSectionState<ArticleTip>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
