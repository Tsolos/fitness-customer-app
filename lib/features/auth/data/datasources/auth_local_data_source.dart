import '../../../../core/services/biometric_service.dart';
import '../../../../core/storage/secure_storage_service.dart';

class AuthLocalDataSource {
  AuthLocalDataSource({
    required this._storageService,
    required this._biometricService,
  });

  final SecureStorageService _storageService;
  final BiometricService _biometricService;

  Future<void> persistTokens({
    required String accessToken,
    required String customerId,
  }) {
    return _storageService.saveTokens(
      accessToken: accessToken,
      customerId: customerId,
    );
  }

  Future<String?> getAccessToken() => _storageService.getAccessToken();

  Future<String?> getCustomerId() => _storageService.getCustomerId();

  Future<void> clearTokens() => _storageService.clearTokens();

  Future<void> rememberCredentials({
    required String email,
    required String password,
  }) {
    return _storageService.saveRememberedCredentials(
      email: email,
      password: password,
    );
  }

  Future<void> forgetCredentials() =>
      _storageService.clearRememberedCredentials();

  Future<({String email, String password})?> getRememberedCredentials() {
    return _storageService.getRememberedCredentials();
  }

  Future<bool> hasRememberedCredentials() async {
    final creds = await _storageService.getRememberedCredentials();
    return creds != null;
  }

  Future<bool> isBiometricDeviceSupported() =>
      _biometricService.isDeviceSupported;

  Future<bool> authenticateWithBiometrics() => _biometricService.authenticate();

  Future<void> setBiometricEnabled(bool enabled) =>
      _storageService.setBiometricEnabled(enabled);

  Future<bool> isBiometricEnabled() => _storageService.isBiometricEnabled();

  Future<void> clearAll() => _storageService.clearAll();
}
