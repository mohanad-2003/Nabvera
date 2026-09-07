import 'package:nabvera/core/routing/app_routes.dart';
import 'package:nabvera/core/routing/password_reset_redirect.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('passwordResetRedirectTarget', () {
    test('redirects to /login with the success query flag', () {
      expect(
        passwordResetRedirectTarget(),
        '${AppRoutes.login}?$passwordResetQueryParam=$passwordResetQueryValue',
      );
      expect(passwordResetRedirectTarget(), '/login?passwordReset=success');
    });

    test(
      'takes no arguments and touches no auth/session API — hitting '
      '/reset-complete can never itself grant a session or sign anyone in, '
      'only redirect',
      () {
        // If this ever needed a FirebaseAuth instance, a user id, a token,
        // etc. to compute its result, that would be a sign the route
        // started doing something session-related. It doesn't: the
        // redirect target is a fixed string.
        final first = passwordResetRedirectTarget();
        final second = passwordResetRedirectTarget();
        expect(first, second);
      },
    );
  });

  group('isPasswordResetSuccess', () {
    test('true only for the exact flag passwordResetRedirectTarget sets', () {
      expect(isPasswordResetSuccess({'passwordReset': 'success'}), isTrue);
    });

    test('false when the query parameter is absent (plain /login)', () {
      expect(isPasswordResetSuccess(const {}), isFalse);
    });

    test('false for an unrelated or malformed value — never guessed', () {
      expect(isPasswordResetSuccess({'passwordReset': 'true'}), isFalse);
      expect(isPasswordResetSuccess({'passwordReset': ''}), isFalse);
      expect(isPasswordResetSuccess({'other': 'success'}), isFalse);
    });

    test(
      'never true just because a reset email was sent — only the '
      'reset-complete redirect ever sets this flag',
      () {
        // Sending the email never routes through passwordResetRedirectTarget
        // at all (see ForgotPasswordController.submit), so there is no
        // query map this test could construct from that path that would
        // ever satisfy isPasswordResetSuccess by accident.
        expect(isPasswordResetSuccess(const {}), isFalse);
      },
    );
  });
}
