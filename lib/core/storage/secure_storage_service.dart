import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constants/storage_keys.dart';

/// Wraps [FlutterSecureStorage] (tokens, remembered password) and
/// [SharedPreferences] (non-sensitive flags) behind one API.
class SecureStorageService {
  SecureStorageService({FlutterSecureStorage? secureStorage})
      : _secureStorage = secureStorage ??
            const FlutterSecureStorage(
              aOptions: AndroidOptions(encryptedSharedPreferences: true),
            );

  final FlutterSecureStorage _secureStorage;

  // --- Tokens ---
  Future<void> saveTokens({required String accessToken, required String customerId}) async {
    await _secureStorage.write(key: StorageKeys.accessToken, value: accessToken);
    await _secureStorage.write(key: StorageKeys.cachedCustomerId, value: customerId);
  }

  Future<String?> getAccessToken() => _secureStorage.read(key: StorageKeys.accessToken);

  Future<String?> getCustomerId() => _secureStorage.read(key: StorageKeys.cachedCustomerId);

  Future<void> clearTokens() async {
    await _secureStorage.delete(key: StorageKeys.accessToken);
    await _secureStorage.delete(key: StorageKeys.cachedCustomerId);
  }

  // --- Remember me credentials ---
  Future<void> saveRememberedCredentials({required String email, required String password}) async {
    await _secureStorage.write(key: StorageKeys.rememberedEmail, value: email);
    await _secureStorage.write(key: StorageKeys.rememberedPassword, value: password);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(StorageKeys.rememberMeEnabled, true);
  }

  Future<({String email, String password})?> getRememberedCredentials() async {
    final email = await _secureStorage.read(key: StorageKeys.rememberedEmail);
    final password = await _secureStorage.read(key: StorageKeys.rememberedPassword);
    if (email == null || password == null) return null;
    return (email: email, password: password);
  }

  Future<void> clearRememberedCredentials() async {
    await _secureStorage.delete(key: StorageKeys.rememberedEmail);
    await _secureStorage.delete(key: StorageKeys.rememberedPassword);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(StorageKeys.rememberMeEnabled, false);
  }

  Future<bool> isRememberMeEnabled() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(StorageKeys.rememberMeEnabled) ?? false;
  }

  // --- Biometric opt-in ---
  Future<void> setBiometricEnabled(bool enabled) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(StorageKeys.biometricEnabled, enabled);
  }

  Future<bool> isBiometricEnabled() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(StorageKeys.biometricEnabled) ?? false;
  }

  // --- Selected gym (for the multi-company "pick your gym" flow) ---
  Future<void> saveSelectedGym({required String id, required String title}) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(StorageKeys.selectedGymId, id);
    await prefs.setString(StorageKeys.selectedGymTitle, title);
  }

  Future<({String id, String title})?> getSelectedGym() async {
    final prefs = await SharedPreferences.getInstance();
    final id = prefs.getString(StorageKeys.selectedGymId);
    final title = prefs.getString(StorageKeys.selectedGymTitle);
    if (id == null || title == null) return null;
    return (id: id, title: title);
  }

  Future<void> clearAll() async {
    await _secureStorage.deleteAll();
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}
