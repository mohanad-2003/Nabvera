import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'preferences_service.g.dart';

/// Thin wrapper around [SharedPreferences] so the rest of the app never
/// touches the plugin directly — swapping storage backends later only
/// means editing this file.
class PreferencesService {
  PreferencesService(this._prefs);

  final SharedPreferences _prefs;

  static const _themeModeKey = 'app.theme_mode';
  static const _localeKey = 'app.locale';
  static const _onboardingCompleteKey = 'app.onboarding_complete';
  static const _biometricEnabledKey = 'app.biometric_enabled';
  static const _rememberedEmailKey = 'app.remembered_email';

  String? get themeMode => _prefs.getString(_themeModeKey);
  Future<void> setThemeMode(String value) =>
      _prefs.setString(_themeModeKey, value);

  String? get locale => _prefs.getString(_localeKey);
  Future<void> setLocale(String value) => _prefs.setString(_localeKey, value);

  bool get onboardingComplete =>
      _prefs.getBool(_onboardingCompleteKey) ?? false;
  Future<void> setOnboardingComplete(bool value) =>
      _prefs.setBool(_onboardingCompleteKey, value);

  /// Whether the user opted into the biometric app-lock after signing up.
  /// Only ever set to true from a flow that already confirmed the device
  /// supports local authentication — see `BiometricService.isAvailable`.
  bool get biometricEnabled => _prefs.getBool(_biometricEnabledKey) ?? false;
  Future<void> setBiometricEnabled(bool value) =>
      _prefs.setBool(_biometricEnabledKey, value);

  /// The last email entered with "Remember me" checked, so the login field
  /// can be prefilled next time — mobile Firebase Auth sessions already
  /// persist on their own, so this is the only meaningful thing "remember
  /// me" can offer here.
  String? get rememberedEmail => _prefs.getString(_rememberedEmailKey);
  Future<void> setRememberedEmail(String? value) =>
      value == null || value.isEmpty
          ? _prefs.remove(_rememberedEmailKey)
          : _prefs.setString(_rememberedEmailKey, value);
}

/// Overridden in [main] with the resolved [SharedPreferences] instance
/// before the app is run — kept as a throwing default so misuse fails fast.
@Riverpod(keepAlive: true)
SharedPreferences sharedPreferences(Ref ref) {
  throw UnimplementedError(
    'sharedPreferencesProvider must be overridden in main() before use.',
  );
}

@Riverpod(keepAlive: true)
PreferencesService preferencesService(Ref ref) {
  return PreferencesService(ref.watch(sharedPreferencesProvider));
}
