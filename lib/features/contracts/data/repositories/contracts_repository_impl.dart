import 'package:dartz/dartz.dart';

import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/network/network_info.dart';
import '../../domain/entities/appointment.dart';
import '../../domain/entities/appointment_slot.dart';
import '../../domain/entities/contract.dart';
import '../../domain/repositories/contracts_repository.dart';
import '../datasources/contracts_remote_data_source.dart';

class ContractsRepositoryImpl implements ContractsRepository {
  ContractsRepositoryImpl({
    required this._remoteDataSource,
    required this._networkInfo,
  });

  final ContractsRemoteDataSource _remoteDataSource;
  final NetworkInfo _networkInfo;

  Future<Either<Failure, T>> _guard<T>(Future<T> Function() action) async {
    if (!await _networkInfo.isConnected) {
      return const Left(NetworkFailure());
    }
    try {
      return Right(await action());
    } on UnauthorizedException catch (e) {
      return Left(UnauthorizedFailure(e.message));
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
  Future<Either<Failure, List<Contract>>> getMyContracts(String customerId) {
    return _guard(() async {
      final models = await _remoteDataSource.getGuestContracts(customerId);
      return models.map((m) => m.toEntity()).toList();
    });
  }

  @override
  Future<Either<Failure, List<AppointmentSlot>>> getSlotAvailability({
    required String customerId,
    required String branchId,
    required DateTime startDate,
    required int days,
  }) {
    return _guard(() async {
      final models = await _remoteDataSource.getSlotAvailability(
        customerId: customerId,
        branchId: branchId,
        startDate: startDate,
        days: days,
      );
      return models.map((m) => m.toEntity()).toList();
    });
  }

  @override
  Future<Either<Failure, Appointment>> createAppointment({
    required String customerId,
    required String contractId,
    required DateTime dateTime,
  }) {
    return _guard(() async {
      final model = await _remoteDataSource.addAppointment(
        customerId: customerId,
        contractId: contractId,
        dateTime: dateTime,
      );
      return model.toEntity(contractId: contractId);
    });
  }

  @override
  Future<Either<Failure, Appointment>> rescheduleAppointment({
    required String appointmentId,
    required DateTime newDateTime,
  }) {
    return _guard(() async {
      final model = await _remoteDataSource.changeAppointmentDate(
        appointmentId: appointmentId,
        newSlot: newDateTime,
      );
      return model.toEntity(contractId: '');
    });
  }

  @override
  Future<Either<Failure, Unit>> cancelAppointment(String appointmentId) {
    return _guard(() async {
      await _remoteDataSource.cancelAppointment(appointmentId);
      return unit;
    });
  }

  @override
  Future<Either<Failure, Unit>> restoreAppointment(String appointmentId) {
    return _guard(() async {
      await _remoteDataSource.restoreAppointment(appointmentId);
      return unit;
    });
  }
}
