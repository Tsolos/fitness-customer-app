import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/appointment.dart';
import '../repositories/contracts_repository.dart';

class RescheduleAppointmentUseCase {
  const RescheduleAppointmentUseCase(this._repository);

  final ContractsRepository _repository;

  Future<Either<Failure, Appointment>> call({
    required Appointment appointment,
    required DateTime newDateTime,
  }) async {
    if (!appointment.canModify) {
      return const Left(ValidationFailure('Δεν μπορείτε να αλλάξετε ραντεβού που έχει ήδη περάσει ή ακυρωθεί.'));
    }
    if (newDateTime.isBefore(DateTime.now())) {
      return const Left(ValidationFailure('Επιλέξτε μια μελλοντική ημερομηνία/ώρα.'));
    }
    return _repository.rescheduleAppointment(appointmentId: appointment.id, newDateTime: newDateTime);
  }
}
