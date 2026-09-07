import 'package:nabvera/core/localization/generated/app_localizations.dart';
import 'package:nabvera/core/routing/app_routes.dart';
import 'package:nabvera/core/storage/preferences_service.dart';
import 'package:nabvera/core/theme/app_theme.dart';
import 'package:nabvera/features/onboarding/presentation/pages/goal_page.dart';
import 'package:nabvera/features/profile/data/user_repository.dart';
import 'package:nabvera/features/profile/domain/profile_models.dart';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

class _FakeUserRepository implements UserRepository {
  @override
  Future<UserProfile> fetchMe() async => UserProfile.empty;
  @override
  Future<UserProfile> updateProfile(Map<String, dynamic> patch) async => UserProfile.empty;
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
  Future<void> registerFcmToken(String token) async {}
  @override
  Future<void> unregisterFcmToken(String token) async {}
  @override
  Future<void> deleteAccount() async => throw UnimplementedError();
}

void main() {
  testWidgets(
    'the continue button is disabled until a goal is chosen, then enabled and advances',
    (tester) async {
      final router = GoRouter(
        initialLocation: AppRoutes.setupGoal,
        routes: [
          GoRoute(
            path: AppRoutes.setupGoal,
            builder: (context, state) => const GoalPage(),
          ),
          GoRoute(
            path: AppRoutes.setupPhysical,
            builder: (context, state) => const Scaffold(body: Text('physical')),
          ),
        ],
      );

      SharedPreferences.setMockInitialValues({});
      final preferences = await SharedPreferences.getInstance();

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            userRepositoryProvider.overrideWithValue(_FakeUserRepository()),
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

      final l10n = await AppLocalizations.delegate.load(const Locale('en'));

      // Blocked: no goal chosen yet — the button is visually AND
      // functionally disabled, and a validation hint explains why.
      final continueButton = tester.widget<ElevatedButton>(
        find.byType(ElevatedButton),
      );
      expect(continueButton.onPressed, isNull);
      expect(find.text(l10n.onboardingGoalRequired), findsOneWidget);

      await tester.tap(find.text(l10n.goalLoseWeight));
      await tester.pumpAndSettle();

      expect(find.text(l10n.onboardingGoalRequired), findsNothing);
      final enabledButton = tester.widget<ElevatedButton>(
        find.byType(ElevatedButton),
      );
      expect(enabledButton.onPressed, isNotNull);

      await tester.tap(find.byType(ElevatedButton));
      await tester.pumpAndSettle();

      expect(router.state.uri.path, AppRoutes.setupPhysical);
    },
  );
}
