import 'package:dio/dio.dart';

import '../../../../core/network/api_endpoints.dart';
import '../../../../core/network/network_exception_mapper.dart';
import '../models/appointment_model.dart';
import '../models/contract_model.dart';
import '../models/slot_model.dart';

abstract class ContractsRemoteDataSource {
  Future<List<ContractModel>> getGuestContracts(String customerId);

  Future<List<SlotModel>> getSlotAvailability({
    required String customerId,
    required String branchId,
    required DateTime startDate,
    required int days,
  });

  Future<AppointmentModel> addAppointment({
    required String customerId,
    required String contractId,
    required DateTime dateTime,
  });

  Future<AppointmentModel> changeAppointmentDate({required String appointmentId, required DateTime newSlot});

  Future<AppointmentModel> cancelAppointment(String appointmentId);

  Future<AppointmentModel> restoreAppointment(String appointmentId);
}

class ContractsRemoteDataSourceImpl implements ContractsRemoteDataSource {
  ContractsRemoteDataSourceImpl(this._dio);

  final Dio _dio;

  @override
  Future<List<ContractModel>> getGuestContracts(String customerId) async {
    try {
      final response = await _dio.get(ApiEndpoints.guestContracts(customerId));
      final list = response.data as List<dynamic>;
      return list.whereType<Map<String, dynamic>>().map(ContractModel.fromJson).toList();
    } on DioException catch (e) {
      throw mapDioException(e);
    }
  }

  @override
  Future<List<SlotModel>> getSlotAvailability({
    required String customerId,
    required String branchId,
    required DateTime startDate,
    required int days,
  }) async {
    try {
      final response = await _dio.post(
        ApiEndpoints.slotAvailability,
        data: {
          'customerID': customerId,
          'branchID': branchId,
          'startDate': startDate.toIso8601String(),
          'days': days,
        },
      );
      final list = response.data as List<dynamic>;
      return list.whereType<Map<String, dynamic>>().map(SlotModel.fromJson).toList();
    } on DioException catch (e) {
      throw mapDioException(e);
    }
  }

  @override
  Future<AppointmentModel> addAppointment({
    required String customerId,
    required String contractId,
    required DateTime dateTime,
  }) async {
    try {
      final response = await _dio.post(
        ApiEndpoints.addAppointment(customerId),
        data: {
          'contractID': contractId,
          'date': dateTime.toIso8601String(),
        },
      );
      return AppointmentModel.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw mapDioException(e);
    }
  }

  @override
  Future<AppointmentModel> changeAppointmentDate({required String appointmentId, required DateTime newSlot}) async {
    try {
      final response = await _dio.get(
        ApiEndpoints.changeAppointmentDate(appointmentId, newSlot.toIso8601String()),
      );
      return AppointmentModel.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw mapDioException(e);
    }
  }

  @override
  Future<AppointmentModel> cancelAppointment(String appointmentId) async {
    try {
      final response = await _dio.get(ApiEndpoints.cancelAppointment(appointmentId));
      return AppointmentModel.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw mapDioException(e);
    }
  }

  @override
  Future<AppointmentModel> restoreAppointment(String appointmentId) async {
    try {
      final response = await _dio.get(ApiEndpoints.restoreAppointment(appointmentId));
      return AppointmentModel.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw mapDioException(e);
    }
  }
}
