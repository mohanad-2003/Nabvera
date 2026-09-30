import 'dart:async';

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart' show GoogleSignInAccount;
import 'package:nabvera/core/localization/generated/app_localizations.dart';
import 'package:nabvera/core/theme/app_theme_extension.dart';
import 'package:nabvera/core/widgets/pressable_scale.dart';
import 'package:nabvera/core/widgets/smart_image.dart';
import 'package:nabvera/features/authentication/data/firebase_auth_service.dart';

import 'google_web_button.dart';

/// The secondary sign-in action — Google only. Facebook/Apple were never
/// wired to a real provider, and the third icon was actually a mislabeled
/// fingerprint asset, not an Apple mark — both removed rather than shipping
/// decorative, non-functional buttons.
///
/// Native and web genuinely need different UI here, not just a different
/// tap handler: `google_sign_in`'s imperative `signIn()` (behind
/// [onGooglePressed]) is unreliable on web — it can't guarantee an
/// `idToken`, which Firebase needs — so web instead renders Google's own
/// Identity Services button, and the resulting account arrives through
/// [onGoogleWebAccount] once the user completes that flow (not as a
/// return value, since the button drives the interaction itself).
class SocialLoginRow extends ConsumerStatefulWidget {
  const SocialLoginRow({
    super.key,
    this.onGooglePressed,
    this.onGoogleWebAccount,
  });

  final VoidCallback? onGooglePressed;
  final ValueChanged<GoogleSignInAccount>? onGoogleWebAccount;

  @override
  ConsumerState<SocialLoginRow> createState() => _SocialLoginRowState();
}

class _SocialLoginRowState extends ConsumerState<SocialLoginRow> {
  StreamSubscription<GoogleSignInAccount?>? _googleAccountSub;

  @override
  void initState() {
    super.initState();
    if (!kIsWeb) return;
    _googleAccountSub = ref
        .read(firebaseAuthServiceProvider)
        .onGoogleAccountChanged
        .listen((account) {
          if (account != null) widget.onGoogleWebAccount?.call(account);
        });
  }

  @override
  void dispose() {
    _googleAccountSub?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ext = Theme.of(context).extension<AppThemeExtension>()!;
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);

    if (kIsWeb) {
      // Google controls this button's exact look — centering it in the
      // same row height every other auth button uses keeps the page from
      // jumping, without trying to force Google's own element to match
      // this app's custom button chrome.
      return SizedBox(
        width: double.infinity,
        height: 56,
        child: Center(
          child: buildGoogleWebButton(isDark: theme.brightness == Brightness.dark),
        ),
      );
    }

    return PressableScale(
      enabled: widget.onGooglePressed != null,
      child: SizedBox(
        width: double.infinity,
        height: 56,
        child: OutlinedButton(
          onPressed: widget.onGooglePressed,
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
              // Flexible lets the label shrink to the button's actual width
              // on a narrow screen instead of overflowing past it — same
              // fix, same reasoning, as PrimaryButton's own label.
              Flexible(
                child: Text(
                  l10n.authContinueWithGoogle,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: ext.textPrimary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
