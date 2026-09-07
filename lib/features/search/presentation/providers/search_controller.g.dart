// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'search_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(SearchTabController)
final searchTabControllerProvider = SearchTabControllerProvider._();

final class SearchTabControllerProvider
    extends $NotifierProvider<SearchTabController, SearchTab> {
  SearchTabControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'searchTabControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$searchTabControllerHash();

  @$internal
  @override
  SearchTabController create() => SearchTabController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SearchTab value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SearchTab>(value),
    );
  }
}

String _$searchTabControllerHash() =>
    r'1abb06eb5d90277ee42222d551a98e6dfc7578de';

abstract class _$SearchTabController extends $Notifier<SearchTab> {
  SearchTab build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<SearchTab, SearchTab>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<SearchTab, SearchTab>,
              SearchTab,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

/// Two popular workouts shown above the results regardless of the current
/// query — a "you might like" strip, same idea as Home's recommendations.

@ProviderFor(SearchFeaturedWorkouts)
final searchFeaturedWorkoutsProvider = SearchFeaturedWorkoutsProvider._();

/// Two popular workouts shown above the results regardless of the current
/// query — a "you might like" strip, same idea as Home's recommendations.
final class SearchFeaturedWorkoutsProvider
    extends $NotifierProvider<SearchFeaturedWorkouts, List<SearchResultItem>> {
  /// Two popular workouts shown above the results regardless of the current
  /// query — a "you might like" strip, same idea as Home's recommendations.
  SearchFeaturedWorkoutsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'searchFeaturedWorkoutsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$searchFeaturedWorkoutsHash();

  @$internal
  @override
  SearchFeaturedWorkouts create() => SearchFeaturedWorkouts();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(List<SearchResultItem> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<List<SearchResultItem>>(value),
    );
  }
}

String _$searchFeaturedWorkoutsHash() =>
    r'3b4ef119c2092ba2915f96e01e53def5379ab8a3';

/// Two popular workouts shown above the results regardless of the current
/// query — a "you might like" strip, same idea as Home's recommendations.

abstract class _$SearchFeaturedWorkouts
    extends $Notifier<List<SearchResultItem>> {
  List<SearchResultItem> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref =
        this.ref as $Ref<List<SearchResultItem>, List<SearchResultItem>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<List<SearchResultItem>, List<SearchResultItem>>,
              List<SearchResultItem>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

/// The search box's live text — a plain [TextEditingController] the query
/// provider watches indirectly via [SearchQueryController.submit].

@ProviderFor(SearchQueryController)
final searchQueryControllerProvider = SearchQueryControllerProvider._();

/// The search box's live text — a plain [TextEditingController] the query
/// provider watches indirectly via [SearchQueryController.submit].
final class SearchQueryControllerProvider
    extends $NotifierProvider<SearchQueryController, String> {
  /// The search box's live text — a plain [TextEditingController] the query
  /// provider watches indirectly via [SearchQueryController.submit].
  SearchQueryControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'searchQueryControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$searchQueryControllerHash();

  @$internal
  @override
  SearchQueryController create() => SearchQueryController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<String>(value),
    );
  }
}

String _$searchQueryControllerHash() =>
    r'0b773bb3a59505866bd8ab578a70c607dd07e999';

/// The search box's live text — a plain [TextEditingController] the query
/// provider watches indirectly via [SearchQueryController.submit].

abstract class _$SearchQueryController extends $Notifier<String> {
  String build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<String, String>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<String, String>,
              String,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

/// Debounced live search across `/api/workouts?search=` and
/// `/api/recipes?search=` — empty query means empty results (nothing
/// fabricated to fill the screen before the user types). Tracks
/// `isLoading`/`hasSearched` too (see [SearchResults]'s doc comment) so
/// the "no results" message only ever appears for a search that actually
/// ran and came back empty, never for the fresh, nothing-typed-yet state.

@ProviderFor(SearchAllResults)
final searchAllResultsProvider = SearchAllResultsProvider._();

/// Debounced live search across `/api/workouts?search=` and
/// `/api/recipes?search=` — empty query means empty results (nothing
/// fabricated to fill the screen before the user types). Tracks
/// `isLoading`/`hasSearched` too (see [SearchResults]'s doc comment) so
/// the "no results" message only ever appears for a search that actually
/// ran and came back empty, never for the fresh, nothing-typed-yet state.
final class SearchAllResultsProvider
    extends $NotifierProvider<SearchAllResults, SearchResults> {
  /// Debounced live search across `/api/workouts?search=` and
  /// `/api/recipes?search=` — empty query means empty results (nothing
  /// fabricated to fill the screen before the user types). Tracks
  /// `isLoading`/`hasSearched` too (see [SearchResults]'s doc comment) so
  /// the "no results" message only ever appears for a search that actually
  /// ran and came back empty, never for the fresh, nothing-typed-yet state.
  SearchAllResultsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'searchAllResultsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$searchAllResultsHash();

  @$internal
  @override
  SearchAllResults create() => SearchAllResults();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SearchResults value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SearchResults>(value),
    );
  }
}

String _$searchAllResultsHash() => r'f6a557f58a6807c3977e76a37a6305bc319f628a';

/// Debounced live search across `/api/workouts?search=` and
/// `/api/recipes?search=` — empty query means empty results (nothing
/// fabricated to fill the screen before the user types). Tracks
/// `isLoading`/`hasSearched` too (see [SearchResults]'s doc comment) so
/// the "no results" message only ever appears for a search that actually
/// ran and came back empty, never for the fresh, nothing-typed-yet state.

abstract class _$SearchAllResults extends $Notifier<SearchResults> {
  SearchResults build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<SearchResults, SearchResults>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<SearchResults, SearchResults>,
              SearchResults,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
