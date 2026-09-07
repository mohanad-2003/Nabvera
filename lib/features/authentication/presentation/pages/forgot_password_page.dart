import 'dart:async';

import 'package:nabvera/core/localization/generated/app_localizations.dart';
import 'package:nabvera/core/routing/app_routes.dart';
import 'package:nabvera/core/theme/app_theme_extension.dart';
import 'package:nabvera/core/utils/validators.dart';
import 'package:nabvera/core/widgets/fade_slide_in.dart';
import 'package:nabvera/core/widgets/primary_button.dart';
import 'package:nabvera/features/authentication/domain/auth_error_translator.dart';
import 'package:nabvera/features/authentication/presentation/providers/forgot_password_controller.dart';
import 'package:nabvera/features/authentication/presentation/widgets/auth_background.dart';
import 'package:nabvera/features/authentication/presentation/widgets/auth_header.dart';
import 'package:nabvera/features/authentication/presentation/widgets/auth_logo_hero.dart';
import 'package:nabvera/features/authentication/presentation/widgets/premium_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

const _resendCooldown = Duration(seconds: 30);

class ForgotPasswordPage extends ConsumerStatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  ConsumerState<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends ConsumerState<ForgotPasswordPage> {
  bool _sent = false;
  Timer? _cooldownTimer;
  int _secondsLeft = 0;

  @override
  void dispose() {
    _cooldownTimer?.cancel();
    super.dispose();
  }

  void _startCooldown() {
    _cooldownTimer?.cancel();
    setState(() => _secondsLeft = _resendCooldown.inSeconds);
    _cooldownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }
      if (_secondsLeft <= 1) {
        timer.cancel();
        setState(() => _secondsLeft = 0);
      } else {
        setState(() => _secondsLeft -= 1);
      }
    });
  }

  Future<void> _submit(WidgetRef ref, AppLocalizations l10n) async {
    final controller = ref.read(forgotPasswordControllerProvider.notifier);
    if (!controller.validateForm()) return;
    await controller.submit();
    if (!mounted) return;
    final result = ref.read(forgotPasswordControllerProvider);
    result.when(
      data: (_) {
        setState(() => _sent = true);
        _startCooldown();
      },
      loading: () {},
      error: (error, _) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(authErrorMessage(l10n, error))));
      },
    );
  }

  static String _maskEmail(String email) {
    final at = email.indexOf('@');
    if (at <= 1) return email;
    final name = email.substring(0, at);
    final domain = email.substring(at);
    final visible = name.substring(0, name.length > 2 ? 2 : 1);
    return '$visible${'*' * (name.length - visible.length).clamp(3, 6)}$domain';
  }

  @override
  Widget build(BuildContext context) {
    final controller = ref.watch(forgotPasswordControllerProvider.notifier);
    final isSubmitting = ref.watch(forgotPasswordControllerProvider).isLoading;
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      body: AuthBackground(
        showPreferenceControls: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 0, 24, 32),
          child:
              _sent
                  ? _ConfirmationView(
                    email: _maskEmail(controller.emailController.text.trim()),
                    secondsLeft: _secondsLeft,
                    isResending: isSubmitting,
                    onResend: () => _submit(ref, l10n),
                    onChangeEmail: () => setState(() => _sent = false),
                  )
                  : Column(
                    children: [
                      AuthHeader(title: l10n.authForgotPasswordTitle),
                      const SizedBox(height: 12),
                      FadeSlideIn(
                        child: AuthLogoHero(
                          logoSize: 120,
                          title: l10n.authRecoveryHeadline,
                          subtitle: l10n.authRecoveryBody,
                        ),
                      ),
                      const SizedBox(height: 28),
                      FadeSlideIn(
                        delay: const Duration(milliseconds: 90),
                        child: Form(
                          key: controller.formKey,
                          child: PremiumTextField(
                            controller: controller.emailController,
                            label: l10n.authEmail,
                            hint: l10n.authEmailHint,
                            prefixIcon: Icons.email_outlined,
                            keyboardType: TextInputType.emailAddress,
                            textInputAction: TextInputAction.done,
                            validator: Validators.email(l10n),
                            transparent: true,
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      FadeSlideIn(
                        delay: const Duration(milliseconds: 160),
                        child: PrimaryButton(
                          label: l10n.actionContinue,
                          icon: Icons.arrow_forward_rounded,
                          isLoading: isSubmitting,
                          showShadow: false,
                          onPressed: () => _submit(ref, l10n),
                        ),
                      ),
                    ],
                  ),
        ),
      ),
    );
  }
}

/// Shown right after the reset email is sent — a dedicated confirmation
/// state instead of a SnackBar-and-pop, with the usual next actions a user
/// wants here: resend (rate-limited), fix a typo'd address, or bail back to
/// login.
class _ConfirmationView extends StatelessWidget {
  const _ConfirmationView({
    required this.email,
    required this.secondsLeft,
    required this.isResending,
    required this.onResend,
    required this.onChangeEmail,
  });

  final String email;
  final int secondsLeft;
  final bool isResending;
  final VoidCallback onResend;
  final VoidCallback onChangeEmail;

  @override
  Widget build(BuildContext context) {
    final ext = Theme.of(context).extension<AppThemeExtension>()!;
    final l10n = AppLocalizations.of(context);
    final canResend = secondsLeft == 0 && !isResending;

    return Column(
      children: [
        AuthHeader(title: l10n.authCheckYourEmail, showBack: false),
        const SizedBox(height: 12),
        FadeSlideIn(
          child: AuthLogoHero(
            logoSize: 120,
            title: l10n.authCheckYourEmail,
            subtitle: l10n.authResetLinkSentTo(email),
          ),
        ),
        const SizedBox(height: 32),
        FadeSlideIn(
          delay: const Duration(milliseconds: 120),
          child: Column(
            children: [
              PrimaryButton(
                label:
                    canResend
                        ? l10n.authResendLink
                        : l10n.authResendLinkIn(secondsLeft),
                icon: Icons.refresh_rounded,
                isLoading: isResending,
                showShadow: false,
                onPressed: canResend ? onResend : null,
              ),
              const SizedBox(height: 12),
              TextButton(
                onPressed: onChangeEmail,
                child: Text(
                  l10n.authChangeEmail,
                  style: TextStyle(
                    color: ext.textPrimary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              TextButton(
                onPressed: () => context.go(AppRoutes.login),
                child: Text(
                  l10n.authBackToLogin,
                  style: TextStyle(
                    color: ext.textMuted,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
