import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/providers/core_providers.dart';
import '../../../../core/utils/either_x.dart';
import '../../../auth/presentation/providers/auth_providers.dart';
import '../../data/datasources/progress_remote_data_source.dart';
import '../../data/repositories/progress_repository_impl.dart';
import '../../domain/entities/progress_entry.dart';
import '../../domain/repositories/progress_repository.dart';

part 'progress_providers.g.dart';

@riverpod
ProgressRemoteDataSource progressRemoteDataSource(Ref ref) {
  return ProgressRemoteDataSourceImpl(ref.watch(dioProvider));
}

@Riverpod(keepAlive: true)
ProgressRepository progressRepository(Ref ref) {
  return ProgressRepositoryImpl(
    remoteDataSource: ref.watch(progressRemoteDataSourceProvider),
    networkInfo: ref.watch(networkInfoProvider),
  );
}

@riverpod
Future<List<ProgressEntry>> progressEntries(Ref ref) async {
  final customerId = await ref.watch(currentCustomerIdProvider.future);
  return ref.watch(progressRepositoryProvider).getMyProgress(customerId).getOrThrow();
}
