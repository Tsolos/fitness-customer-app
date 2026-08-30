import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/gym.dart';

abstract class GymRepository {
  Future<Either<Failure, List<Gym>>> getGyms();

  /// Persisted locally so the customer doesn't have to re-pick their gym
  /// on every app launch — only re-selected via "Αλλαγή γυμναστηρίου".
  Future<Gym?> getSelectedGym();

  Future<void> selectGym(Gym gym);
}
