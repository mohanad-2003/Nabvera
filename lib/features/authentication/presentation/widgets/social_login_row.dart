import 'package:flutter/material.dart';

import '../../../../core/localization/generated/app_localizations.dart';
import '../../../../core/theme/app_theme_extension.dart';
import '../../../../core/widgets/pressable_scale.dart';
import '../../../../core/widgets/smart_image.dart';

/// The secondary sign-in action — Google only. Facebook/Apple were never
/// wired to a real provider, and the third icon was actually a mislabeled
/// fingerprint asset, not an Apple mark — both removed rather than shipping
/// decorative, non-functional buttons.
class SocialLoginRow extends StatelessWidget {
  const SocialLoginRow({super.key, this.onGooglePressed});

  final VoidCallback? onGooglePressed;

  @override
  Widget build(BuildContext context) {
    final ext = Theme.of(context).extension<AppThemeExtension>()!;
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);

    return PressableScale(
      enabled: onGooglePressed != null,
      child: SizedBox(
        width: double.infinity,
        height: 56,
        child: OutlinedButton(
          onPressed: onGooglePressed,
          style: OutlinedButton.styleFrom(
            backgroundColor: Colors.transparent,
            side: BorderSide(color: ext.textMuted.withValues(alpha: 0.32)),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(999),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SmartImage('assets/png/google.png', width: 22, height: 22),
              const SizedBox(width: 10),
              Text(
                l10n.authContinueWithGoogle,
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: ext.textPrimary,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
