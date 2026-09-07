import 'package:nabvera/core/localization/generated/app_localizations.dart';
import 'package:nabvera/core/storage/preferences_service.dart';
import 'package:nabvera/core/theme/app_theme.dart';
import 'package:nabvera/features/authentication/presentation/pages/login_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Only builds LoginPage itself (not the real app router/Firebase) — the
/// same lightweight scope as `test/widget_test.dart`, since
/// `LoginController.build()` never touches `FirebaseAuth` (only `submit()`
/// does, on an actual tap this test never performs).
Future<void> _pumpLoginPage(
  WidgetTester tester, {
  required bool showPasswordResetSuccess,
}) async {
  SharedPreferences.setMockInitialValues({});
  final preferences = await SharedPreferences.getInstance();

  await tester.pumpWidget(
    ProviderScope(
      overrides: [sharedPreferencesProvider.overrideWithValue(preferences)],
      child: MaterialApp(
        theme: AppTheme.light(),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: LoginPage(showPasswordResetSuccess: showPasswordResetSuccess),
      ),
    ),
  );
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets(
    'showPasswordResetSuccess: true shows the "password changed" message once, after the first frame',
    (tester) async {
      await _pumpLoginPage(tester, showPasswordResetSuccess: true);

      // Not shown on the very first frame (needs a post-frame callback +
      // a real Scaffold/Overlay already mounted) …
      expect(find.byType(SnackBar), findsNothing);

      await tester.pump();
      // …but is shown right after.
      expect(find.byType(SnackBar), findsOneWidget);

      final l10n = await AppLocalizations.delegate.load(const Locale('en'));
      expect(find.text(l10n.authPasswordResetSuccess), findsOneWidget);

      // Let the SnackBar's own auto-dismiss timer run out before the test
      // ends, so the framework doesn't flag a pending Timer.
      await tester.pump(const Duration(seconds: 5));
    },
  );

  testWidgets(
    'showPasswordResetSuccess: false (plain /login) never shows the message',
    (tester) async {
      await _pumpLoginPage(tester, showPasswordResetSuccess: false);
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      expect(find.byType(SnackBar), findsNothing);
    },
  );
}
