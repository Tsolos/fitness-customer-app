import 'dart:typed_data';

import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/providers/core_providers.dart';
import '../../../../core/utils/either_x.dart';
import '../../../auth/presentation/providers/auth_providers.dart';
import '../../data/datasources/customer_remote_data_source.dart';
import '../../data/repositories/customer_repository_impl.dart';
import '../../domain/entities/customer.dart';
import '../../domain/repositories/customer_repository.dart';

part 'profile_providers.g.dart';

@riverpod
CustomerRemoteDataSource customerRemoteDataSource(Ref ref) {
  return CustomerRemoteDataSourceImpl(ref.watch(dioProvider));
}

@Riverpod(keepAlive: true)
CustomerRepository customerRepository(Ref ref) {
  return CustomerRepositoryImpl(
    remoteDataSource: ref.watch(customerRemoteDataSourceProvider),
    networkInfo: ref.watch(networkInfoProvider),
  );
}

@riverpod
class ProfileController extends _$ProfileController {
  @override
  Future<Customer> build() async {
    final customerId = await ref.watch(currentCustomerIdProvider.future);
    return ref.watch(customerRepositoryProvider).getMyProfile(customerId).getOrThrow();
  }

  Future<bool> updateProfile(Customer customer) async {
    final result = await ref.read(customerRepositoryProvider).updateProfile(customer);
    return result.fold(
      (failure) {
        state = AsyncError<Customer>(failure, StackTrace.current);
        return false;
      },
      (updated) {
        state = AsyncData(updated);
        return true;
      },
    );
  }

  Future<bool> uploadPhoto({required Uint8List bytes, required String fileName}) async {
    final current = state.value;
    if (current == null) return false;
    final result = await ref.read(customerRepositoryProvider).uploadPhoto(
          customerId: current.id,
          bytes: bytes,
          fileName: fileName,
        );
    return result.fold(
      (failure) {
        state = AsyncError<Customer>(failure, StackTrace.current);
        return false;
      },
      (photoUrl) {
        state = AsyncData(current.copyWith(photoUrl: photoUrl));
        return true;
      },
    );
  }
}
