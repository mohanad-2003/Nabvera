import 'package:nabvera/core/localization/generated/app_localizations.dart';
import 'package:nabvera/core/routing/app_routes.dart';
import 'package:nabvera/core/theme/app_colors.dart';
import 'package:nabvera/core/theme/app_theme_extension.dart';
import 'package:nabvera/core/widgets/fade_slide_in.dart';
import 'package:nabvera/core/widgets/primary_button.dart';
import 'package:nabvera/features/authentication/data/biometric_service.dart';
import 'package:nabvera/core/storage/preferences_service.dart';
import 'package:nabvera/features/authentication/presentation/widgets/auth_background.dart';
import 'package:nabvera/features/authentication/presentation/widgets/auth_header.dart';
import 'package:nabvera/features/authentication/presentation/widgets/auth_section_hero.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

enum _State { idle, checking, success, failed }

/// One-time, opt-in offer to turn on the biometric app-lock — pushed only
/// right after a successful signup, and only by a caller that has already
/// confirmed [BiometricService.isAvailable]. This page never decides on its
/// own whether to show the "enable" action; it trusts the caller's check so
/// a device without enrolled biometrics never sees a button promising a
/// feature it can't back.
class FingerPrintPage extends ConsumerStatefulWidget {
  const FingerPrintPage({super.key});

  @override
  ConsumerState<FingerPrintPage> createState() => _FingerPrintPageState();
}

class _FingerPrintPageState extends ConsumerState<FingerPrintPage> {
  _State _state = _State.idle;

  Future<void> _enable() async {
    setState(() => _state = _State.checking);
    final l10n = AppLocalizations.of(context);
    final ok = await ref
        .read(biometricServiceProvider)
        .authenticate(l10n.authBiometricUnlockBody);
    if (!mounted) return;
    if (ok) {
      await ref.read(preferencesServiceProvider).setBiometricEnabled(true);
    }
    setState(() => _state = ok ? _State.success : _State.failed);
    if (ok) {
      await Future.delayed(const Duration(milliseconds: 700));
      if (mounted) context.go(AppRoutes.setup);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final ext = theme.extension<AppThemeExtension>()!;
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      body: AuthBackground(
        showPreferenceControls: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 0, 24, 32),
          child: Column(
            children: [
              AuthHeader(title: l10n.authBiometricTitle, showBack: false),
              const SizedBox(height: 12),
              FadeSlideIn(
                child: AuthSectionHero(
                  icon:
                      _state == _State.success
                          ? Icons.check_circle_rounded
                          : _state == _State.failed
                          ? Icons.error_outline_rounded
                          : Icons.fingerprint_rounded,
                  colors:
                      _state == _State.success
                          ? [ext.success, AppColors.aquaBlue]
                          : _state == _State.failed
                          ? [ext.danger, AppColors.electricOrange]
                          : const [AppColors.aquaBlue, AppColors.seedViolet],
                  heroHeight: 220,
                  title: l10n.authBiometricHeadline,
                  subtitle:
                      _state == _State.success
                          ? l10n.authBiometricEnableSuccess
                          : _state == _State.failed
                          ? l10n.authBiometricEnableFailed
                          : l10n.authBiometricBody,
                ),
              ),
              const SizedBox(height: 40),
              FadeSlideIn(
                delay: const Duration(milliseconds: 140),
                child: Column(
                  children: [
                    PrimaryButton(
                      label:
                          _state == _State.failed
                              ? l10n.authBiometricRetry
                              : l10n.authEnableFingerprint,
                      icon: Icons.fingerprint_rounded,
                      isLoading: _state == _State.checking,
                      onPressed:
                          _state == _State.success ? null : () => _enable(),
                    ),
                    const SizedBox(height: 14),
                    TextButton(
                      onPressed: () => context.go(AppRoutes.setup),
                      child: Text(
                        l10n.authSkipForNow,
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
          ),
        ),
      ),
    );
  }
}
