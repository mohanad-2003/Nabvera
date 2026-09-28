// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'popular_exercises_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(PopularExercises)
final popularExercisesProvider = PopularExercisesProvider._();

final class PopularExercisesProvider
    extends $NotifierProvider<PopularExercises, List<PopularExerciseItem>> {
  PopularExercisesProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'popularExercisesProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$popularExercisesHash();

  @$internal
  @override
  PopularExercises create() => PopularExercises();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(List<PopularExerciseItem> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<List<PopularExerciseItem>>(value),
    );
  }
}

String _$popularExercisesHash() => r'aca259f6e6864df4f36d48425447a6e5d71726bc';

abstract class _$PopularExercises extends $Notifier<List<PopularExerciseItem>> {
  List<PopularExerciseItem> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref =
        this.ref as $Ref<List<PopularExerciseItem>, List<PopularExerciseItem>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<List<PopularExerciseItem>, List<PopularExerciseItem>>,
              List<PopularExerciseItem>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
