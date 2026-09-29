// Responsive-design audit: pumps every screen that can be built without a
// live backend/Firebase session across a wide sweep of real device screen
// sizes (see `_sizes` below) and fails loudly if Flutter reports a layout
// overflow (RenderFlex overflow, unbounded-constraint errors, etc.) at any
// of them. This is the actual verification the manual code audit can't
// give on its own — a real layout pass, not just `flutter analyze`.
import 'dart:typed_data';

import 'package:nabvera/core/localization/generated/app_localizations.dart';
import 'package:nabvera/core/routing/app_routes.dart';
import 'package:nabvera/core/storage/preferences_service.dart';
import 'package:nabvera/core/theme/app_theme.dart';
import 'package:nabvera/features/authentication/presentation/pages/forgot_password_page.dart';
import 'package:nabvera/features/authentication/presentation/pages/login_page.dart';
import 'package:nabvera/features/authentication/presentation/pages/onboarding_carousel_page.dart';
import 'package:nabvera/features/authentication/presentation/pages/signup_page.dart';
import 'package:nabvera/features/authentication/presentation/pages/splash_page.dart';
import 'package:nabvera/features/onboarding/presentation/pages/age_page.dart';
import 'package:nabvera/features/onboarding/presentation/pages/equipment_page.dart';
import 'package:nabvera/features/onboarding/presentation/pages/gender_page.dart';
import 'package:nabvera/features/onboarding/presentation/pages/goal_page.dart';
import 'package:nabvera/features/onboarding/presentation/pages/height_page.dart';
import 'package:nabvera/features/onboarding/presentation/pages/physical_activity_page.dart';
import 'package:nabvera/features/onboarding/presentation/pages/setup_intro_page.dart';
import 'package:nabvera/features/onboarding/presentation/pages/time_availability_page.dart';
import 'package:nabvera/features/onboarding/presentation/pages/weight_page.dart';
import 'package:nabvera/features/profile/data/user_repository.dart';
import 'package:nabvera/features/profile/domain/profile_models.dart';
import 'package:nabvera/features/profile/presentation/pages/legal_document_page.dart';
import 'package:nabvera/features/profile/presentation/pages/privacy_page.dart';
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
  Future<String> uploadAvatar({
    required Uint8List bytes,
    required String filename,
    String? contentType,
  }) async => throw UnimplementedError();
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

/// Every size from the audit brief: small/normal/large phones, tablets,
/// each as (name, width, height) in logical pixels.
const _sizes = [
  ('small-320x568', 320.0, 568.0),
  ('small-360x640', 360.0, 640.0),
  ('normal-375x667', 375.0, 667.0),
  ('normal-390x844', 390.0, 844.0),
  ('normal-393x852', 393.0, 852.0), // the app's own ScreenUtil designSize
  ('normal-412x915', 412.0, 915.0),
  ('large-430x932', 430.0, 932.0),
  ('tablet-600x960', 600.0, 960.0),
  ('tablet-768x1024', 768.0, 1024.0),
  ('tablet-800x1280', 800.0, 1280.0),
];

/// A phone-representative landscape sweep — tablets are covered in both
/// orientations via the portrait sizes above already being wide enough,
/// but phones specifically flipped is a distinct, commonly-missed case.
const _landscapeSizes = [
  ('small-landscape-568x320', 568.0, 320.0),
  ('normal-landscape-844x390', 844.0, 390.0),
  ('large-landscape-932x430', 932.0, 430.0),
];

/// Pumps [child] at every size in [sizes], settles it, and asserts no
/// `FlutterError` (which is how RenderFlex/overflow/unbounded-constraint
/// failures surface) was recorded at any of them. Reports every failing
/// size together, not just the first, so one run shows the full picture.
Future<void> _sweep(
  WidgetTester tester,
  String screenName,
  List<(String, double, double)> sizes,
  Widget Function() build, {
  bool settle = true,
}) async {
  final failures = <String>[];
  // The bare exception object's toString() for a layout-phase overflow is
  // often just the one-line summary ("A RenderFlex overflowed by N
  // pixels…") — the full diagnostics (creator chain, source location,
  // suggested fix) only come through FlutterErrorDetails.toString(), so
  // capture that directly rather than relying on takeException() alone.
  final richDetails = <String>[];
  final previousOnError = FlutterError.onError;
  FlutterError.onError = (details) {
    richDetails.add(details.toString());
    previousOnError?.call(details);
  };
  try {
    for (final (sizeName, width, height) in sizes) {
      tester.view.physicalSize = Size(width, height);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      richDetails.clear();
      await tester.pumpWidget(build());
      if (settle) {
        await tester.pumpAndSettle(const Duration(milliseconds: 100));
      } else {
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 500));
      }

      final exception = tester.takeException();
      if (exception != null || richDetails.isNotEmpty) {
        final detail = richDetails.isNotEmpty ? richDetails.join('\n---\n') : '$exception';
        failures.add('$sizeName (${width}x$height):\n$detail');
      }
    }
  } finally {
    FlutterError.onError = previousOnError;
  }
  if (failures.isNotEmpty) {
    fail('$screenName overflowed at:\n${failures.join('\n\n')}');
  }
}

