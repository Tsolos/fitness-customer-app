import 'dart:typed_data';

import 'package:dartz/dartz.dart';

import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/network/network_info.dart';
import '../../domain/entities/customer.dart';
import '../../domain/repositories/customer_repository.dart';
import '../datasources/customer_remote_data_source.dart';
import '../models/customer_model.dart';

class CustomerRepositoryImpl implements CustomerRepository {
  CustomerRepositoryImpl({
    required this._remoteDataSource,
    required this._networkInfo,
  });

  final CustomerRemoteDataSource _remoteDataSource;
  final NetworkInfo _networkInfo;

  /// The last raw JSON we fetched, kept so [updateProfile] can merge edits
  /// into it instead of round-tripping only the fields this app knows
  /// about (see [CustomerModel]'s doc comment for why that matters here).
  CustomerModel? _lastFetched;

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
  Future<Either<Failure, Customer>> getMyProfile(String customerId) {
    return _guard(() async {
      final model = await _remoteDataSource.getCustomerBasicInfo(customerId);
      _lastFetched = model;
      return model.customer;
    });
  }

  @override
  Future<Either<Failure, Customer>> updateProfile(Customer customer) async {
    final base = _lastFetched;
    if (base == null || base.customer.id != customer.id) {
      return const Left(
        UnknownFailure(
          'Δεν βρέθηκαν τα αρχικά στοιχεία του προφίλ — ανανεώστε τη σελίδα και δοκιμάστε ξανά.',
        ),
      );
    }
    return _guard(() async {
      final body = base.buildUpdateJson(customer);
      final model = await _remoteDataSource.updateCustomerBasicInfo(body);
      _lastFetched = model;
      return model.customer;
    });
  }

  @override
  Future<Either<Failure, String>> uploadPhoto({
    required String customerId,
    required Uint8List bytes,
    required String fileName,
  }) {
    return _guard(() {
      return _remoteDataSource.uploadAvatar(
        customerId: customerId,
        bytes: bytes,
        fileName: fileName,
      );
    });
  }
}
