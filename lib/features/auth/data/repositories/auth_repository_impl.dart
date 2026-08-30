import 'package:dartz/dartz.dart';

import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/network/network_info.dart';
import '../../../../core/services/google_auth_service.dart';
import '../../domain/entities/auth_tokens.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_local_data_source.dart';
import '../datasources/auth_remote_data_source.dart';
import '../models/google_login_request_model.dart';
import '../models/login_request_model.dart';
import '../models/register_request_model.dart';

class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl({
    required this._remoteDataSource,
    required this._localDataSource,
    required this._networkInfo,
    required this._googleAuthService,
  });

  final AuthRemoteDataSource _remoteDataSource;
  final AuthLocalDataSource _localDataSource;
  final NetworkInfo _networkInfo;
  final GoogleAuthService _googleAuthService;

  @override
  Future<Either<Failure, AuthTokens>> login({
    required String email,
    required String password,
    required bool rememberMe,
  }) async {
    if (!await _networkInfo.isConnected) {
      return const Left(NetworkFailure());
    }
    try {
      final response = await _remoteDataSource.login(
        LoginRequestModel(email: email, password: password),
      );
      final tokens = response.toEntity();
      await _localDataSource.persistTokens(
        accessToken: tokens.accessToken,
        customerId: tokens.customerId,
      );

      if (rememberMe) {
        await _localDataSource.rememberCredentials(
          email: email,
          password: password,
        );
      } else {
        await _localDataSource.forgetCredentials();
      }

      return Right(tokens);
    } on UnauthorizedException catch (e) {
      return Left(UnauthorizedFailure(e.message));
    } on ValidationException catch (e) {
      return Left(ValidationFailure(e.message, fieldErrors: e.fieldErrors));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message, statusCode: e.statusCode));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } on FormatException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (_) {
      return const Left(UnknownFailure());
    }
  }

  @override
  Future<Either<Failure, AuthTokens>> loginWithBiometrics() async {
    final deviceSupported = await _localDataSource.isBiometricDeviceSupported();
    final biometricEnabled = await _localDataSource.isBiometricEnabled();
    if (!deviceSupported || !biometricEnabled) {
      return const Left(
        BiometricFailure(
          'Η βιομετρική σύνδεση δεν είναι ενεργοποιημένη σε αυτή τη συσκευή.',
        ),
      );
    }

    final remembered = await _localDataSource.getRememberedCredentials();
    if (remembered == null) {
      return const Left(
        BiometricFailure(
          'Δεν υπάρχουν αποθηκευμένα διαπιστευτήρια. Συνδεθείτε πρώτα κανονικά.',
        ),
      );
    }

    try {
      final authenticated = await _localDataSource.authenticateWithBiometrics();
      if (!authenticated) {
        return const Left(BiometricFailure('Η βιομετρική επαλήθευση απέτυχε.'));
      }
    } on BiometricException catch (e) {
      return Left(BiometricFailure(e.message));
    }

    return login(
      email: remembered.email,
      password: remembered.password,
      rememberMe: true,
    );
  }

  @override
  Future<Either<Failure, AuthTokens>> loginWithGoogle({
    required String gymId,
  }) async {
    if (!await _networkInfo.isConnected) {
      return const Left(NetworkFailure());
    }

    final GoogleTokens? tokens;
    try {
      tokens = await _googleAuthService.signIn();
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    }
    if (tokens == null) {
      // User dismissed the Google account picker — not an error.
      return const Left(ValidationFailure('Η σύνδεση με Google ακυρώθηκε.'));
    }

    return completeGoogleLogin(
      gymId: gymId,
      idToken: tokens.idToken,
      accessToken: tokens.accessToken,
    );
  }

  @override
  Future<Either<Failure, AuthTokens>> completeGoogleLogin({
    required String gymId,
    String? idToken,
    String? accessToken,
  }) async {
    if (!await _networkInfo.isConnected) {
      return const Left(NetworkFailure());
    }
    try {
      final response = await _remoteDataSource.googleLogin(
        GoogleLoginRequestModel(
          companyId: gymId,
          idToken: idToken,
          accessToken: accessToken,
        ),
      );
      final tokens = response.toEntity();
      await _localDataSource.persistTokens(
        accessToken: tokens.accessToken,
        customerId: tokens.customerId,
      );
      return Right(tokens);
    } on UnauthorizedException catch (e) {
      return Left(UnauthorizedFailure(e.message));
    } on ValidationException catch (e) {
      return Left(ValidationFailure(e.message, fieldErrors: e.fieldErrors));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message, statusCode: e.statusCode));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } on FormatException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (_) {
      return const Left(UnknownFailure());
    }
  }

  @override
  Future<Either<Failure, String>> register({
    required String email,
    required String password,
  }) async {
    if (!await _networkInfo.isConnected) {
      return const Left(NetworkFailure());
    }
    try {
      final message = await _remoteDataSource.register(
        RegisterRequestModel(email: email, password: password),
      );
      return Right(message);
    } on ValidationException catch (e) {
      return Left(ValidationFailure(e.message, fieldErrors: e.fieldErrors));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message, statusCode: e.statusCode));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } catch (_) {
      return const Left(UnknownFailure());
    }
  }

  @override
  Future<Either<Failure, Unit>> logout() async {
    // The API has no /auth/logout endpoint (JWTs just expire client-side),
    // so "logging out" is purely a local operation.
    await _localDataSource.clearTokens();
    try {
      await _googleAuthService.signOut();
    } catch (_) {
      // Best-effort: a stale Google session isn't worth failing logout over.
    }
    return const Right(unit);
  }

  @override
  Future<bool> hasRememberedCredentials() =>
      _localDataSource.hasRememberedCredentials();

  @override
  Future<bool> isBiometricAvailable() =>
      _localDataSource.isBiometricDeviceSupported();

  @override
  Future<bool> isBiometricEnabled() => _localDataSource.isBiometricEnabled();

  @override
  Future<Either<Failure, Unit>> setBiometricEnabled(bool enabled) async {
    if (enabled) {
      final supported = await _localDataSource.isBiometricDeviceSupported();
      if (!supported) {
        return const Left(
          BiometricFailure('Η συσκευή δεν υποστηρίζει βιομετρική επαλήθευση.'),
        );
      }
      final hasCreds = await _localDataSource.hasRememberedCredentials();
      if (!hasCreds) {
        return const Left(
          BiometricFailure(
            'Ενεργοποιήστε πρώτα την «Απομνημόνευση στοιχείων» με ένα login.',
          ),
        );
      }
    }
    await _localDataSource.setBiometricEnabled(enabled);
    return const Right(unit);
  }

  @override
  Future<String?> getCachedAccessToken() => _localDataSource.getAccessToken();

  @override
  Future<String?> getCachedCustomerId() => _localDataSource.getCustomerId();
}
