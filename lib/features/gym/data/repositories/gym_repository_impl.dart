import 'package:dartz/dartz.dart';

import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/network/network_info.dart';
import '../../../../core/storage/secure_storage_service.dart';
import '../../domain/entities/gym.dart';
import '../../domain/repositories/gym_repository.dart';
import '../datasources/gym_remote_data_source.dart';

class GymRepositoryImpl implements GymRepository {
  GymRepositoryImpl({
    required this._remoteDataSource,
    required this._storageService,
    required this._networkInfo,
  });

  final GymRemoteDataSource _remoteDataSource;
  final SecureStorageService _storageService;
  final NetworkInfo _networkInfo;

  @override
  Future<Either<Failure, List<Gym>>> getGyms() async {
    if (!await _networkInfo.isConnected) {
      return const Left(NetworkFailure());
    }
    try {
      final models = await _remoteDataSource.getGyms();
      return Right(models.map((m) => m.toEntity()).toList());
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message, statusCode: e.statusCode));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } catch (_) {
      return const Left(UnknownFailure());
    }
  }

  @override
  Future<Gym?> getSelectedGym() async {
    final stored = await _storageService.getSelectedGym();
    if (stored == null) return null;
    return Gym(id: stored.id, title: stored.title);
  }

  @override
  Future<void> selectGym(Gym gym) {
    return _storageService.saveSelectedGym(id: gym.id, title: gym.title);
  }
}
