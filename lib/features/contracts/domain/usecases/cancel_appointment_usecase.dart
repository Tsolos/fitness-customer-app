import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/appointment.dart';
import '../repositories/contracts_repository.dart';

class CancelAppointmentUseCase {
  const CancelAppointmentUseCase(this._repository);

  final ContractsRepository _repository;

  Future<Either<Failure, Unit>> call(Appointment appointment) async {
    if (!appointment.canModify) {
      return const Left(ValidationFailure('Δεν μπορείτε να ακυρώσετε ραντεβού που έχει ήδη περάσει ή ακυρωθεί.'));
    }
    return _repository.cancelAppointment(appointment.id);
  }
}
