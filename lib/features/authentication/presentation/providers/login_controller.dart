import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../profile/presentation/providers/profile_controller.dart';
import '../../data/firebase_auth_service.dart';

part 'login_controller.g.dart';

/// TextEditingControllers stay as plain fields (Riverpod doesn't manage
/// widget lifecycle objects) but submission is exposed through an
/// AsyncNotifier so the page can show a loading state consistently with
/// the rest of the app instead of a bespoke bool flag per screen.
@riverpod
class LoginController extends _$LoginController {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  FutureOr<void> build() {
    ref.onDispose(() {
      emailController.dispose();
      passwordController.dispose();
    });
  }

  Future<void> submit() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await ref
          .read(firebaseAuthServiceProvider)
          .signInWithEmail(
            email: emailController.text.trim(),
            password: passwordController.text,
          );
      await _refreshProfileAfterSignIn();
    });
  }

  Future<void> submitWithGoogle() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await ref.read(firebaseAuthServiceProvider).signInWithGoogle();
      await _refreshProfileAfterSignIn();
    });
  }

  /// `currentUserProfileProvider` is `keepAlive` (see its own doc comment)
  /// and typically already built — and already failed once, silently, at
  /// app boot with no signed-in user yet — long before this screen ever
  /// ran. Without this, the home page it feeds keeps showing that stale
  /// empty profile (no name, no avatar, no streak) after a successful
  /// sign-in until something else happens to trigger a refresh (e.g. a
  /// manual pull-to-refresh) — awaited here so navigation to home only
  /// happens once the real profile has actually loaded.
  Future<void> _refreshProfileAfterSignIn() {
    return ref.read(currentUserProfileProvider.notifier).refresh();
  }
}
