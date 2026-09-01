// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'meal_idea_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(MealIdeaCategoryController)
final mealIdeaCategoryControllerProvider =
    MealIdeaCategoryControllerProvider._();

final class MealIdeaCategoryControllerProvider
    extends $NotifierProvider<MealIdeaCategoryController, MealCategory> {
  MealIdeaCategoryControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'mealIdeaCategoryControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$mealIdeaCategoryControllerHash();

  @$internal
  @override
  MealIdeaCategoryController create() => MealIdeaCategoryController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(MealCategory value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<MealCategory>(value),
    );
  }
}

String _$mealIdeaCategoryControllerHash() =>
    r'd5d8dfad52c76a0f7b8bb4bc3d26b0cbc05a47d8';

abstract class _$MealIdeaCategoryController extends $Notifier<MealCategory> {
  MealCategory build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<MealCategory, MealCategory>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<MealCategory, MealCategory>,
              MealCategory,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

/// Loads `/api/recipes?category=<category>`: the highest-rated recipe
/// becomes the section's hero ("top"), the next two are "recommended", and
/// the rest fill "recipes". Falls back to [MealDetail.empty] for `top` when
/// a category has no recipes yet.

@ProviderFor(MealIdeaSectionController)
final mealIdeaSectionControllerProvider = MealIdeaSectionControllerFamily._();

/// Loads `/api/recipes?category=<category>`: the highest-rated recipe
/// becomes the section's hero ("top"), the next two are "recommended", and
/// the rest fill "recipes". Falls back to [MealDetail.empty] for `top` when
/// a category has no recipes yet.
final class MealIdeaSectionControllerProvider
    extends $NotifierProvider<MealIdeaSectionController, MealIdeaSection> {
  /// Loads `/api/recipes?category=<category>`: the highest-rated recipe
  /// becomes the section's hero ("top"), the next two are "recommended", and
  /// the rest fill "recipes". Falls back to [MealDetail.empty] for `top` when
  /// a category has no recipes yet.
  MealIdeaSectionControllerProvider._({
    required MealIdeaSectionControllerFamily super.from,
    required MealCategory super.argument,
  }) : super(
         retry: null,
         name: r'mealIdeaSectionControllerProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$mealIdeaSectionControllerHash();

  @override
  String toString() {
    return r'mealIdeaSectionControllerProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  MealIdeaSectionController create() => MealIdeaSectionController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(MealIdeaSection value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<MealIdeaSection>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is MealIdeaSectionControllerProvider &&
        other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$mealIdeaSectionControllerHash() =>
    r'29de11d043302458a7df7d5a513172e2d47552f6';

/// Loads `/api/recipes?category=<category>`: the highest-rated recipe
/// becomes the section's hero ("top"), the next two are "recommended", and
/// the rest fill "recipes". Falls back to [MealDetail.empty] for `top` when
/// a category has no recipes yet.

final class MealIdeaSectionControllerFamily extends $Family
    with
        $ClassFamilyOverride<
          MealIdeaSectionController,
          MealIdeaSection,
          MealIdeaSection,
          MealIdeaSection,
          MealCategory
        > {
  MealIdeaSectionControllerFamily._()
    : super(
        retry: null,
        name: r'mealIdeaSectionControllerProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Loads `/api/recipes?category=<category>`: the highest-rated recipe
  /// becomes the section's hero ("top"), the next two are "recommended", and
  /// the rest fill "recipes". Falls back to [MealDetail.empty] for `top` when
  /// a category has no recipes yet.

  MealIdeaSectionControllerProvider call(MealCategory category) =>
      MealIdeaSectionControllerProvider._(argument: category, from: this);

  @override
  String toString() => r'mealIdeaSectionControllerProvider';
}

/// Loads `/api/recipes?category=<category>`: the highest-rated recipe
/// becomes the section's hero ("top"), the next two are "recommended", and
/// the rest fill "recipes". Falls back to [MealDetail.empty] for `top` when
/// a category has no recipes yet.

abstract class _$MealIdeaSectionController extends $Notifier<MealIdeaSection> {
  late final _$args = ref.$arg as MealCategory;
  MealCategory get category => _$args;

  MealIdeaSection build(MealCategory category);
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<MealIdeaSection, MealIdeaSection>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<MealIdeaSection, MealIdeaSection>,
              MealIdeaSection,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, () => build(_$args));
  }
}

/// Favorited recipe ids, seeded from the user's real profile
/// (`favoriteRecipeIds`) and kept in sync with
/// `POST /users/me/favorites/recipes/:id` on every toggle.

@ProviderFor(MealIdeaFavorites)
final mealIdeaFavoritesProvider = MealIdeaFavoritesProvider._();

/// Favorited recipe ids, seeded from the user's real profile
/// (`favoriteRecipeIds`) and kept in sync with
/// `POST /users/me/favorites/recipes/:id` on every toggle.
final class MealIdeaFavoritesProvider
    extends $NotifierProvider<MealIdeaFavorites, Set<String>> {
  /// Favorited recipe ids, seeded from the user's real profile
  /// (`favoriteRecipeIds`) and kept in sync with
  /// `POST /users/me/favorites/recipes/:id` on every toggle.
  MealIdeaFavoritesProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'mealIdeaFavoritesProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$mealIdeaFavoritesHash();

  @$internal
  @override
  MealIdeaFavorites create() => MealIdeaFavorites();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Set<String> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Set<String>>(value),
    );
  }
}

String _$mealIdeaFavoritesHash() => r'6e08f8d1a7237471399e3957fc092c39bdb5e9c1';

/// Favorited recipe ids, seeded from the user's real profile
/// (`favoriteRecipeIds`) and kept in sync with
/// `POST /users/me/favorites/recipes/:id` on every toggle.

abstract class _$MealIdeaFavorites extends $Notifier<Set<String>> {
  Set<String> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<Set<String>, Set<String>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<Set<String>, Set<String>>,
              Set<String>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
