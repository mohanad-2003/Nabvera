import 'package:nabvera/core/localization/generated/app_localizations.dart';
import 'package:nabvera/core/routing/app_routes.dart';
import 'package:nabvera/core/theme/app_theme_extension.dart';
import 'package:nabvera/core/utils/validators.dart';
import 'package:nabvera/core/widgets/fade_slide_in.dart';
import 'package:nabvera/core/widgets/primary_button.dart';
import 'package:nabvera/features/authentication/data/biometric_service.dart';
import 'package:nabvera/features/authentication/domain/auth_error_translator.dart';
import 'package:nabvera/features/authentication/presentation/providers/signup_controller.dart';
import 'package:nabvera/features/authentication/presentation/widgets/auth_background.dart';
import 'package:nabvera/features/authentication/presentation/widgets/auth_divider_label.dart';
import 'package:nabvera/features/authentication/presentation/widgets/auth_header.dart';
import 'package:nabvera/features/authentication/presentation/widgets/auth_logo_hero.dart';
import 'package:nabvera/features/authentication/presentation/widgets/auth_switch_link.dart';
import 'package:nabvera/features/authentication/presentation/widgets/password_strength_meter.dart';
import 'package:nabvera/features/authentication/presentation/widgets/premium_text_field.dart';
import 'package:nabvera/features/authentication/presentation/widgets/social_login_row.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class SignupPage extends ConsumerStatefulWidget {
  const SignupPage({super.key});

  @override
  ConsumerState<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends ConsumerState<SignupPage> {
  final _formKey = GlobalKey<FormState>();
  bool _acceptedTerms = false;
  bool _triedSubmitWithoutTerms = false;
  AuthErrorField? _errorField;
  String? _errorMessage;

  void _clearFieldError(AuthErrorField field) {
    if (_errorField == field) setState(() => _errorField = null);
  }

  @override
  Widget build(BuildContext context) {
    final controller = ref.watch(signupControllerProvider.notifier);
    final isSubmitting = ref.watch(signupControllerProvider).isLoading;
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      body: AuthBackground(
        showPreferenceControls: false,
        child: Padding(
          padding: const EdgeInsets.only(bottom: 28),
          child: Column(
            children: [
              AuthHeader(title: l10n.authSignupTitle, showBack: false),
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 4, 24, 0),
                child: Column(
                  children: [
                    const FadeSlideIn(child: AuthLogoHero(logoSize: 120)),
                    const SizedBox(height: 18),
                    FadeSlideIn(
                      delay: const Duration(milliseconds: 60),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            PremiumTextField(
                              controller: controller.fullNameController,
                              label: l10n.authFullName,
                              hint: l10n.authFullNameHint,
                              prefixIcon: Icons.person_outline_rounded,
                              textInputAction: TextInputAction.next,
                              validator: Validators.requiredField(
                                l10n,
                                message: l10n.validationFullNameRequired,
                              ),
                              transparent: true,
                            ),
                            const SizedBox(height: 16),
                            PremiumTextField(
                              controller: controller.emailController,
                              label: l10n.authEmail,
                              hint: l10n.authEmailHint,
                              prefixIcon: Icons.email_outlined,
                              keyboardType: TextInputType.emailAddress,
                              textInputAction: TextInputAction.next,
                              validator: Validators.email(l10n),
                              errorText:
                                  _errorField == AuthErrorField.email
                                      ? _errorMessage
                                      : null,
                              onChanged:
                                  (_) => _clearFieldError(AuthErrorField.email),
                              transparent: true,
                            ),
                            const SizedBox(height: 16),
                            PremiumPasswordField(
                              controller: controller.passwordController,
                              label: l10n.authPassword,
                              hint: l10n.authPasswordCreateHint,
                              textInputAction: TextInputAction.next,
                              validator: Validators.password(l10n),
                              errorText:
                                  _errorField == AuthErrorField.password
                                      ? _errorMessage
                                      : null,
                              onChanged:
                                  (_) =>
                                      _clearFieldError(AuthErrorField.password),
                              transparent: true,
                            ),
                            PasswordStrengthMeter(
                              controller: controller.passwordController,
                            ),
                            const SizedBox(height: 16),
                            PremiumPasswordField(
                              controller: controller.confirmPasswordController,
                              label: l10n.authConfirmPassword,
                              hint: l10n.authConfirmPasswordHint,
                              textInputAction: TextInputAction.done,
                              validator: Validators.matches(
                                l10n,
                                controller.passwordController,
                              ),
                              transparent: true,
                            ),
                            const SizedBox(height: 18),
                            _TermsCheckbox(
                              accepted: _acceptedTerms,
                              showError:
                                  _triedSubmitWithoutTerms && !_acceptedTerms,
                              onChanged:
                                  (value) => setState(() {
                                    _acceptedTerms = value;
                                    if (value) {
                                      _triedSubmitWithoutTerms = false;
                                    }
                                  }),
                            ),
                            const SizedBox(height: 22),
                            PrimaryButton(
                              label: l10n.authStartTraining,
                              icon: Icons.bolt_rounded,
                              isLoading: isSubmitting,
                              showShadow: false,
                              onPressed: () async {
                                if (!_acceptedTerms) {
                                  setState(
                                    () => _triedSubmitWithoutTerms = true,
                                  );
                                  return;
                                }
                                setState(() {
                                  _errorField = null;
                                  _errorMessage = null;
                                });
                                if (_formKey.currentState!.validate()) {
                                  await controller.submit();
                                  if (!context.mounted) return;
                                  await _handleResult(context, ref, l10n);
                                }
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    FadeSlideIn(
                      delay: const Duration(milliseconds: 90),
                      child: Column(
                        children: [
                          AuthDividerLabel(label: l10n.authOrSignUpWith),
                          const SizedBox(height: 18),
                          SocialLoginRow(
                            onGooglePressed: () async {
                              await controller.submitWithGoogle();
                              if (!context.mounted) return;
                              await _handleResult(context, ref, l10n);
                            },
                            onGoogleWebAccount: (account) async {
                              await controller.completeGoogleSignIn(account);
                              if (!context.mounted) return;
                              await _handleResult(context, ref, l10n);
                            },
                          ),
                          const SizedBox(height: 24),
                          AuthSwitchLink(
                            text: l10n.authHaveAccount,
                            action: l10n.authLogIn,
                            onTap: () => context.push(AppRoutes.login),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _handleResult(
    BuildContext context,
    WidgetRef ref,
    AppLocalizations l10n,
  ) async {
    final result = ref.read(signupControllerProvider);
    await result.when(
      data: (_) => _afterSignup(context, ref),
      loading: () async {},
      error: (error, _) async {
        final field = authErrorField(error);
        setState(() {
          _errorField = field;
          _errorMessage = authErrorMessage(l10n, error);
        });
        if (field == null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(authErrorMessage(l10n, error))),
          );
        }
      },
    );
  }

  /// Offers the biometric app-lock only when the device genuinely supports
  /// it — see [BiometricService.isAvailable] — otherwise goes straight to
  /// setup with no dead-end prompt.
  Future<void> _afterSignup(BuildContext context, WidgetRef ref) async {
    final canUseBiometrics =
        await ref.read(biometricServiceProvider).isAvailable();
    if (!context.mounted) return;
    context.go(canUseBiometrics ? AppRoutes.fingerprint : AppRoutes.setup);
  }
}

/// Mandatory terms/privacy consent — the primary button refuses to submit
/// until this is checked, and an unmet attempt turns the row red instead of
/// silently doing nothing.
class _TermsCheckbox extends StatelessWidget {
  const _TermsCheckbox({
    required this.accepted,
    required this.showError,
    required this.onChanged,
  });

  final bool accepted;
  final bool showError;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    final ext = Theme.of(context).extension<AppThemeExtension>()!;
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);
    final errorColor = theme.colorScheme.error;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 24,
          width: 24,
          child: Checkbox(
            value: accepted,
            onChanged: (value) => onChanged(value ?? false),
            side: showError ? BorderSide(color: errorColor, width: 1.6) : null,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(6),
            ),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Text.rich(
            TextSpan(
              style: TextStyle(
                color: showError ? errorColor : ext.textMuted,
                height: 1.4,
              ),
              children: [
                TextSpan(text: l10n.authAgreeTermsPrefix),
                TextSpan(
                  text: l10n.privacyTerms,
                  style: TextStyle(
                    color: theme.colorScheme.primary,
                    fontWeight: FontWeight.w700,
                  ),
                  recognizer:
                      TapGestureRecognizer()
                        ..onTap =
                            () => context.push(AppRoutes.termsAndConditions),
                ),
                TextSpan(text: l10n.authAgreeTermsAnd),
                TextSpan(
                  text: l10n.privacyPolicy,
                  style: TextStyle(
                    color: theme.colorScheme.primary,
                    fontWeight: FontWeight.w700,
                  ),
                  recognizer:
                      TapGestureRecognizer()
                        ..onTap = () => context.push(AppRoutes.privacyPolicy),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
