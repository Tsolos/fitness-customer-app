/// Thrown by data sources (remote/local). Caught by repositories and mapped
/// to a [Failure] before crossing into the domain layer.
class ServerException implements Exception {
  final String message;
  final int? statusCode;

  const ServerException({required this.message, this.statusCode});
}

class UnauthorizedException implements Exception {
  final String message;

  const UnauthorizedException({this.message = 'Λήξη σύνδεσης. Παρακαλώ συνδεθείτε ξανά.'});
}

class NetworkException implements Exception {
  final String message;

  const NetworkException({this.message = 'Δεν υπάρχει σύνδεση στο διαδίκτυο.'});
}

class CacheException implements Exception {
  final String message;

  const CacheException({this.message = 'Σφάλμα τοπικής αποθήκευσης.'});
}

class BiometricException implements Exception {
  final String message;

  const BiometricException({required this.message});
}

class ValidationException implements Exception {
  final String message;
  final Map<String, List<String>>? fieldErrors;

  const ValidationException({required this.message, this.fieldErrors});
}
