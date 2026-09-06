// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'health_summary_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// The last 14 days of health summaries plus the weekly insights
/// comparison (see `GET /api/health/summary`). An [AsyncNotifier] so
/// Home/Progress can show real loading/error/empty states and support
/// pull-to-refresh via [refresh].

@ProviderFor(HealthSummaryController)
final healthSummaryControllerProvider = HealthSummaryControllerProvider._();

/// The last 14 days of health summaries plus the weekly insights
/// comparison (see `GET /api/health/summary`). An [AsyncNotifier] so
/// Home/Progress can show real loading/error/empty states and support
/// pull-to-refresh via [refresh].
final class HealthSummaryControllerProvider
    extends $AsyncNotifierProvider<HealthSummaryController, HealthOverview> {
  /// The last 14 days of health summaries plus the weekly insights
  /// comparison (see `GET /api/health/summary`). An [AsyncNotifier] so
  /// Home/Progress can show real loading/error/empty states and support
  /// pull-to-refresh via [refresh].
  HealthSummaryControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'healthSummaryControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$healthSummaryControllerHash();

  @$internal
  @override
  HealthSummaryController create() => HealthSummaryController();
}

String _$healthSummaryControllerHash() =>
    r'8e0e8e5553d58b3092da3ded6e8b38a2261e5e94';

/// The last 14 days of health summaries plus the weekly insights
/// comparison (see `GET /api/health/summary`). An [AsyncNotifier] so
/// Home/Progress can show real loading/error/empty states and support
/// pull-to-refresh via [refresh].

abstract class _$HealthSummaryController
    extends $AsyncNotifier<HealthOverview> {
  FutureOr<HealthOverview> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AsyncValue<HealthOverview>, HealthOverview>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<HealthOverview>, HealthOverview>,
              AsyncValue<HealthOverview>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
