import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:nabvera/core/localization/generated/app_localizations.dart';
import 'package:nabvera/core/routing/app_routes.dart';
import 'package:nabvera/core/storage/preferences_service.dart';
import 'package:nabvera/core/theme/app_theme.dart';
import 'package:nabvera/features/favorite/presentation/pages/favorite_page.dart';
import 'package:nabvera/features/nutrition/data/nutrition_repository.dart';
import 'package:nabvera/features/profile/data/user_repository.dart';
import 'package:nabvera/features/profile/domain/profile_models.dart';
import 'package:nabvera/features/workout/data/workout_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../nutrition/nutrition_test_fakes.dart';

class _FakeUserRepository implements UserRepository {
  @override
  Future<UserProfile> fetchMe() async => UserProfile.empty;
  @override
  Future<UserProfile> updateProfile(Map<String, dynamic> patch) async =>
      UserProfile.empty;
  @override
  Future<String> uploadAvatar({
    required Uint8List bytes,
    required String filename,
    String? contentType,
  }) async => throw UnimplementedError();
  @override
  Future<UserProfile> setBiometricEnabled(bool enabled) async =>
      throw UnimplementedError();
  @override
  Future<List<String>> toggleFavoriteWorkout(String workoutId) async =>
      throw UnimplementedError();
  @override
  Future<List<String>> toggleFavoriteRecipe(String recipeId) async =>
      throw UnimplementedError();
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

class _FakeWorkoutRepository implements WorkoutRepository {
  @override
  dynamic noSuchMethod(Invocation invocation) => throw UnimplementedError();
}

Future<void> _pumpFavorites(
  WidgetTester tester, {
  Locale locale = const Locale('en'),
}) async {
  SharedPreferences.setMockInitialValues({});
  final preferences = await SharedPreferences.getInstance();
  tester.view.physicalSize = const Size(800, 900);
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);

  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        userRepositoryProvider.overrideWithValue(_FakeUserRepository()),
        workoutRepositoryProvider.overrideWithValue(_FakeWorkoutRepository()),
        nutritionRepositoryProvider.overrideWithValue(
          FakeNutritionRepository(),
        ),
        sharedPreferencesProvider.overrideWithValue(preferences),
      ],
      child: MaterialApp.router(
        theme: AppTheme.light(),
        locale: locale,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        routerConfig: GoRouter(
          routes: [
            GoRoute(path: '/', builder: (_, _) => const FavoritePage()),
            GoRoute(
              path: AppRoutes.mealIdea,
              builder: (_, _) => const Scaffold(body: Text('STUB:meal-ideas')),
            ),
          ],
        ),
      ),
    ),
  );
  await tester.pumpAndSettle(const Duration(milliseconds: 100));
}

void main() {
  const emptyTitleEn = 'Your favorite recipes will appear here';

  testWidgets(
    'the Nutrition filter with no saved recipes shows the recipes empty state',
    (tester) async {
      await _pumpFavorites(tester);
      await tester.tap(find.text('Nutrition'));
      await tester.pumpAndSettle();

      expect(find.text(emptyTitleEn), findsOneWidget);
      expect(find.text('Explore recipes'), findsOneWidget);
      expect(find.byType(Image), findsOneWidget);
      final image = tester.widget<Image>(find.byType(Image));
      expect(image.fit, BoxFit.contain);
      expect((image.image as ResizeImage).imageProvider, isA<AssetImage>());
      expect(
        ((image.image as ResizeImage).imageProvider as AssetImage).assetName,
        'assets/nutrition_illustrations/saved_recipes_empty.png',
      );
    },
  );

  testWidgets('the explore button opens the existing recipes page', (
    tester,
  ) async {
    await _pumpFavorites(tester);
    await tester.tap(find.text('Nutrition'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Explore recipes'));
    await tester.pumpAndSettle();

    expect(find.text('STUB:meal-ideas'), findsOneWidget);
  });

  testWidgets(
    'the Workouts filter never uses the recipes illustration or text',
    (tester) async {
      await _pumpFavorites(tester);
      await tester.tap(find.text('Workouts'));
      await tester.pumpAndSettle();

      expect(find.text(emptyTitleEn), findsNothing);
      expect(find.text('No favorites yet'), findsOneWidget);
      expect(find.byType(Image), findsNothing);
    },
  );

  testWidgets('the combined "All" view keeps the generic empty state', (
    tester,
  ) async {
    await _pumpFavorites(tester);

    expect(find.text(emptyTitleEn), findsNothing);
    expect(find.text('No favorites yet'), findsOneWidget);
  });

  testWidgets('Arabic shows the requested wording', (tester) async {
    await _pumpFavorites(tester, locale: const Locale('ar'));
    await tester.tap(find.text('تغذية'));
    await tester.pumpAndSettle();

    expect(find.text('وصفاتك المفضلة ستظهر هنا'), findsOneWidget);
    expect(find.text('استكشف الوصفات'), findsOneWidget);
  });
}
