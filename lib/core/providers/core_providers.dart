import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../network/dio_client.dart';
import '../network/network_info.dart';
import '../services/biometric_service.dart';
import '../services/google_auth_service.dart';
import '../storage/secure_storage_service.dart';
import 'session_events.dart';

part 'core_providers.g.dart';

@Riverpod(keepAlive: true)
SecureStorageService secureStorageService(Ref ref) => SecureStorageService();

@Riverpod(keepAlive: true)
BiometricService biometricService(Ref ref) => BiometricService();

@Riverpod(keepAlive: true)
GoogleAuthService googleAuthService(Ref ref) => GoogleAuthService();

@Riverpod(keepAlive: true)
NetworkInfo networkInfo(Ref ref) => NetworkInfoImpl();

@Riverpod(keepAlive: true)
Dio dio(Ref ref) {
  final storage = ref.watch(secureStorageServiceProvider);
  return DioClient.create(
    storageService: storage,
    onUnauthorized: () async {
      ref.read(sessionExpiredProvider.notifier).bump();
    },
  );
}
