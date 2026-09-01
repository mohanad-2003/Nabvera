import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../data/firebase_auth_service.dart';

part 'forgot_password_controller.g.dart';

@riverpod
class ForgotPasswordController extends _$ForgotPasswordController {
  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();

  @override
  FutureOr<void> build() {
    ref.onDispose(emailController.dispose);
  }

  bool validateForm() => formKey.currentState?.validate() ?? false;

  /// Sends Firebase's password-reset email. Firebase's own flow finishes on
  /// a web page opened from that email, so there is no in-app "set new
  /// password" step to chain into afterwards.
  Future<void> submit() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await ref
          .read(firebaseAuthServiceProvider)
          .sendPasswordResetEmail(emailController.text.trim());
    });
  }
}
