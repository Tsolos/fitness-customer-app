import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/appointment.dart';
import '../entities/contract.dart';
import '../repositories/contracts_repository.dart';

class CreateAppointmentUseCase {
  const CreateAppointmentUseCase(this._repository);

  final ContractsRepository _repository;

  Future<Either<Failure, Appointment>> call({
    required String customerId,
    required Contract contract,
    required DateTime dateTime,
  }) async {
    if (contract.remainingSessions <= 0) {
      return const Left(ValidationFailure('Δεν έχετε διαθέσιμα ραντεβού σε αυτό το πακέτο.'));
    }
    if (dateTime.isBefore(DateTime.now())) {
      return const Left(ValidationFailure('Επιλέξτε μια μελλοντική ημερομηνία/ώρα.'));
    }
    return _repository.createAppointment(customerId: customerId, contractId: contract.id, dateTime: dateTime);
  }
}
