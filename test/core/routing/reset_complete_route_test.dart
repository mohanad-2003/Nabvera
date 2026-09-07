import 'package:nabvera/core/routing/app_routes.dart';
import 'package:nabvera/core/routing/password_reset_redirect.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

/// Exercises the exact `/reset-complete` -> `/login?passwordReset=success`
/// wiring used in `app_router.dart`, with a minimal router (no Firebase,
/// no other app providers) so this stays a fast, isolated test while still
/// proving GoRouter really performs the redirect end to end — not just
/// that the pure helper function returns the right string.
GoRouter _buildTestRouter({required ValueSetter<bool> onLoginBuilt}) {
  return GoRouter(
    initialLocation: AppRoutes.resetComplete,
    routes: [
      GoRoute(
        path: AppRoutes.login,
        builder: (context, state) {
          onLoginBuilt(isPasswordResetSuccess(state.uri.queryParameters));
          return const Scaffold(body: Text('login'));
        },
      ),
      GoRoute(
        path: AppRoutes.resetComplete,
        redirect: (context, state) => passwordResetRedirectTarget(),
      ),
    ],
  );
}

void main() {
  testWidgets(
    'landing on /reset-complete redirects straight to /login with the success flag',
    (tester) async {
      bool? sawSuccessFlag;
      final router = _buildTestRouter(
        onLoginBuilt: (value) => sawSuccessFlag = value,
      );

      await tester.pumpWidget(MaterialApp.router(routerConfig: router));
      await tester.pumpAndSettle();

      expect(router.state.uri.path, AppRoutes.login);
      expect(router.state.uri.queryParameters, {'passwordReset': 'success'});
      expect(sawSuccessFlag, isTrue);
      expect(find.text('login'), findsOneWidget);
    },
  );

  testWidgets(
    'a plain /login (no query) never carries the success flag',
    (tester) async {
      bool? sawSuccessFlag;
      final router = GoRouter(
        initialLocation: AppRoutes.login,
        routes: [
          GoRoute(
            path: AppRoutes.login,
            builder: (context, state) {
              sawSuccessFlag = isPasswordResetSuccess(state.uri.queryParameters);
              return const Scaffold(body: Text('login'));
            },
          ),
        ],
      );

      await tester.pumpWidget(MaterialApp.router(routerConfig: router));
      await tester.pumpAndSettle();

      expect(sawSuccessFlag, isFalse);
    },
  );
}
