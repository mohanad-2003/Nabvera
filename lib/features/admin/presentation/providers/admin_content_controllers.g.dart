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
    r'f4c8ca20a92d332209f86024fa65a365d0495c74';

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
    r'ffabde1a3cc992adf0ff3c4ed89b7b778eb1995c';

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
    r'1d6001aee3dae0fc8f40f1f817d8b95cb4104ddc';

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
    r'589a114537248a14cde414bf5b10328ab9280a68';

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
    r'ae6c7c05a4c0949a06aff6a02256c8313df6577f';

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
    r'2e281cea7b5f862a0c08114c3513faa136050f10';

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
