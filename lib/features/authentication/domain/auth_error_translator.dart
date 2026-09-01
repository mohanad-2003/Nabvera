import 'package:firebase_auth/firebase_auth.dart';

import '../../../core/localization/generated/app_localizations.dart';

/// Maps a [FirebaseAuthException] code to a localized, user-facing message.
/// Keeps every auth page from re-implementing the same switch statement.
String authErrorMessage(AppLocalizations l10n, Object error) {
  if (error is! FirebaseAuthException) return l10n.authErrorGeneric;

  switch (error.code) {
    case 'invalid-email':
      return l10n.authErrorInvalidEmail;
    case 'user-not-found':
      return l10n.authErrorUserNotFound;
    case 'wrong-password':
    case 'invalid-credential':
      return l10n.authErrorWrongPassword;
    case 'email-already-in-use':
      return l10n.authErrorEmailInUse;
    case 'weak-password':
      return l10n.authErrorWeakPassword;
    case 'network-request-failed':
      return l10n.authErrorNetwork;
    case 'sign-in-cancelled':
      return l10n.authErrorGoogleCancelled;
    default:
      return l10n.authErrorGeneric;
  }
}

/// Which field an auth error reads best attached to — so the page can show
/// it inline under that field instead of only in a SnackBar. `null` means
/// the error isn't about a specific field (e.g. a network error), and
/// should fall back to the general banner/SnackBar.
enum AuthErrorField { email, password }

AuthErrorField? authErrorField(Object error) {
  if (error is! FirebaseAuthException) return null;
  switch (error.code) {
    case 'invalid-email':
    case 'user-not-found':
    case 'email-already-in-use':
      return AuthErrorField.email;
    case 'wrong-password':
    case 'invalid-credential':
    case 'weak-password':
      return AuthErrorField.password;
    default:
      return null;
  }
}
