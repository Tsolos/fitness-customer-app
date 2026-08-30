import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/appointment.dart';
import '../repositories/contracts_repository.dart';

class RestoreAppointmentUseCase {
  const RestoreAppointmentUseCase(this._repository);

  final ContractsRepository _repository;

  Future<Either<Failure, Unit>> call(Appointment appointment) async {
    if (!appointment.canRestore) {
      return const Left(ValidationFailure('Μόνο πρόσφατα ακυρωμένα, μελλοντικά ραντεβού μπορούν να επαναφερθούν.'));
    }
    return _repository.restoreAppointment(appointment.id);
  }
}
