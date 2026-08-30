import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/providers/core_providers.dart';
import '../../../../core/utils/either_x.dart';
import '../../../auth/presentation/providers/auth_providers.dart';
import '../../data/datasources/contracts_remote_data_source.dart';
import '../../data/repositories/contracts_repository_impl.dart';
import '../../domain/entities/appointment_slot.dart';
import '../../domain/entities/contract.dart';
import '../../domain/repositories/contracts_repository.dart';
import '../../domain/usecases/cancel_appointment_usecase.dart';
import '../../domain/usecases/create_appointment_usecase.dart';
import '../../domain/usecases/reschedule_appointment_usecase.dart';
import '../../domain/usecases/restore_appointment_usecase.dart';

part 'contracts_providers.g.dart';

@riverpod
ContractsRemoteDataSource contractsRemoteDataSource(Ref ref) {
  return ContractsRemoteDataSourceImpl(ref.watch(dioProvider));
}

@Riverpod(keepAlive: true)
ContractsRepository contractsRepository(Ref ref) {
  return ContractsRepositoryImpl(
    remoteDataSource: ref.watch(contractsRemoteDataSourceProvider),
    networkInfo: ref.watch(networkInfoProvider),
  );
}

@riverpod
CreateAppointmentUseCase createAppointmentUseCase(Ref ref) =>
    CreateAppointmentUseCase(ref.watch(contractsRepositoryProvider));

@riverpod
RescheduleAppointmentUseCase rescheduleAppointmentUseCase(Ref ref) =>
    RescheduleAppointmentUseCase(ref.watch(contractsRepositoryProvider));

@riverpod
CancelAppointmentUseCase cancelAppointmentUseCase(Ref ref) =>
    CancelAppointmentUseCase(ref.watch(contractsRepositoryProvider));

@riverpod
RestoreAppointmentUseCase restoreAppointmentUseCase(Ref ref) =>
    RestoreAppointmentUseCase(ref.watch(contractsRepositoryProvider));

@riverpod
Future<List<Contract>> contracts(Ref ref) async {
  final customerId = await ref.watch(currentCustomerIdProvider.future);
  return ref.watch(contractsRepositoryProvider).getMyContracts(customerId).getOrThrow();
}

@riverpod
Future<List<AppointmentSlot>> slotAvailability(
  Ref ref, {
  required String customerId,
  required String branchId,
  required DateTime startDate,
  required int days,
}) {
  return ref.watch(contractsRepositoryProvider).getSlotAvailability(
        customerId: customerId,
        branchId: branchId,
        startDate: startDate,
        days: days,
      ).getOrThrow();
}
