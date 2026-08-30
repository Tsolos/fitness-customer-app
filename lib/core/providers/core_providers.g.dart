// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'core_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(secureStorageService)
final secureStorageServiceProvider = SecureStorageServiceProvider._();

final class SecureStorageServiceProvider
    extends
        $FunctionalProvider<
          SecureStorageService,
          SecureStorageService,
          SecureStorageService
        >
    with $Provider<SecureStorageService> {
  SecureStorageServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'secureStorageServiceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$secureStorageServiceHash();

  @$internal
  @override
  $ProviderElement<SecureStorageService> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  SecureStorageService create(Ref ref) {
    return secureStorageService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SecureStorageService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SecureStorageService>(value),
    );
  }
}

String _$secureStorageServiceHash() =>
    r'977e09a031697444060df5ea90e1560d13b5feb1';

@ProviderFor(biometricService)
final biometricServiceProvider = BiometricServiceProvider._();

final class BiometricServiceProvider
    extends
        $FunctionalProvider<
          BiometricService,
          BiometricService,
          BiometricService
        >
    with $Provider<BiometricService> {
  BiometricServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'biometricServiceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$biometricServiceHash();

  @$internal
  @override
  $ProviderElement<BiometricService> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  BiometricService create(Ref ref) {
    return biometricService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(BiometricService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<BiometricService>(value),
    );
  }
}

String _$biometricServiceHash() => r'c28c66fc179eade56af90e4df7c5cd6fc01e79b2';

@ProviderFor(googleAuthService)
final googleAuthServiceProvider = GoogleAuthServiceProvider._();

final class GoogleAuthServiceProvider
    extends
        $FunctionalProvider<
          GoogleAuthService,
          GoogleAuthService,
          GoogleAuthService
        >
    with $Provider<GoogleAuthService> {
  GoogleAuthServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'googleAuthServiceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$googleAuthServiceHash();

  @$internal
  @override
  $ProviderElement<GoogleAuthService> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  GoogleAuthService create(Ref ref) {
    return googleAuthService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(GoogleAuthService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<GoogleAuthService>(value),
    );
  }
}

String _$googleAuthServiceHash() => r'f6d1a44e9156de4b859bb96071b2a534f59ce5d4';

@ProviderFor(networkInfo)
final networkInfoProvider = NetworkInfoProvider._();

final class NetworkInfoProvider
    extends $FunctionalProvider<NetworkInfo, NetworkInfo, NetworkInfo>
    with $Provider<NetworkInfo> {
  NetworkInfoProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'networkInfoProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$networkInfoHash();

  @$internal
  @override
  $ProviderElement<NetworkInfo> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  NetworkInfo create(Ref ref) {
    return networkInfo(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(NetworkInfo value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<NetworkInfo>(value),
    );
  }
}

String _$networkInfoHash() => r'a81151b8f1598ba3e0980ed27925e91307d8439f';

@ProviderFor(dio)
final dioProvider = DioProvider._();

final class DioProvider extends $FunctionalProvider<Dio, Dio, Dio>
    with $Provider<Dio> {
  DioProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'dioProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$dioHash();

  @$internal
  @override
  $ProviderElement<Dio> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  Dio create(Ref ref) {
    return dio(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Dio value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Dio>(value),
    );
  }
}

String _$dioHash() => r'25942c07586480703e5e3dfc812bda4506f7e706';
