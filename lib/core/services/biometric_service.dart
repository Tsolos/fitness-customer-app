import 'package:local_auth/local_auth.dart';

import '../error/exceptions.dart';

/// Thin wrapper around `local_auth` so the rest of the app never touches
/// the plugin directly (easier to fake in tests, easier to swap later).
class BiometricService {
  BiometricService({LocalAuthentication? localAuth}) : _localAuth = localAuth ?? LocalAuthentication();

  final LocalAuthentication _localAuth;

  Future<bool> get isDeviceSupported async {
    try {
      final canCheck = await _localAuth.canCheckBiometrics;
      final isSupported = await _localAuth.isDeviceSupported();
      return canCheck && isSupported;
    } catch (_) {
      return false;
    }
  }

  Future<List<BiometricType>> get availableBiometrics => _localAuth.getAvailableBiometrics();

  /// Prompts the OS biometric/PIN dialog. Returns true if the user was
  /// authenticated. Throws [BiometricException] on plugin-level errors.
  Future<bool> authenticate({String reason = 'Επιβεβαιώστε την ταυτότητά σας για σύνδεση'}) async {
    try {
      return await _localAuth.authenticate(
        localizedReason: reason,
        options: const AuthenticationOptions(
          biometricOnly: false,
          stickyAuth: true,
          useErrorDialogs: true,
        ),
      );
    } catch (e) {
      throw BiometricException(message: 'Η βιομετρική επαλήθευση απέτυχε: $e');
    }
  }
}
