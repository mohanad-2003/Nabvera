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
import 'core/theme/app_theme.dart';
import 'core/theme/theme_controller.dart';
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
    (error, stack) =>
        FirebaseCrashlytics.instance.recordError(error, stack, fatal: true),
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
          );
        },
      ),
    );
  }
}
