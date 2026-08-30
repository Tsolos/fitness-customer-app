import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/appointment.dart';
import '../entities/appointment_slot.dart';
import '../entities/contract.dart';

abstract class ContractsRepository {
  Future<Either<Failure, List<Contract>>> getMyContracts(String customerId);

  Future<Either<Failure, List<AppointmentSlot>>> getSlotAvailability({
    required String customerId,
    required String branchId,
    required DateTime startDate,
    required int days,
  });

  Future<Either<Failure, Appointment>> createAppointment({
    required String customerId,
    required String contractId,
    required DateTime dateTime,
  });

  Future<Either<Failure, Appointment>> rescheduleAppointment({
    required String appointmentId,
    required DateTime newDateTime,
  });

  Future<Either<Failure, Unit>> cancelAppointment(String appointmentId);

  Future<Either<Failure, Unit>> restoreAppointment(String appointmentId);
}
