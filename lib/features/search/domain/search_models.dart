enum SearchResultType { workout, nutrition }

class SearchResultItem {
  const SearchResultItem({
    required this.id,
    required this.image,
    required this.name,
    required this.time,
    required this.calories,
    required this.type,
    this.exercises,
  });

  /// Backend `_id` — lets a tap open the real workout/recipe detail
  /// instead of doing nothing (there was no way to do that before this
  /// field existed).
  final String id;
  final String image;
  final String name;
  final String time;
  final String calories;
  final SearchResultType type;
  final String? exercises;
}

/// [SearchAllResults]' full state — distinguishes "haven't searched yet"
/// (fresh page, empty query) from "searched and found nothing" (query
/// typed, zero matches) from "still searching", so the UI never shows a
/// "no results" message for a search that was never actually run — see
/// SearchPage's empty state.
class SearchResults {
  const SearchResults({
    this.items = const [],
    this.isLoading = false,
    this.hasSearched = false,
  });

  final List<SearchResultItem> items;
  final bool isLoading;
  final bool hasSearched;

  SearchResults copyWith({
    List<SearchResultItem>? items,
    bool? isLoading,
    bool? hasSearched,
  }) {
    return SearchResults(
      items: items ?? this.items,
      isLoading: isLoading ?? this.isLoading,
      hasSearched: hasSearched ?? this.hasSearched,
    );
  }
}
