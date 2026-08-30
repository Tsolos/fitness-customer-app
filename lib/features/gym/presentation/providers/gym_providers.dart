import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/providers/core_providers.dart';
import '../../../../core/utils/either_x.dart';
import '../../data/datasources/gym_remote_data_source.dart';
import '../../data/repositories/gym_repository_impl.dart';
import '../../domain/entities/gym.dart';
import '../../domain/repositories/gym_repository.dart';

part 'gym_providers.g.dart';

@riverpod
GymRemoteDataSource gymRemoteDataSource(Ref ref) => GymRemoteDataSourceImpl(ref.watch(dioProvider));

@Riverpod(keepAlive: true)
GymRepository gymRepository(Ref ref) {
  return GymRepositoryImpl(
    remoteDataSource: ref.watch(gymRemoteDataSourceProvider),
    storageService: ref.watch(secureStorageServiceProvider),
    networkInfo: ref.watch(networkInfoProvider),
  );
}

@riverpod
Future<List<Gym>> gyms(Ref ref) => ref.watch(gymRepositoryProvider).getGyms().getOrThrow();

@Riverpod(keepAlive: true)
class SelectedGym extends _$SelectedGym {
  @override
  Future<Gym?> build() => ref.watch(gymRepositoryProvider).getSelectedGym();

  Future<void> select(Gym gym) async {
    await ref.read(gymRepositoryProvider).selectGym(gym);
    state = AsyncData(gym);
  }
}
