// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'coach_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(CoachChatController)
final coachChatControllerProvider = CoachChatControllerProvider._();

final class CoachChatControllerProvider
    extends $NotifierProvider<CoachChatController, CoachChatState> {
  CoachChatControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'coachChatControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$coachChatControllerHash();

  @$internal
  @override
  CoachChatController create() => CoachChatController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(CoachChatState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<CoachChatState>(value),
    );
  }
}

String _$coachChatControllerHash() =>
    r'83fbc156b02c83e49088fc114ebb9d39e8e3d00e';

abstract class _$CoachChatController extends $Notifier<CoachChatState> {
  CoachChatState build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<CoachChatState, CoachChatState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<CoachChatState, CoachChatState>,
              CoachChatState,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
