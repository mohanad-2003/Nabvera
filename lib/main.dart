import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'core/localization/generated/app_localizations.dart';
import 'core/localization/locale_controller.dart';
import 'core/routing/app_router.dart';
import 'core/storage/preferences_service.dart';
import 'core/theme/app_colors.dart';
import 'core/theme/app_theme.dart';
import 'core/theme/theme_controller.dart';
import 'core/web/web_install_banner.dart';
import 'firebase_options.dart';

void main() {
  // Everything (including the error handler wiring below) must run inside
  // this same zone — an error raised in a different zone than the one
  // runApp was called in is invisible to FlutterError.onError/runZonedGuarded.
  runZonedGuarded(
    () async {
      WidgetsFlutterBinding.ensureInitialized();
      // Lets every screen's own background (PremiumScaffold's gradient) draw
      // all the way to the physical edges instead of stopping short of the
      // system status/navigation bars — without this, those bars keep the
      // OS's own default scrim color (a flat gray/black band that never
      // moves, since it's drawn outside the Flutter view entirely), which
      // reads as the app's background abruptly cutting off partway down the
      // screen. The actual bar color itself is still set reactively per
      // theme in MyApp.build below (see the AnnotatedRegion there) — this
      // call only makes the system bars capable of being transparent.
      await SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );

      // Crashlytics has no web implementation at all — even touching
      // `FirebaseCrashlytics.instance` throws on web, so every use of it
      // (here and in the runZonedGuarded handler below) is skipped there.
      if (!kIsWeb) {
        // Only report crashes from real (release/profile) runs — a `flutter
        // run` debug session crashing on a work-in-progress change shouldn't
        // pollute the Crashlytics dashboard used to track real user impact.
        await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(
          !kDebugMode,
        );
        FlutterError.onError =
            FirebaseCrashlytics.instance.recordFlutterFatalError;
        PlatformDispatcher.instance.onError = (error, stack) {
          FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
          return true;
        };
      }

      final sharedPreferences = await SharedPreferences.getInstance();

      runApp(
        ProviderScope(
          overrides: [
            sharedPreferencesProvider.overrideWithValue(sharedPreferences),
          ],
          child: const MyApp(),
        ),
      );
    },
    (error, stack) {
      if (kIsWeb) return;
      FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
    },
  );
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(appRouterProvider);
    final themeMode = ref.watch(themeControllerProvider);
    final locale = ref.watch(localeControllerProvider);

    // Resolves the same light/dark decision MaterialApp.router makes
    // internally from `themeMode` (including the ThemeMode.system case),
    // so the system bars' icon color always matches whichever theme is
    // actually showing rather than only ever assuming light mode.
    final isDark = switch (themeMode) {
      ThemeMode.dark => true,
      ThemeMode.light => false,
      ThemeMode.system =>
        MediaQuery.platformBrightnessOf(context) == Brightness.dark,
    };

    return AnnotatedRegion<SystemUiOverlayStyle>(
      // Transparent, not a fixed color: lets each screen's own background
      // (PremiumScaffold's gradient) show through the status/navigation
      // bars instead of the OS's own default scrim — see main()'s
      // setEnabledSystemUIMode call, which is what makes that possible.
      value: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: isDark ? Brightness.light : Brightness.dark,
        statusBarBrightness: isDark ? Brightness.dark : Brightness.light,
        systemNavigationBarColor: Colors.transparent,
        systemNavigationBarDividerColor: Colors.transparent,
        systemNavigationBarIconBrightness:
            isDark ? Brightness.light : Brightness.dark,
      ),
      child: _FixedWidthOnWideWeb(
        isDark: isDark,
        child: ScreenUtilInit(
          designSize: const Size(393, 852),
          minTextAdapt: true,
          splitScreenMode: true,
          builder: (context, child) {
            return MaterialApp.router(
              debugShowCheckedModeBanner: false,
              routerConfig: router,
              themeMode: themeMode,
              theme: AppTheme.light(),
              darkTheme: AppTheme.dark(),
              locale: locale,
              supportedLocales: supportedLocales,
              localizationsDelegates: AppLocalizations.localizationsDelegates,
              // A global overlay (not per-page) so the "install as an app"
              // banner survives navigation instead of remounting — and
              // capturing/losing the one-time `beforeinstallprompt` event —
              // every time the route changes.
              builder: (context, routedChild) {
                return Stack(
                  children: [
                    if (routedChild != null) routedChild,
                    if (kIsWeb) const WebInstallBanner(),
                  ],
                );
              },
            );
          },
        ),
      ),
    );
  }
}

/// Every screen was built for a phone-width viewport (see
/// `ScreenUtilInit`'s `designSize` above) — stretched across a full desktop
/// browser window, `.w`/`.h`/`.sp` sizing blows up proportionally and every
/// element reads as "a phone screen zoomed in" rather than an app designed
/// for that space. A wide web viewport instead gets a centered, phone-width
/// column with the real window's excess width letterboxed on either side —
/// the same treatment most mobile-first web apps (Instagram, X/Twitter,
/// WhatsApp Web) use, rather than a from-scratch desktop layout. The
/// letterbox itself uses the app's own brand backdrop tones (not a flat
/// black) so it still reads as intentional in both light and dark theme.
class _FixedWidthOnWideWeb extends StatelessWidget {
  const _FixedWidthOnWideWeb({required this.child, required this.isDark});

  final Widget child;
  final bool isDark;

  static const double _maxContentWidth = 520;

  @override
  Widget build(BuildContext context) {
    if (!kIsWeb) return child;

    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth <= _maxContentWidth) return child;

        final mediaQuery = MediaQuery.of(context);
        return ColoredBox(
          color:
              isDark ? AppColors.midnight : AppColors.lightSurfaceVariant,
          child: Center(
            child: SizedBox(
              width: _maxContentWidth,
              height: constraints.maxHeight,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: isDark ? 0.45 : 0.16),
                      blurRadius: 40,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                // Everything below (including ScreenUtilInit's own scale
                // calculation) reads its viewport from MediaQuery, not the
                // raw browser window — overriding it here is what actually
                // makes the rest of the app behave as if it were running on
                // a `_maxContentWidth`-wide phone, with no per-page changes.
                child: MediaQuery(
                  data: mediaQuery.copyWith(
                    size: Size(_maxContentWidth, constraints.maxHeight),
                  ),
                  child: child,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
