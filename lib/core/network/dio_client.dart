import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

import '../config/app_config.dart';
import '../storage/secure_storage_service.dart';
import 'dev_certificate_bypass_default.dart' if (dart.library.io) 'dev_certificate_bypass_io.dart';
import 'interceptors/auth_interceptor.dart';

/// Builds the single [Dio] instance used across the app.
class DioClient {
  static Dio create({
    required SecureStorageService storageService,
    required OnUnauthorized onUnauthorized,
  }) {
    final dio = Dio(
      BaseOptions(
        baseUrl: AppConfig.apiBaseUrl,
        connectTimeout: AppConfig.connectTimeout,
        receiveTimeout: AppConfig.receiveTimeout,
        contentType: 'application/json',
        headers: const {'Accept': 'application/json'},
      ),
    );

    configureDevCertificateBypass(dio);

    dio.interceptors.add(
      AuthInterceptor(storageService: storageService, onUnauthorized: onUnauthorized),
    );

    if (AppConfig.enableHttpLogging) {
      dio.interceptors.add(
        PrettyDioLogger(
          requestHeader: true,
          requestBody: true,
          responseBody: true,
          responseHeader: false,
          compact: true,
        ),
      );
    }

    return dio;
  }
}
