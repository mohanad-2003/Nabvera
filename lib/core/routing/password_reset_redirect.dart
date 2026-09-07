import 'app_routes.dart';

/// Query param carrying the password-reset success flag from
/// `/reset-complete` through to `/login` (see [passwordResetRedirectTarget]
/// and [isPasswordResetSuccess]).
const passwordResetQueryParam = 'passwordReset';
const passwordResetQueryValue = 'success';

/// Pure decision function behind the `/reset-complete` route — kept free
/// of `GoRouterState`/`BuildContext` so it's directly unit-testable (see
/// `test/core/routing/password_reset_redirect_test.dart`), same pattern as
/// `admin_route_guard.dart`.
///
/// This is the entire handler for the Firebase "continue URL" the user
/// lands on after successfully resetting their password on Firebase's
/// hosted web page (see `FirebaseAuthService.sendPasswordResetEmail`) — it
/// takes no input and touches no `FirebaseAuth`/session state at all, so
/// hitting this route can never itself grant a session or sign anyone in;
/// it only redirects to Login with a flag Login uses purely to decide
/// whether to show the "password changed" message.
String passwordResetRedirectTarget() {
  return '${AppRoutes.login}?$passwordResetQueryParam=$passwordResetQueryValue';
}

/// Reads the flag [passwordResetRedirectTarget] attaches, from the query
/// parameters of whatever request reached `/login` — true only for an
/// exact `?passwordReset=success`, never inferred from anything else
/// (e.g. just having sent the reset email, which never sets this).
bool isPasswordResetSuccess(Map<String, String> queryParameters) {
  return queryParameters[passwordResetQueryParam] == passwordResetQueryValue;
}
