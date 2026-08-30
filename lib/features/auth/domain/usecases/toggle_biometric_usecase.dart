import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../repositories/auth_repository.dart';

class ToggleBiometricUseCase {
  const ToggleBiometricUseCase(this._repository);

  final AuthRepository _repository;

  Future<Either<Failure, Unit>> call(bool enabled) => _repository.setBiometricEnabled(enabled);
}
