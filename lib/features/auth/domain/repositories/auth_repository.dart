import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/auth_tokens.dart';

abstract class AuthRepository {
  /// Calls the API, and on success stores the tokens. If [rememberMe] is
  /// true, the credentials are also persisted (encrypted) so the login
  /// form can be pre-filled / auto-submitted next time.
  Future<Either<Failure, AuthTokens>> login({
    required String email,
    required String password,
    required bool rememberMe,
  });

  /// Re-authenticates using the credentials saved from a previous
  /// "remember me" login, after a successful biometric check.
  Future<Either<Failure, AuthTokens>> loginWithBiometrics();

  /// Mobile/desktop: opens the Google account picker, then exchanges the
  /// resulting token for our own JWT. Never resolves on web — use
  /// [completeGoogleLogin] there instead (see `GoogleAuthService`'s doc
  /// comments for why).
  Future<Either<Failure, AuthTokens>> loginWithGoogle({required String gymId});

  /// Web: exchanges a token already obtained via the rendered Google
  /// button (`GoogleSignInButton` + `GoogleAuthService.onAccountChanged`)
  /// for our own JWT. `AuthController.GoogleLogin` verifies whichever of
  /// [idToken] / [accessToken] is non-null and matches it to a `Customer`
  /// in [gymId].
  Future<Either<Failure, AuthTokens>> completeGoogleLogin({
    required String gymId,
    String? idToken,
    String? accessToken,
  });

  /// Starts self-service registration. The backend matches [email] against
  /// `Customer` rows across every gym (not just a selected one) and, if
  /// found, emails a confirmation link before the account becomes usable —
  /// there is no session to store here, just a message to show the user.
  Future<Either<Failure, String>> register({
    required String email,
    required String password,
  });

  Future<Either<Failure, Unit>> logout();

  Future<bool> hasRememberedCredentials();

  Future<bool> isBiometricAvailable();

  Future<bool> isBiometricEnabled();

  Future<Either<Failure, Unit>> setBiometricEnabled(bool enabled);

  Future<String?> getCachedAccessToken();

  Future<String?> getCachedCustomerId();
}
