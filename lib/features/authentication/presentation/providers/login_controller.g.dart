// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'login_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// TextEditingControllers stay as plain fields (Riverpod doesn't manage
/// widget lifecycle objects) but submission is exposed through an
/// AsyncNotifier so the page can show a loading state consistently with
/// the rest of the app instead of a bespoke bool flag per screen.

@ProviderFor(LoginController)
final loginControllerProvider = LoginControllerProvider._();

/// TextEditingControllers stay as plain fields (Riverpod doesn't manage
/// widget lifecycle objects) but submission is exposed through an
/// AsyncNotifier so the page can show a loading state consistently with
/// the rest of the app instead of a bespoke bool flag per screen.
final class LoginControllerProvider
    extends $AsyncNotifierProvider<LoginController, void> {
  /// TextEditingControllers stay as plain fields (Riverpod doesn't manage
  /// widget lifecycle objects) but submission is exposed through an
  /// AsyncNotifier so the page can show a loading state consistently with
  /// the rest of the app instead of a bespoke bool flag per screen.
  LoginControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'loginControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$loginControllerHash();

  @$internal
  @override
  LoginController create() => LoginController();
}

String _$loginControllerHash() => r'3778b6493dd317b6235d2269184deca4b39f1807';

/// TextEditingControllers stay as plain fields (Riverpod doesn't manage
/// widget lifecycle objects) but submission is exposed through an
/// AsyncNotifier so the page can show a loading state consistently with
/// the rest of the app instead of a bespoke bool flag per screen.

abstract class _$LoginController extends $AsyncNotifier<void> {
  FutureOr<void> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AsyncValue<void>, void>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<void>, void>,
              AsyncValue<void>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
