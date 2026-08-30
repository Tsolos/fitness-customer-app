import 'package:dio/dio.dart';

import '../error/exceptions.dart';

/// Translates a [DioException] into one of our typed app exceptions so
/// data sources never leak raw Dio types upward.
Exception mapDioException(DioException e) {
  switch (e.type) {
    case DioExceptionType.connectionTimeout:
    case DioExceptionType.sendTimeout:
    case DioExceptionType.receiveTimeout:
    case DioExceptionType.connectionError:
    case DioExceptionType.transformTimeout:
      return const NetworkException();
    case DioExceptionType.badCertificate:
      return const NetworkException(message: 'Μη έγκυρο πιστοποιητικό ασφαλείας.');
    case DioExceptionType.cancel:
      return const ServerException(message: 'Το αίτημα ακυρώθηκε.');
    case DioExceptionType.badResponse:
      final statusCode = e.response?.statusCode;
      final data = e.response?.data;
      final serverMessage = _extractMessage(data);
      if (statusCode == 401) {
        return UnauthorizedException(message: serverMessage ?? 'Λήξη σύνδεσης.');
      }
      if (statusCode == 422 || statusCode == 400) {
        return ValidationException(
          message: serverMessage ?? 'Μη έγκυρα δεδομένα.',
          fieldErrors: _extractFieldErrors(data),
        );
      }
      return ServerException(message: serverMessage ?? 'Σφάλμα διακομιστή ($statusCode).', statusCode: statusCode);
    case DioExceptionType.unknown:
      return const NetworkException();
  }
}

String? _extractMessage(dynamic data) {
  if (data is Map) {
    // `AuthController` (and most of this API's actions) return
    // `BadRequest(new { description = "..." })`. ASP.NET Core's default
    // ProblemDetails shape (`title`/`detail`) and a plain `{ message }`
    // are handled too, as a fallback for other actions.
    return (data['description'] ?? data['detail'] ?? data['title'] ?? data['message'])?.toString();
  }
  if (data is String && data.trim().isNotEmpty) {
    // Some actions (e.g. GuestsController.RegisterGuest) return a bare
    // BadRequest(string) instead of a JSON object.
    return data;
  }
  return null;
}

Map<String, List<String>>? _extractFieldErrors(dynamic data) {
  if (data is Map && data['errors'] is Map) {
    final raw = data['errors'] as Map;
    return raw.map((key, value) => MapEntry(key.toString(), List<String>.from(value as List)));
  }
  return null;
}
