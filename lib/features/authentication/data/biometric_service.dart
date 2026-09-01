import 'package:local_auth/local_auth.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'biometric_service.g.dart';

/// Thin wrapper around [LocalAuthentication] — the only place in the app
/// that talks to the platform biometric APIs directly. A screen must check
/// [isAvailable] before ever offering a "enable biometrics" option; there is
/// no reason to show that choice on a device/OS that can't back it.
class BiometricService {
  BiometricService(this._auth);

  final LocalAuthentication _auth;

  /// True only when the device has enrolled biometrics AND the platform
  /// actually supports local authentication — both checks are required,
  /// `canCheckBiometrics` alone can be true on hardware with nothing
  /// enrolled yet.
  Future<bool> isAvailable() async {
    try {
      final supported = await _auth.isDeviceSupported();
      final canCheck = await _auth.canCheckBiometrics;
      if (!supported || !canCheck) return false;
      final available = await _auth.getAvailableBiometrics();
      return available.isNotEmpty;
    } catch (_) {
      return false;
    }
  }

  /// Prompts the real OS biometric sheet. Returns false (never throws) on
  /// any failure, cancellation, or lockout — callers just show a plain
  /// "didn't work, try again" state, not an exception.
  Future<bool> authenticate(String reason) async {
    try {
      return await _auth.authenticate(
        localizedReason: reason,
        options: const AuthenticationOptions(
          biometricOnly: true,
          stickyAuth: true,
        ),
      );
    } catch (_) {
      return false;
    }
  }
}

@Riverpod(keepAlive: true)
BiometricService biometricService(Ref ref) {
  return BiometricService(LocalAuthentication());
}
