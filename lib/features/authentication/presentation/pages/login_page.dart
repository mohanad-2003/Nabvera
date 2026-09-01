import 'package:fitness_app/core/localization/generated/app_localizations.dart';
import 'package:fitness_app/core/routing/app_routes.dart';
import 'package:fitness_app/core/storage/preferences_service.dart';
import 'package:fitness_app/core/theme/app_theme_extension.dart';
import 'package:fitness_app/core/utils/validators.dart';
import 'package:fitness_app/core/widgets/fade_slide_in.dart';
import 'package:fitness_app/core/widgets/primary_button.dart';
import 'package:fitness_app/features/authentication/domain/auth_error_translator.dart';
import 'package:fitness_app/features/authentication/presentation/providers/login_controller.dart';
import 'package:fitness_app/features/authentication/presentation/widgets/auth_background.dart';
import 'package:fitness_app/features/authentication/presentation/widgets/auth_divider_label.dart';
import 'package:fitness_app/features/authentication/presentation/widgets/auth_header.dart';
import 'package:fitness_app/features/authentication/presentation/widgets/auth_logo_hero.dart';
import 'package:fitness_app/features/authentication/presentation/widgets/auth_switch_link.dart';
import 'package:fitness_app/features/authentication/presentation/widgets/premium_text_field.dart';
import 'package:fitness_app/features/authentication/presentation/widgets/social_login_row.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  bool _rememberMe = false;
  AuthErrorField? _errorField;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    final remembered = ref.read(preferencesServiceProvider).rememberedEmail;
    if (remembered != null) {
      ref.read(loginControllerProvider.notifier).emailController.text =
          remembered;
      _rememberMe = true;
    }
  }

  void _clearFieldError(AuthErrorField field) {
    if (_errorField == field) setState(() => _errorField = null);
  }

  @override
  Widget build(BuildContext context) {
    final controller = ref.watch(loginControllerProvider.notifier);
    final isSubmitting = ref.watch(loginControllerProvider).isLoading;
    final l10n = AppLocalizations.of(context);
    final ext = Theme.of(context).extension<AppThemeExtension>()!;

    return Scaffold(
      body: AuthBackground(
        showPreferenceControls: false,
        child: Padding(
          padding: const EdgeInsets.only(bottom: 28),
          child: Column(
            children: [
              AuthHeader(title: l10n.authLoginTitle, showBack: false),
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 4, 24, 0),
                child: Column(
                  children: [
                    FadeSlideIn(
                      child: AuthLogoHero(
                        logoSize: 120,
                        title: l10n.authWelcomeBackTitle,
                        subtitle: l10n.authWelcomeBackBody,
                      ),
                    ),
                    const SizedBox(height: 22),
                    FadeSlideIn(
                      delay: const Duration(milliseconds: 60),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
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
                            const SizedBox(height: 18),
                            PremiumPasswordField(
                              controller: controller.passwordController,
                              label: l10n.authPassword,
                              hint: l10n.authPasswordHint,
                              textInputAction: TextInputAction.done,
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
                            const SizedBox(height: 6),
                            Row(
                              children: [
                                SizedBox(
                                  height: 24,
                                  width: 24,
                                  child: Checkbox(
                                    value: _rememberMe,
                                    onChanged:
                                        (value) => setState(
                                          () => _rememberMe = value ?? false,
                                        ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  l10n.authRememberMe,
                                  style: TextStyle(color: ext.textMuted),
                                ),
                                const Spacer(),
                                TextButton(
                                  onPressed:
                                      () => context.push(
                                        AppRoutes.forgotPassword,
                                      ),
                                  child: Text(l10n.authForgotPassword),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            PrimaryButton(
                              label: l10n.authLoginTitle,
                              icon: Icons.arrow_forward_rounded,
                              isLoading: isSubmitting,
                              onPressed: () async {
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
                          AuthDividerLabel(label: l10n.authOrContinueWith),
                          const SizedBox(height: 18),
                          SocialLoginRow(
                            onGooglePressed: () async {
                              await controller.submitWithGoogle();
                              if (!context.mounted) return;
                              await _handleResult(context, ref, l10n);
                            },
                          ),
                          const SizedBox(height: 24),
                          AuthSwitchLink(
                            text: l10n.authNoAccount,
                            action: l10n.authCreateAccount,
                            onTap: () => context.push(AppRoutes.signup),
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
    final result = ref.read(loginControllerProvider);
    await result.when(
      data: (_) async {
        await ref
            .read(preferencesServiceProvider)
            .setRememberedEmail(
              _rememberMe
                  ? ref.read(loginControllerProvider.notifier).emailController.text.trim()
                  : null,
            );
        if (!context.mounted) return;
        context.go(AppRoutes.home);
      },
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
}
