import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../profile/presentation/providers/profile_controller.dart';
import '../../data/firebase_auth_service.dart';

part 'signup_controller.g.dart';

@riverpod
class SignupController extends _$SignupController {
  final fullNameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  @override
  FutureOr<void> build() {
    ref.onDispose(() {
      fullNameController.dispose();
      emailController.dispose();
      passwordController.dispose();
      confirmPasswordController.dispose();
    });
  }

  Future<void> submit() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await ref
          .read(firebaseAuthServiceProvider)
          .signUpWithEmail(
            fullName: fullNameController.text.trim(),
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

  /// See the matching doc comment on `LoginController._refreshProfileAfterSignIn`
  /// — same issue, same fix: `currentUserProfileProvider` is `keepAlive`
  /// and typically already built (and already failed once, silently, at
  /// app boot with no signed-in user yet) before this screen ever ran.
  Future<void> _refreshProfileAfterSignIn() {
    return ref.read(currentUserProfileProvider.notifier).refresh();
  }
}
