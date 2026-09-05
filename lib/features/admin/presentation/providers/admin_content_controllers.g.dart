// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_content_controllers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// One list controller per Admin content type. All five have the exact
/// same shape (`AsyncValue` of raw documents, a `refresh`, and a
/// `deleteItem`) — five small classes rather than one generic/family
/// provider, matching how this codebase already writes near-identical
/// per-feature controllers (see `WeeklyActivityController`/
/// `RecoveryMapController`).

@ProviderFor(AdminWorkoutsController)
final adminWorkoutsControllerProvider = AdminWorkoutsControllerProvider._();

/// One list controller per Admin content type. All five have the exact
/// same shape (`AsyncValue` of raw documents, a `refresh`, and a
/// `deleteItem`) — five small classes rather than one generic/family
/// provider, matching how this codebase already writes near-identical
/// per-feature controllers (see `WeeklyActivityController`/
/// `RecoveryMapController`).
final class AdminWorkoutsControllerProvider
    extends
        $NotifierProvider<
          AdminWorkoutsController,
          AsyncValue<List<Map<String, dynamic>>>
        > {
  /// One list controller per Admin content type. All five have the exact
  /// same shape (`AsyncValue` of raw documents, a `refresh`, and a
  /// `deleteItem`) — five small classes rather than one generic/family
  /// provider, matching how this codebase already writes near-identical
  /// per-feature controllers (see `WeeklyActivityController`/
  /// `RecoveryMapController`).
  AdminWorkoutsControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'adminWorkoutsControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$adminWorkoutsControllerHash();

  @$internal
  @override
  AdminWorkoutsController create() => AdminWorkoutsController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AsyncValue<List<Map<String, dynamic>>> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride:
          $SyncValueProvider<AsyncValue<List<Map<String, dynamic>>>>(value),
    );
  }
}

String _$adminWorkoutsControllerHash() =>
    r'04ab6f68c1c222497ea3f7682da58fcae945e001';

/// One list controller per Admin content type. All five have the exact
/// same shape (`AsyncValue` of raw documents, a `refresh`, and a
/// `deleteItem`) — five small classes rather than one generic/family
/// provider, matching how this codebase already writes near-identical
/// per-feature controllers (see `WeeklyActivityController`/
/// `RecoveryMapController`).

abstract class _$AdminWorkoutsController
    extends $Notifier<AsyncValue<List<Map<String, dynamic>>>> {
  AsyncValue<List<Map<String, dynamic>>> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref =
        this.ref
            as $Ref<
              AsyncValue<List<Map<String, dynamic>>>,
              AsyncValue<List<Map<String, dynamic>>>
            >;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                AsyncValue<List<Map<String, dynamic>>>,
                AsyncValue<List<Map<String, dynamic>>>
              >,
              AsyncValue<List<Map<String, dynamic>>>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

@ProviderFor(AdminExercisesController)
final adminExercisesControllerProvider = AdminExercisesControllerProvider._();

final class AdminExercisesControllerProvider
    extends
        $NotifierProvider<
          AdminExercisesController,
          AsyncValue<List<Map<String, dynamic>>>
        > {
  AdminExercisesControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'adminExercisesControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$adminExercisesControllerHash();

  @$internal
  @override
  AdminExercisesController create() => AdminExercisesController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AsyncValue<List<Map<String, dynamic>>> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride:
          $SyncValueProvider<AsyncValue<List<Map<String, dynamic>>>>(value),
    );
  }
}

String _$adminExercisesControllerHash() =>
    r'a77637f9a90c6b2492d941994118bcee0a0dada9';

abstract class _$AdminExercisesController
    extends $Notifier<AsyncValue<List<Map<String, dynamic>>>> {
  AsyncValue<List<Map<String, dynamic>>> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref =
        this.ref
            as $Ref<
              AsyncValue<List<Map<String, dynamic>>>,
              AsyncValue<List<Map<String, dynamic>>>
            >;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                AsyncValue<List<Map<String, dynamic>>>,
                AsyncValue<List<Map<String, dynamic>>>
              >,
              AsyncValue<List<Map<String, dynamic>>>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

@ProviderFor(AdminRecipesController)
final adminRecipesControllerProvider = AdminRecipesControllerProvider._();

final class AdminRecipesControllerProvider
    extends
        $NotifierProvider<
          AdminRecipesController,
          AsyncValue<List<Map<String, dynamic>>>
        > {
  AdminRecipesControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'adminRecipesControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$adminRecipesControllerHash();

  @$internal
  @override
  AdminRecipesController create() => AdminRecipesController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AsyncValue<List<Map<String, dynamic>>> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride:
          $SyncValueProvider<AsyncValue<List<Map<String, dynamic>>>>(value),
    );
  }
}

