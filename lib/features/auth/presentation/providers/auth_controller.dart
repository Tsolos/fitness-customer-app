import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/providers/session_events.dart';
import 'auth_providers.dart';
import 'auth_state.dart';

part 'auth_controller.g.dart';

@Riverpod(keepAlive: true)
class AuthController extends _$AuthController {
  @override
  AuthState build() {
    ref.listen<int>(sessionExpiredProvider, (previous, next) {
      if (previous != null && next != previous) {
        _forceLogout();
      }
    });
    _restoreSession();
    return const AuthState.unknown();
  }

  Future<void> _restoreSession() async {
    try {
      final token = await ref.read(authRepositoryProvider).getCachedAccessToken();
      state = token != null && token.isNotEmpty ? const AuthState.authenticated() : const AuthState.unauthenticated();
    } catch (_) {
      // If reading the cached token fails for any reason, fail safe to
      // "unauthenticated" rather than leaving the app stuck on `unknown`
      // (which would strand the router before it ever redirects).
      state = const AuthState.unauthenticated();
    }
  }

  Future<bool> login({
    required String email,
    required String password,
    required bool rememberMe,
  }) async {
    state = const AuthState.unknown();
    final result = await ref.read(loginUseCaseProvider).call(
          email: email,
          password: password,
          rememberMe: rememberMe,
        );
    return result.fold(
      (failure) {
        state = AuthState.unauthenticated(failure.message);
        return false;
      },
      (_) {
        state = const AuthState.authenticated();
        return true;
      },
    );
  }

  Future<bool> loginWithGoogle({required String gymId}) async {
    state = const AuthState.unknown();
    final result = await ref.read(googleLoginUseCaseProvider).call(gymId: gymId);
    return result.fold(
      (failure) {
        state = AuthState.unauthenticated(failure.message);
        return false;
      },
      (_) {
        state = const AuthState.authenticated();
        return true;
      },
    );
  }

  /// Web: called once the rendered Google button + `GoogleAuthService.onAccountChanged`
  /// hand back a token (see `LoginScreen`).
  Future<bool> completeGoogleLogin({required String gymId, String? idToken, String? accessToken}) async {
    state = const AuthState.unknown();
    final result = await ref.read(googleLoginUseCaseProvider).completeWithToken(
          gymId: gymId,
          idToken: idToken,
          accessToken: accessToken,
        );
    return result.fold(
      (failure) {
        state = AuthState.unauthenticated(failure.message);
        return false;
      },
      (_) {
        state = const AuthState.authenticated();
        return true;
      },
    );
  }

  Future<bool> loginWithBiometrics() async {
    state = const AuthState.unknown();
    final result = await ref.read(biometricLoginUseCaseProvider).call();
    return result.fold(
      (failure) {
        state = AuthState.unauthenticated(failure.message);
        return false;
      },
      (_) {
        state = const AuthState.authenticated();
        return true;
      },
    );
  }

  Future<void> logout() async {
    await ref.read(logoutUseCaseProvider).call();
    state = const AuthState.unauthenticated();
  }

  Future<void> _forceLogout() async {
    await ref.read(logoutUseCaseProvider).call();
    state = const AuthState.unauthenticated('Η σύνδεσή σας έληξε. Παρακαλώ συνδεθείτε ξανά.');
  }
}
