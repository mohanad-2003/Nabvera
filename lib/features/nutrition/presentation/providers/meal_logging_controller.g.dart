// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'meal_logging_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Tracks which meal-plan items have already been "marked as eaten"
/// today, keyed by `mealPlanItemId` -> the resulting log's id (needed for
/// undo). Seeded from today's real `/api/nutrition/today` document on
/// first load — not just this session's taps — so a card correctly shows
/// "Logged" again after leaving and returning to the screen, or after a
/// hot restart.

@ProviderFor(MealLoggingController)
final mealLoggingControllerProvider = MealLoggingControllerProvider._();

/// Tracks which meal-plan items have already been "marked as eaten"
/// today, keyed by `mealPlanItemId` -> the resulting log's id (needed for
/// undo). Seeded from today's real `/api/nutrition/today` document on
/// first load — not just this session's taps — so a card correctly shows
/// "Logged" again after leaving and returning to the screen, or after a
/// hot restart.
final class MealLoggingControllerProvider
    extends $AsyncNotifierProvider<MealLoggingController, Map<String, String>> {
  /// Tracks which meal-plan items have already been "marked as eaten"
  /// today, keyed by `mealPlanItemId` -> the resulting log's id (needed for
  /// undo). Seeded from today's real `/api/nutrition/today` document on
  /// first load — not just this session's taps — so a card correctly shows
  /// "Logged" again after leaving and returning to the screen, or after a
  /// hot restart.
  MealLoggingControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'mealLoggingControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$mealLoggingControllerHash();

  @$internal
  @override
  MealLoggingController create() => MealLoggingController();
}

String _$mealLoggingControllerHash() =>
    r'104dd54ffa854852c9131b36fd1466c18a823430';

/// Tracks which meal-plan items have already been "marked as eaten"
/// today, keyed by `mealPlanItemId` -> the resulting log's id (needed for
/// undo). Seeded from today's real `/api/nutrition/today` document on
/// first load — not just this session's taps — so a card correctly shows
/// "Logged" again after leaving and returning to the screen, or after a
/// hot restart.

abstract class _$MealLoggingController
    extends $AsyncNotifier<Map<String, String>> {
  FutureOr<Map<String, String>> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref =
        this.ref as $Ref<AsyncValue<Map<String, String>>, Map<String, String>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<Map<String, String>>, Map<String, String>>,
              AsyncValue<Map<String, String>>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
