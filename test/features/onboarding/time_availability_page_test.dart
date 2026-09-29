import 'package:nabvera/core/localization/generated/app_localizations.dart';
import 'package:nabvera/core/routing/app_routes.dart';
import 'package:nabvera/core/storage/preferences_service.dart';
import 'package:nabvera/core/theme/app_theme.dart';
import 'package:nabvera/features/onboarding/presentation/pages/time_availability_page.dart';
import 'package:nabvera/features/profile/data/user_repository.dart';
import 'package:nabvera/features/profile/domain/profile_models.dart';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

class _FakeUserRepository implements UserRepository {
  bool throwOnUpdate = false;
  int updateCallCount = 0;

  @override
  Future<UserProfile> fetchMe() async => UserProfile.empty;

  @override
  Future<UserProfile> updateProfile(Map<String, dynamic> patch) async {
    updateCallCount++;
    if (throwOnUpdate) throw Exception('network error');
    return UserProfile.empty;
  }

  @override
  Future<String> uploadAvatar({required Uint8List bytes, required String filename, String? contentType}) async =>
      throw UnimplementedError();
  @override
  Future<UserProfile> setBiometricEnabled(bool enabled) async => throw UnimplementedError();
  @override
  Future<List<String>> toggleFavoriteWorkout(String workoutId) async => throw UnimplementedError();
  @override
  Future<List<String>> toggleFavoriteRecipe(String recipeId) async => throw UnimplementedError();
  @override
  Future<void> setActiveWorkoutSession({
    required String workoutId,
    required String title,
    required String titleAr,
    required String image,
    required int completedSets,
    required int totalSets,
  }) async {}
  @override
  Future<void> clearActiveWorkoutSession() async {}
  @override
  Future<void> registerFcmToken(String token) async {}
  @override
  Future<void> unregisterFcmToken(String token) async {}
  @override
  Future<void> deleteAccount() async => throw UnimplementedError();

  @override
  Future<Map<String, dynamic>> exportData() async => throw UnimplementedError();
}

Future<GoRouter> _pump(WidgetTester tester, _FakeUserRepository fake) async {
  SharedPreferences.setMockInitialValues({});
  final preferences = await SharedPreferences.getInstance();

  final router = GoRouter(
    initialLocation: AppRoutes.setupTime,
    routes: [
      GoRoute(
        path: AppRoutes.setupTime,
        builder: (context, state) => const TimeAvailabilityPage(),
      ),
      GoRoute(
        path: AppRoutes.home,
        builder: (context, state) => const Scaffold(body: Text('home')),
      ),
    ],
  );

  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        userRepositoryProvider.overrideWithValue(fake),
        sharedPreferencesProvider.overrideWithValue(preferences),
      ],
      child: MaterialApp.router(
        theme: AppTheme.light(),
        routerConfig: router,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
      ),
    ),
  );
  await tester.pumpAndSettle();
  return router;
}

void main() {
  testWidgets('a successful save navigates to Home', (tester) async {
    final fake = _FakeUserRepository();
    final router = await _pump(tester, fake);

    final l10n = await AppLocalizations.delegate.load(const Locale('en'));
    await tester.tap(find.text(l10n.onboardingStart));
    await tester.pumpAndSettle();

    expect(fake.updateCallCount, 1);
    expect(router.state.uri.path, AppRoutes.home);
  });

  testWidgets(
    'a failed save shows a real error and Retry, never enters Home, then succeeds on retry',
    (tester) async {
      final fake = _FakeUserRepository()..throwOnUpdate = true;
      final router = await _pump(tester, fake);

      final l10n = await AppLocalizations.delegate.load(const Locale('en'));
      await tester.tap(find.text(l10n.onboardingStart));
      await tester.pumpAndSettle();

      expect(fake.updateCallCount, 1);
      expect(router.state.uri.path, AppRoutes.setupTime);
      expect(find.text(l10n.onboardingSaveFailed), findsOneWidget);
      expect(find.text(l10n.actionRetry), findsOneWidget);

      // Fix the backend and retry — should now succeed and proceed.
      fake.throwOnUpdate = false;
      await tester.tap(find.text(l10n.actionRetry));
      await tester.pumpAndSettle();

      expect(fake.updateCallCount, 2);
      expect(router.state.uri.path, AppRoutes.home);
    },
  );
}
