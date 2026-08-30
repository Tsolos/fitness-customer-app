import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/auth_tokens.dart';
import '../repositories/auth_repository.dart';

class BiometricLoginUseCase {
  const BiometricLoginUseCase(this._repository);

  final AuthRepository _repository;

  Future<Either<Failure, AuthTokens>> call() => _repository.loginWithBiometrics();
}
