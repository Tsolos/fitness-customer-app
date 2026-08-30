import 'package:dartz/dartz.dart';

import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/network/network_info.dart';
import '../../domain/entities/progress_entry.dart';
import '../../domain/repositories/progress_repository.dart';
import '../datasources/progress_remote_data_source.dart';

class ProgressRepositoryImpl implements ProgressRepository {
  ProgressRepositoryImpl({
    required this._remoteDataSource,
    required this._networkInfo,
  });

  final ProgressRemoteDataSource _remoteDataSource;
  final NetworkInfo _networkInfo;

  @override
  Future<Either<Failure, List<ProgressEntry>>> getMyProgress(
    String customerId,
  ) async {
    if (!await _networkInfo.isConnected) {
      return const Left(NetworkFailure());
    }
    try {
      final models = await _remoteDataSource.getAllMeasurements(customerId);
      final entries = models.map((m) => m.toEntity()).toList()
        ..sort((a, b) => a.date.compareTo(b.date));
      return Right(entries);
    } on UnauthorizedException catch (e) {
      return Left(UnauthorizedFailure(e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message, statusCode: e.statusCode));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } catch (_) {
      return const Left(UnknownFailure());
    }
  }
}
