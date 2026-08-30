import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/providers/core_providers.dart';
import '../../../../core/services/google_auth_service.dart';
import '../../data/datasources/auth_local_data_source.dart';
import '../../data/datasources/auth_remote_data_source.dart';
import '../../data/repositories/auth_repository_impl.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/usecases/biometric_login_usecase.dart';
import '../../domain/usecases/google_login_usecase.dart';
import '../../domain/usecases/login_usecase.dart';
import '../../domain/usecases/logout_usecase.dart';
import '../../domain/usecases/register_usecase.dart';
import '../../domain/usecases/toggle_biometric_usecase.dart';

part 'auth_providers.g.dart';

@riverpod
AuthRemoteDataSource authRemoteDataSource(Ref ref) {
  return AuthRemoteDataSourceImpl(ref.watch(dioProvider));
}

@riverpod
AuthLocalDataSource authLocalDataSource(Ref ref) {
  return AuthLocalDataSource(
    storageService: ref.watch(secureStorageServiceProvider),
    biometricService: ref.watch(biometricServiceProvider),
  );
}

@Riverpod(keepAlive: true)
AuthRepository authRepository(Ref ref) {
  return AuthRepositoryImpl(
    remoteDataSource: ref.watch(authRemoteDataSourceProvider),
    localDataSource: ref.watch(authLocalDataSourceProvider),
    networkInfo: ref.watch(networkInfoProvider),
    googleAuthService: ref.watch(googleAuthServiceProvider),
  );
}

@riverpod
LoginUseCase loginUseCase(Ref ref) => LoginUseCase(ref.watch(authRepositoryProvider));

@riverpod
GoogleLoginUseCase googleLoginUseCase(Ref ref) => GoogleLoginUseCase(ref.watch(authRepositoryProvider));

@riverpod
BiometricLoginUseCase biometricLoginUseCase(Ref ref) => BiometricLoginUseCase(ref.watch(authRepositoryProvider));

@riverpod
LogoutUseCase logoutUseCase(Ref ref) => LogoutUseCase(ref.watch(authRepositoryProvider));

@riverpod
RegisterUseCase registerUseCase(Ref ref) => RegisterUseCase(ref.watch(authRepositoryProvider));

@riverpod
ToggleBiometricUseCase toggleBiometricUseCase(Ref ref) => ToggleBiometricUseCase(ref.watch(authRepositoryProvider));

/// Whether the login screen should show the "sign in with fingerprint"
/// shortcut: the device supports it, the user opted in, and there are
/// remembered credentials to replay after the biometric check.
@riverpod
Future<bool> canUseBiometricLogin(Ref ref) async {
  final repository = ref.watch(authRepositoryProvider);
  final results = await Future.wait([
    repository.isBiometricAvailable(),
    repository.isBiometricEnabled(),
    repository.hasRememberedCredentials(),
  ]);
  return results.every((available) => available);
}

/// The logged-in customer's id (decoded from the JWT at login time). Every
/// Guests-controller endpoint is scoped by this id.
@riverpod
Future<String> currentCustomerId(Ref ref) async {
  final id = await ref.watch(authRepositoryProvider).getCachedCustomerId();
  if (id == null) {
    throw StateError('No cached customerId — the user is not logged in.');
  }
  return id;
}

@riverpod
Future<bool> biometricDeviceSupported(Ref ref) => ref.watch(authRepositoryProvider).isBiometricAvailable();

@riverpod
Future<bool> biometricEnabled(Ref ref) => ref.watch(authRepositoryProvider).isBiometricEnabled();

@riverpod
Future<({String email, String password})?> rememberedCredentials(Ref ref) async {
  final hasRemembered = await ref.watch(authRepositoryProvider).hasRememberedCredentials();
  if (!hasRemembered) return null;
  final localDataSource = ref.watch(authLocalDataSourceProvider);
  return localDataSource.getRememberedCredentials();
}

/// Web only: fires with the account's tokens whenever the rendered
/// `GoogleSignInButton` completes a sign-in. `LoginScreen` listens to this
/// to drive `AuthController.completeGoogleLogin`.
@riverpod
Stream<GoogleTokens?> googleWebTokens(Ref ref) {
  final service = ref.watch(googleAuthServiceProvider);
  return service.onAccountChanged.asyncMap((account) {
    if (account == null) return Future.value(null);
    return service.tokensFor(account);
  });
}
