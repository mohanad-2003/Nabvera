import 'package:fitness_app/features/authentication/data/biometric_service.dart';
import 'package:fitness_app/features/authentication/data/firebase_auth_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/localization/generated/app_localizations.dart';
import '../../../../core/routing/app_routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_theme_extension.dart';
import '../../../../core/widgets/fade_slide_in.dart';
import '../../../../core/widgets/primary_button.dart';
import '../widgets/auth_background.dart';
import '../widgets/auth_section_hero.dart';

/// The app-lock gate shown on launch when the signed-in user previously
/// opted into biometric unlock (see [FingerPrintPage]). Firebase's own
/// session already persists across restarts — this is a local device-level
/// re-confirmation in front of it, not a second sign-in.
class BiometricUnlockPage extends ConsumerStatefulWidget {
  const BiometricUnlockPage({super.key});

  @override
  ConsumerState<BiometricUnlockPage> createState() =>
      _BiometricUnlockPageState();
}

class _BiometricUnlockPageState extends ConsumerState<BiometricUnlockPage> {
  bool _checking = false;
  bool _failed = false;

  @override
  void initState() {
    super.initState();
    // Prompt immediately on arrival — the user shouldn't have to tap once
    // just to get the OS sheet to appear.
    WidgetsBinding.instance.addPostFrameCallback((_) => _unlock());
  }

  Future<void> _unlock() async {
    if (_checking) return;
    setState(() {
      _checking = true;
      _failed = false;
    });
    final l10n = AppLocalizations.of(context);
    final ok = await ref
        .read(biometricServiceProvider)
        .authenticate(l10n.authBiometricUnlockBody);
    if (!mounted) return;
    if (ok) {
      context.go(AppRoutes.home);
      return;
    }
    setState(() {
      _checking = false;
      _failed = true;
    });
  }

  Future<void> _logout() async {
    await ref.read(firebaseAuthServiceProvider).signOut();
    if (!mounted) return;
    context.go(AppRoutes.login);
  }

  @override
  Widget build(BuildContext context) {
    final ext = Theme.of(context).extension<AppThemeExtension>()!;
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      body: AuthBackground(
        showPreferenceControls: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 80, 24, 32),
          child: Column(
            children: [
              FadeSlideIn(
                child: AuthSectionHero(
                  icon:
                      _failed
                          ? Icons.error_outline_rounded
                          : Icons.fingerprint_rounded,
                  colors:
                      _failed
                          ? [ext.danger, AppColors.electricOrange]
                          : const [AppColors.aquaBlue, AppColors.seedViolet],
                  heroHeight: 220,
                  title: l10n.authBiometricUnlockTitle,
                  subtitle: l10n.authBiometricUnlockBody,
                ),
              ),
              const SizedBox(height: 40),
              FadeSlideIn(
                delay: const Duration(milliseconds: 140),
                child: Column(
                  children: [
                    PrimaryButton(
                      label:
                          _failed
                              ? l10n.authBiometricRetry
                              : l10n.authBiometricUnlockCta,
                      icon: Icons.fingerprint_rounded,
                      isLoading: _checking,
                      onPressed: _unlock,
                    ),
                    const SizedBox(height: 14),
                    TextButton(
                      onPressed: _logout,
                      child: Text(
                        l10n.authBiometricLogout,
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
