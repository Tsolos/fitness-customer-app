import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/auth_tokens.dart';
import '../repositories/auth_repository.dart';

class GoogleLoginUseCase {
  const GoogleLoginUseCase(this._repository);

  final AuthRepository _repository;

  Future<Either<Failure, AuthTokens>> call({required String gymId}) {
    return _repository.loginWithGoogle(gymId: gymId);
  }

  /// Web path: exchanges a token already obtained via `GoogleSignInButton`.
  Future<Either<Failure, AuthTokens>> completeWithToken({
    required String gymId,
    String? idToken,
    String? accessToken,
  }) {
    return _repository.completeGoogleLogin(gymId: gymId, idToken: idToken, accessToken: accessToken);
  }
}
