import 'dart:typed_data';

import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/customer.dart';

abstract class CustomerRepository {
  Future<Either<Failure, Customer>> getMyProfile(String customerId);

  Future<Either<Failure, Customer>> updateProfile(Customer customer);

  /// Bytes + filename (rather than `dart:io File`) so this works on web
  /// too. Returns the new photo's URL (a 24h SAS URL — see
  /// `CustomersController.UploadAvatar`); `getMyProfile` will return a
  /// freshly-generated one on every subsequent call regardless.
  Future<Either<Failure, String>> uploadPhoto({
    required String customerId,
    required Uint8List bytes,
    required String fileName,
  });
}
