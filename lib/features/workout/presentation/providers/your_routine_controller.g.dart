// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'your_routine_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Flattens every exercise across all of the user's `/api/routines` into one
/// list for the "Your Routine" grid. `isFavorite` has no backend equivalent
/// for individual exercises — it stays a local-only UI toggle.

@ProviderFor(YourRoutineController)
final yourRoutineControllerProvider = YourRoutineControllerProvider._();

/// Flattens every exercise across all of the user's `/api/routines` into one
/// list for the "Your Routine" grid. `isFavorite` has no backend equivalent
/// for individual exercises — it stays a local-only UI toggle.
final class YourRoutineControllerProvider
    extends $NotifierProvider<YourRoutineController, List<RoutineItem>> {
  /// Flattens every exercise across all of the user's `/api/routines` into one
  /// list for the "Your Routine" grid. `isFavorite` has no backend equivalent
  /// for individual exercises — it stays a local-only UI toggle.
  YourRoutineControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'yourRoutineControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$yourRoutineControllerHash();

  @$internal
  @override
  YourRoutineController create() => YourRoutineController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(List<RoutineItem> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<List<RoutineItem>>(value),
    );
  }
}

String _$yourRoutineControllerHash() =>
    r'94299f45313ce14dd6152441723096e9e324ea23';

/// Flattens every exercise across all of the user's `/api/routines` into one
/// list for the "Your Routine" grid. `isFavorite` has no backend equivalent
/// for individual exercises — it stays a local-only UI toggle.

abstract class _$YourRoutineController extends $Notifier<List<RoutineItem>> {
  List<RoutineItem> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<List<RoutineItem>, List<RoutineItem>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<List<RoutineItem>, List<RoutineItem>>,
              List<RoutineItem>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
