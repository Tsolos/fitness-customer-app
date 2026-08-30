import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/progress_entry.dart';

abstract class ProgressRepository {
  Future<Either<Failure, List<ProgressEntry>>> getMyProgress(String customerId);
}
