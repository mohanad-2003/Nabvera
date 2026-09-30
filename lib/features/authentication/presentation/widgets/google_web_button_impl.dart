import 'package:flutter/widgets.dart';
import 'package:google_sign_in_web/web_only.dart' as web_gsi;

/// Google's own rendered "Sign in with Google" button — required on web
/// specifically, since `google_sign_in`'s imperative `signIn()` call is
/// explicitly documented (by the package itself) as unable to reliably
/// provide an `idToken` there. `theme` is the one thing that adapts to
/// this app's own dark/light mode — the button otherwise looks the same
/// everywhere, since Google controls its exact appearance.
Widget buildGoogleWebButton({required bool isDark}) {
  return web_gsi.renderButton(
    configuration: web_gsi.GSIButtonConfiguration(
      type: web_gsi.GSIButtonType.standard,
      theme:
          isDark
              ? web_gsi.GSIButtonTheme.filledBlack
              : web_gsi.GSIButtonTheme.outline,
      size: web_gsi.GSIButtonSize.large,
      text: web_gsi.GSIButtonText.continueWith,
      shape: web_gsi.GSIButtonShape.pill,
      logoAlignment: web_gsi.GSIButtonLogoAlignment.center,
      minimumWidth: 320,
    ),
  );
}
