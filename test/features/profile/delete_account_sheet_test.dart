import 'package:nabvera/core/localization/generated/app_localizations.dart';
import 'package:nabvera/core/network/api_client.dart';
import 'package:nabvera/core/routing/app_routes.dart';
import 'package:nabvera/core/theme/app_theme.dart';
import 'package:nabvera/features/authentication/data/firebase_auth_service.dart';
import 'package:nabvera/features/profile/data/user_repository.dart';
import 'package:nabvera/features/profile/domain/profile_models.dart';
import 'package:nabvera/features/profile/presentation/widgets/delete_account_sheet.dart';
import 'package:firebase_auth/firebase_auth.dart' show User, UserCredential;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

class FakeUserRepository implements UserRepository {
  bool throwOnDelete = false;
  int deleteCallCount = 0;

  @override
  Future<void> deleteAccount() async {
    deleteCallCount++;
    if (throwOnDelete) {
      throw ApiException(statusCode: 503, message: 'Account deletion is temporarily unavailable. Please try again later.');
    }
  }

  @override
  Future<UserProfile> fetchMe() async => throw UnimplementedError();
  @override
  Future<UserProfile> updateProfile(Map<String, dynamic> patch) async => throw UnimplementedError();
  @override
  Future<UserProfile> setBiometricEnabled(bool enabled) async => throw UnimplementedError();
  @override
  Future<List<String>> toggleFavoriteWorkout(String workoutId) async => throw UnimplementedError();
  @override
  Future<List<String>> toggleFavoriteRecipe(String recipeId) async => throw UnimplementedError();
  @override
  Future<void> registerFcmToken(String token) async {}
  @override
  Future<void> unregisterFcmToken(String token) async {}
}

class FakeFirebaseAuthService implements FirebaseAuthService {
  int signOutCallCount = 0;

  @override
  Future<void> signOut() async {
    signOutCallCount++;
  }

  @override
  User? get currentUser => null;
  @override
  Stream<User?> get authStateChanges => const Stream.empty();
  @override
  Future<UserCredential> signInWithEmail({required String email, required String password}) async =>
      throw UnimplementedError();
  @override
  Future<UserCredential> signUpWithEmail({required String fullName, required String email, required String password}) async =>
      throw UnimplementedError();
  @override
  Future<UserCredential> signInWithGoogle() async => throw UnimplementedError();
  @override
  Future<void> sendPasswordResetEmail(String email) async => throw UnimplementedError();
  @override
  Future<String?> getIdToken({bool forceRefresh = false}) async => null;
}

Future<GoRouter> _pumpWithDeleteButton(
  WidgetTester tester, {
  required FakeUserRepository fakeUsers,
  required FakeFirebaseAuthService fakeAuth,
}) async {
  final router = GoRouter(
    initialLocation: '/home',
    routes: [
      GoRoute(
        path: '/home',
        builder:
            (context, state) => Scaffold(
              body: Builder(
                builder:
                    (innerContext) => Consumer(
                      builder:
                          (consumerContext, ref, _) => ElevatedButton(
                            onPressed:
                                () => showDeleteAccountSheet(consumerContext, ref),
                            child: const Text('open'),
                          ),
                    ),
              ),
            ),
      ),
      GoRoute(
        path: AppRoutes.login,
        builder: (context, state) => const Scaffold(body: Text('login')),
      ),
    ],
  );

  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        userRepositoryProvider.overrideWithValue(fakeUsers),
        firebaseAuthServiceProvider.overrideWithValue(fakeAuth),
      ],
      child: MaterialApp.router(
        theme: AppTheme.light(),
        routerConfig: router,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
      ),
    ),
  );
  await tester.tap(find.text('open'));
  await tester.pumpAndSettle();
  return router;
}

void main() {
  testWidgets(
    'confirming delete calls the real API, signs out locally, then goes to Login',
    (tester) async {
      final fakeUsers = FakeUserRepository();
      final fakeAuth = FakeFirebaseAuthService();
      final router = await _pumpWithDeleteButton(
        tester,
        fakeUsers: fakeUsers,
        fakeAuth: fakeAuth,
      );

      final l10n = await AppLocalizations.delegate.load(const Locale('en'));
      await tester.tap(find.text(l10n.privacyDelete));
      await tester.pumpAndSettle();

      expect(fakeUsers.deleteCallCount, 1);
      expect(fakeAuth.signOutCallCount, 1);
      expect(router.state.uri.path, AppRoutes.login);
      expect(find.text('login'), findsOneWidget);
    },
  );

  testWidgets(
    'a failed deletion keeps the dialog open, shows the real error, and never signs out',
    (tester) async {
      final fakeUsers = FakeUserRepository()..throwOnDelete = true;
      final fakeAuth = FakeFirebaseAuthService();
      final router = await _pumpWithDeleteButton(
        tester,
        fakeUsers: fakeUsers,
        fakeAuth: fakeAuth,
      );

      final l10n = await AppLocalizations.delegate.load(const Locale('en'));
      await tester.tap(find.text(l10n.privacyDelete));
      await tester.pumpAndSettle();

      expect(fakeUsers.deleteCallCount, 1);
      expect(fakeAuth.signOutCallCount, 0);
      expect(router.state.uri.path, '/home');
      expect(
        find.text('Account deletion is temporarily unavailable. Please try again later.'),
        findsOneWidget,
      );
      // The confirm dialog itself is still up — the user never left it.
      expect(find.text(l10n.privacyDeleteConfirmTitle), findsOneWidget);
    },
  );
}
