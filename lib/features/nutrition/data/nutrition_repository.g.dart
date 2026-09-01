// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'nutrition_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(nutritionRepository)
final nutritionRepositoryProvider = NutritionRepositoryProvider._();

final class NutritionRepositoryProvider
    extends
        $FunctionalProvider<
          NutritionRepository,
          NutritionRepository,
          NutritionRepository
        >
    with $Provider<NutritionRepository> {
  NutritionRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'nutritionRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$nutritionRepositoryHash();

  @$internal
  @override
  $ProviderElement<NutritionRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  NutritionRepository create(Ref ref) {
    return nutritionRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(NutritionRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<NutritionRepository>(value),
    );
  }
}

String _$nutritionRepositoryHash() =>
    r'22bda85c0c76d68463f896e41ddf4d6cca974629';
