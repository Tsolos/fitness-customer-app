import 'package:equatable/equatable.dart';

/// Domain/presentation-facing error type. Repositories return
/// `Either<Failure, T>` instead of throwing, so the UI layer always
/// deals with a typed, exhaustive error model.
abstract class Failure extends Equatable {
  final String message;

  const Failure(this.message);

  @override
  List<Object?> get props => [message];
}

class ServerFailure extends Failure {
  final int? statusCode;

  const ServerFailure(super.message, {this.statusCode});
}

class UnauthorizedFailure extends Failure {
  const UnauthorizedFailure([super.message = 'Λήξη σύνδεσης. Παρακαλώ συνδεθείτε ξανά.']);
}

class NetworkFailure extends Failure {
  const NetworkFailure([super.message = 'Δεν υπάρχει σύνδεση στο διαδίκτυο.']);
}

class CacheFailure extends Failure {
  const CacheFailure([super.message = 'Σφάλμα τοπικής αποθήκευσης.']);
}

class BiometricFailure extends Failure {
  const BiometricFailure(super.message);
}

class ValidationFailure extends Failure {
  final Map<String, List<String>>? fieldErrors;

  const ValidationFailure(super.message, {this.fieldErrors});
}

class UnknownFailure extends Failure {
  const UnknownFailure([super.message = 'Παρουσιάστηκε ένα μη αναμενόμενο σφάλμα.']);
}
