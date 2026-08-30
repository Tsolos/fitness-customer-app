import 'package:dio/dio.dart';

import '../../storage/secure_storage_service.dart';

typedef OnUnauthorized = Future<void> Function();

/// Attaches the bearer access token to every outgoing request and reacts
/// to 401 responses by giving the app a chance to force a logout.
///
/// TODO(api-alignment): if the API exposes a refresh-token endpoint, add
/// the refresh flow here (queue pending requests while refreshing, retry
/// once, then fall back to [onUnauthorized]).
class AuthInterceptor extends Interceptor {
  AuthInterceptor({
    required this._storageService,
    required this._onUnauthorized,
  });

  final SecureStorageService _storageService;
  final OnUnauthorized _onUnauthorized;

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final token = await _storageService.getAccessToken();
    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    handler.next(options);
  }

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    if (err.response?.statusCode == 401) {
      await _onUnauthorized();
    }
    handler.next(err);
  }
}
