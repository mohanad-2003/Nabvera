import 'package:nabvera/core/storage/preferences_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('PreferencesService.analyticsEnabled', () {
    test('defaults to true (opt-out, not opt-in) on a fresh install', () async {
      SharedPreferences.setMockInitialValues({});
      final prefs = PreferencesService(await SharedPreferences.getInstance());
      expect(prefs.analyticsEnabled, isTrue);
    });

    test('persists false once the user opts out', () async {
      SharedPreferences.setMockInitialValues({});
      final prefs = PreferencesService(await SharedPreferences.getInstance());
      await prefs.setAnalyticsEnabled(false);
      expect(prefs.analyticsEnabled, isFalse);
    });

    test('persists true again if the user re-enables it', () async {
      SharedPreferences.setMockInitialValues({});
      final prefs = PreferencesService(await SharedPreferences.getInstance());
      await prefs.setAnalyticsEnabled(false);
      await prefs.setAnalyticsEnabled(true);
      expect(prefs.analyticsEnabled, isTrue);
    });

    test('reads a previously stored value back on a fresh instance', () async {
      SharedPreferences.setMockInitialValues({'app.analytics_enabled': false});
      final prefs = PreferencesService(await SharedPreferences.getInstance());
      expect(prefs.analyticsEnabled, isFalse);
    });
  });

  group('PreferencesService.notificationsEnabled', () {
    test('defaults to true (opt-out, not opt-in) on a fresh install', () async {
      SharedPreferences.setMockInitialValues({});
      final prefs = PreferencesService(await SharedPreferences.getInstance());
      expect(prefs.notificationsEnabled, isTrue);
    });

    test('persists false once the user turns it off', () async {
      SharedPreferences.setMockInitialValues({});
      final prefs = PreferencesService(await SharedPreferences.getInstance());
      await prefs.setNotificationsEnabled(false);
      expect(prefs.notificationsEnabled, isFalse);
    });

    test('reads a previously stored value back on a fresh instance', () async {
      SharedPreferences.setMockInitialValues({
        'app.notifications_enabled': false,
      });
      final prefs = PreferencesService(await SharedPreferences.getInstance());
      expect(prefs.notificationsEnabled, isFalse);
    });
  });
}
