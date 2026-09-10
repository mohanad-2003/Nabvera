// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'favorite_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(FavoriteFilterController)
final favoriteFilterControllerProvider = FavoriteFilterControllerProvider._();

final class FavoriteFilterControllerProvider
    extends $NotifierProvider<FavoriteFilterController, FavoriteFilter> {
  FavoriteFilterControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'favoriteFilterControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$favoriteFilterControllerHash();

  @$internal
  @override
  FavoriteFilterController create() => FavoriteFilterController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(FavoriteFilter value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<FavoriteFilter>(value),
    );
  }
}

String _$favoriteFilterControllerHash() =>
    r'bb3220cb3df768a7b74a534b1dfe513294befa15';

abstract class _$FavoriteFilterController extends $Notifier<FavoriteFilter> {
  FavoriteFilter build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<FavoriteFilter, FavoriteFilter>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<FavoriteFilter, FavoriteFilter>,
              FavoriteFilter,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

/// Loads the user's real favorites — `favoriteWorkoutIds` fetched from
/// `/api/workouts/:id` (shown as "video" cards) and `favoriteRecipeIds`
/// from `/api/recipes/:id` ("article" cards). There's no batch-by-ids
/// endpoint, so this fetches each favorite individually; fine at the
/// small scale a favorites list actually reaches.

@ProviderFor(FilteredFavorites)
final filteredFavoritesProvider = FilteredFavoritesProvider._();

/// Loads the user's real favorites — `favoriteWorkoutIds` fetched from
/// `/api/workouts/:id` (shown as "video" cards) and `favoriteRecipeIds`
/// from `/api/recipes/:id` ("article" cards). There's no batch-by-ids
/// endpoint, so this fetches each favorite individually; fine at the
/// small scale a favorites list actually reaches.
final class FilteredFavoritesProvider
    extends $NotifierProvider<FilteredFavorites, List<FavoriteItem>> {
  /// Loads the user's real favorites — `favoriteWorkoutIds` fetched from
  /// `/api/workouts/:id` (shown as "video" cards) and `favoriteRecipeIds`
  /// from `/api/recipes/:id` ("article" cards). There's no batch-by-ids
  /// endpoint, so this fetches each favorite individually; fine at the
  /// small scale a favorites list actually reaches.
  FilteredFavoritesProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'filteredFavoritesProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$filteredFavoritesHash();

  @$internal
  @override
  FilteredFavorites create() => FilteredFavorites();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(List<FavoriteItem> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<List<FavoriteItem>>(value),
    );
  }
}

String _$filteredFavoritesHash() => r'0098fa09259c7a14ffca0e27e965cdb978874225';

/// Loads the user's real favorites — `favoriteWorkoutIds` fetched from
/// `/api/workouts/:id` (shown as "video" cards) and `favoriteRecipeIds`
/// from `/api/recipes/:id` ("article" cards). There's no batch-by-ids
/// endpoint, so this fetches each favorite individually; fine at the
/// small scale a favorites list actually reaches.

abstract class _$FilteredFavorites extends $Notifier<List<FavoriteItem>> {
  List<FavoriteItem> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<List<FavoriteItem>, List<FavoriteItem>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<List<FavoriteItem>, List<FavoriteItem>>,
              List<FavoriteItem>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