Widget _wrapSimple(Widget page) => MaterialApp(
  theme: AppTheme.light(),
  localizationsDelegates: AppLocalizations.localizationsDelegates,
  supportedLocales: AppLocalizations.supportedLocales,
  home: page,
);

/// Wraps an onboarding page with just enough real routing (a single-route
/// `GoRouter`) for widgets that call `GoRouter.of(context)`/`context.push`
/// during build, the repository override these pages' controllers read
/// from, and `sharedPreferencesProvider` — every onboarding page is
/// wrapped in `AuthBackground`, which watches `themeControllerProvider`/
/// `localeControllerProvider`, both backed by `PreferencesService` and so
/// unusable without a real (mocked) `SharedPreferences` instance.
Widget _wrapOnboarding(Widget page, String path, SharedPreferences preferences) =>
    ProviderScope(
      overrides: [
        userRepositoryProvider.overrideWithValue(_FakeUserRepository()),
        sharedPreferencesProvider.overrideWithValue(preferences),
      ],
      child: MaterialApp.router(
        theme: AppTheme.light(),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        routerConfig: GoRouter(
          initialLocation: path,
          routes: [GoRoute(path: path, builder: (_, _) => page)],
        ),
      ),
    );

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Authentication screens', () {
    testWidgets('LoginPage', (tester) async {
      SharedPreferences.setMockInitialValues({});
      final preferences = await SharedPreferences.getInstance();
      await _sweep(tester, 'LoginPage', _sizes, () {
        return ProviderScope(
          overrides: [sharedPreferencesProvider.overrideWithValue(preferences)],
          child: _wrapSimple(const LoginPage(showPasswordResetSuccess: false)),
        );
      });
    });

    testWidgets('SignupPage', (tester) async {
      SharedPreferences.setMockInitialValues({});
      final preferences = await SharedPreferences.getInstance();
      await _sweep(tester, 'SignupPage', _sizes, () {
        return ProviderScope(
          overrides: [sharedPreferencesProvider.overrideWithValue(preferences)],
          child: _wrapSimple(const SignupPage()),
        );
      });
    });

    testWidgets('ForgotPasswordPage', (tester) async {
      SharedPreferences.setMockInitialValues({});
      final preferences = await SharedPreferences.getInstance();
      await _sweep(
        tester,
        'ForgotPasswordPage',
        _sizes,
        () => _wrapOnboarding(const ForgotPasswordPage(), AppRoutes.forgotPassword, preferences),
      );
    });

    testWidgets('SplashPage', (tester) async {
      SharedPreferences.setMockInitialValues({});
      final preferences = await SharedPreferences.getInstance();
      // Not settled: the splash backdrop runs a continuously-repeating
      // AnimationController (see SplashPage's own doc comment/painter),
      // so pumpAndSettle would never return. A handful of fixed pumps is
      // enough to lay the screen out and catch a real overflow.
      await _sweep(
        tester,
        'SplashPage',
        _sizes,
        () => _wrapOnboarding(const SplashPage(), AppRoutes.splash, preferences),
        settle: false,
      );
    });

    testWidgets('OnboardingCarouselPage', (tester) async {
      SharedPreferences.setMockInitialValues({});
      final preferences = await SharedPreferences.getInstance();
      await _sweep(tester, 'OnboardingCarouselPage', _sizes, () {
        return ProviderScope(
          overrides: [sharedPreferencesProvider.overrideWithValue(preferences)],
          child: _wrapSimple(const OnboardingCarouselPage()),
        );
      });
    });
  });

  group('Onboarding profile-setup screens', () {
    testWidgets('GoalPage', (tester) async {
      SharedPreferences.setMockInitialValues({});
      final preferences = await SharedPreferences.getInstance();
      await _sweep(
        tester,
        'GoalPage',
        _sizes,
        () => _wrapOnboarding(const GoalPage(), AppRoutes.setupGoal, preferences),
      );
    });

    testWidgets('AgePage', (tester) async {
      SharedPreferences.setMockInitialValues({});
      final preferences = await SharedPreferences.getInstance();
      await _sweep(
        tester,
        'AgePage',
        _sizes,
        () => _wrapOnboarding(const AgePage(), AppRoutes.setupAge, preferences),
      );
    });

    testWidgets('GenderPage', (tester) async {
      SharedPreferences.setMockInitialValues({});
      final preferences = await SharedPreferences.getInstance();
      await _sweep(
        tester,
        'GenderPage',
        _sizes,
        () => _wrapOnboarding(const GenderPage(), AppRoutes.setupGender, preferences),
      );
    });

    testWidgets('WeightPage', (tester) async {
      SharedPreferences.setMockInitialValues({});
      final preferences = await SharedPreferences.getInstance();
      await _sweep(
        tester,
        'WeightPage',
        _sizes,
        () => _wrapOnboarding(const WeightPage(), AppRoutes.setupWeight, preferences),
      );
    });

    testWidgets('HeightPage', (tester) async {
      SharedPreferences.setMockInitialValues({});
      final preferences = await SharedPreferences.getInstance();
      await _sweep(
        tester,
        'HeightPage',
        _sizes,
        () => _wrapOnboarding(const HeightPage(), AppRoutes.setupHeight, preferences),
      );
    });

    testWidgets('EquipmentPage', (tester) async {
      SharedPreferences.setMockInitialValues({});
      final preferences = await SharedPreferences.getInstance();
      await _sweep(
        tester,
        'EquipmentPage',
        _sizes,
        () => _wrapOnboarding(const EquipmentPage(), AppRoutes.setupEquipment, preferences),
      );
    });

    testWidgets('PhysicalActivityPage', (tester) async {
      SharedPreferences.setMockInitialValues({});
      final preferences = await SharedPreferences.getInstance();
      await _sweep(
        tester,
        'PhysicalActivityPage',
        _sizes,
        () => _wrapOnboarding(const PhysicalActivityPage(), AppRoutes.setupPhysical, preferences),
      );
    });

    testWidgets('TimeAvailabilityPage', (tester) async {
      SharedPreferences.setMockInitialValues({});
      final preferences = await SharedPreferences.getInstance();
      await _sweep(
        tester,
        'TimeAvailabilityPage',
        _sizes,
        () => _wrapOnboarding(const TimeAvailabilityPage(), AppRoutes.setupTime, preferences),
      );
    });

    testWidgets('SetupIntroPage', (tester) async {
      SharedPreferences.setMockInitialValues({});
      final preferences = await SharedPreferences.getInstance();
      await _sweep(
        tester,
        'SetupIntroPage',
        _sizes,
        () => _wrapOnboarding(const SetupIntroPage(), AppRoutes.setup, preferences),
      );
    });
  });

  group('Static content screens', () {
    testWidgets('PrivacyPage', (tester) async {
      SharedPreferences.setMockInitialValues({});
      final preferences = await SharedPreferences.getInstance();
      await _sweep(
        tester,
        'PrivacyPage',
        _sizes,
        () => _wrapOnboarding(const PrivacyPage(), AppRoutes.privacy, preferences),
      );
    });

    testWidgets('LegalDocumentPage (privacy)', (tester) async {
      SharedPreferences.setMockInitialValues({});
      final preferences = await SharedPreferences.getInstance();
      await _sweep(
        tester,
        'LegalDocumentPage',
        _sizes,
        () => _wrapOnboarding(
          const LegalDocumentPage(type: LegalDocumentType.privacyPolicy),
          AppRoutes.privacyPolicy,
          preferences,
        ),
      );
    });
  });

  group('Landscape sweep — phone-representative screens', () {
    testWidgets('LoginPage in landscape', (tester) async {
      SharedPreferences.setMockInitialValues({});
      final preferences = await SharedPreferences.getInstance();
      await _sweep(tester, 'LoginPage (landscape)', _landscapeSizes, () {
        return ProviderScope(
          overrides: [sharedPreferencesProvider.overrideWithValue(preferences)],
          child: _wrapSimple(const LoginPage(showPasswordResetSuccess: false)),
        );
      });
    });

    testWidgets('GoalPage in landscape', (tester) async {
      SharedPreferences.setMockInitialValues({});
      final preferences = await SharedPreferences.getInstance();
      await _sweep(
        tester,
        'GoalPage (landscape)',
        _landscapeSizes,
        () => _wrapOnboarding(const GoalPage(), AppRoutes.setupGoal, preferences),
      );
    });
  });
}