String _$adminRecipesControllerHash() =>
    r'1fa789ed9cf51873f356c1b2f65f74cb2f12dfe6';

abstract class _$AdminRecipesController
    extends $Notifier<AsyncValue<List<Map<String, dynamic>>>> {
  AsyncValue<List<Map<String, dynamic>>> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref =
        this.ref
            as $Ref<
              AsyncValue<List<Map<String, dynamic>>>,
              AsyncValue<List<Map<String, dynamic>>>
            >;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                AsyncValue<List<Map<String, dynamic>>>,
                AsyncValue<List<Map<String, dynamic>>>
              >,
              AsyncValue<List<Map<String, dynamic>>>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

@ProviderFor(AdminArticlesController)
final adminArticlesControllerProvider = AdminArticlesControllerProvider._();

final class AdminArticlesControllerProvider
    extends
        $NotifierProvider<
          AdminArticlesController,
          AsyncValue<List<Map<String, dynamic>>>
        > {
  AdminArticlesControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'adminArticlesControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$adminArticlesControllerHash();

  @$internal
  @override
  AdminArticlesController create() => AdminArticlesController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AsyncValue<List<Map<String, dynamic>>> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride:
          $SyncValueProvider<AsyncValue<List<Map<String, dynamic>>>>(value),
    );
  }
}

String _$adminArticlesControllerHash() =>
    r'802d71a9ad144f868fc857428e505eca979737ad';

abstract class _$AdminArticlesController
    extends $Notifier<AsyncValue<List<Map<String, dynamic>>>> {
  AsyncValue<List<Map<String, dynamic>>> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref =
        this.ref
            as $Ref<
              AsyncValue<List<Map<String, dynamic>>>,
              AsyncValue<List<Map<String, dynamic>>>
            >;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                AsyncValue<List<Map<String, dynamic>>>,
                AsyncValue<List<Map<String, dynamic>>>
              >,
              AsyncValue<List<Map<String, dynamic>>>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

@ProviderFor(AdminChallengesController)
final adminChallengesControllerProvider = AdminChallengesControllerProvider._();

final class AdminChallengesControllerProvider
    extends
        $NotifierProvider<
          AdminChallengesController,
          AsyncValue<List<Map<String, dynamic>>>
        > {
  AdminChallengesControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'adminChallengesControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$adminChallengesControllerHash();

  @$internal
  @override
  AdminChallengesController create() => AdminChallengesController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AsyncValue<List<Map<String, dynamic>>> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride:
          $SyncValueProvider<AsyncValue<List<Map<String, dynamic>>>>(value),
    );
  }
}

String _$adminChallengesControllerHash() =>
    r'3f30eb1ab8c8c5ae106ccf0ed56ea4649787b4fa';

abstract class _$AdminChallengesController
    extends $Notifier<AsyncValue<List<Map<String, dynamic>>>> {
  AsyncValue<List<Map<String, dynamic>>> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref =
        this.ref
            as $Ref<
              AsyncValue<List<Map<String, dynamic>>>,
              AsyncValue<List<Map<String, dynamic>>>
            >;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                AsyncValue<List<Map<String, dynamic>>>,
                AsyncValue<List<Map<String, dynamic>>>
              >,
              AsyncValue<List<Map<String, dynamic>>>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

@ProviderFor(AdminDashboardController)
final adminDashboardControllerProvider = AdminDashboardControllerProvider._();

final class AdminDashboardControllerProvider
    extends $NotifierProvider<AdminDashboardController, AdminDashboardStats> {
  AdminDashboardControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'adminDashboardControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$adminDashboardControllerHash();

  @$internal
  @override
  AdminDashboardController create() => AdminDashboardController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AdminDashboardStats value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AdminDashboardStats>(value),
    );
  }
}

String _$adminDashboardControllerHash() =>
    r'b859e17d00352e444bd10ff58c235ec323162c20';

abstract class _$AdminDashboardController
    extends $Notifier<AdminDashboardStats> {
  AdminDashboardStats build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AdminDashboardStats, AdminDashboardStats>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AdminDashboardStats, AdminDashboardStats>,
              AdminDashboardStats,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
