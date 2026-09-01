import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

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
    });
  }

  Future<void> submitWithGoogle() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await ref.read(firebaseAuthServiceProvider).signInWithGoogle();
    });
  }
}
