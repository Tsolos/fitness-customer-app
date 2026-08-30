// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(authRemoteDataSource)
final authRemoteDataSourceProvider = AuthRemoteDataSourceProvider._();

final class AuthRemoteDataSourceProvider
    extends
        $FunctionalProvider<
          AuthRemoteDataSource,
          AuthRemoteDataSource,
          AuthRemoteDataSource
        >
    with $Provider<AuthRemoteDataSource> {
  AuthRemoteDataSourceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'authRemoteDataSourceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$authRemoteDataSourceHash();

  @$internal
  @override
  $ProviderElement<AuthRemoteDataSource> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  AuthRemoteDataSource create(Ref ref) {
    return authRemoteDataSource(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AuthRemoteDataSource value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AuthRemoteDataSource>(value),
    );
  }
}

String _$authRemoteDataSourceHash() =>
    r'cb3bef96b6a074700116b52b285087081b1d5948';

@ProviderFor(authLocalDataSource)
final authLocalDataSourceProvider = AuthLocalDataSourceProvider._();

final class AuthLocalDataSourceProvider
    extends
        $FunctionalProvider<
          AuthLocalDataSource,
          AuthLocalDataSource,
          AuthLocalDataSource
        >
    with $Provider<AuthLocalDataSource> {
  AuthLocalDataSourceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'authLocalDataSourceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$authLocalDataSourceHash();

  @$internal
  @override
  $ProviderElement<AuthLocalDataSource> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  AuthLocalDataSource create(Ref ref) {
    return authLocalDataSource(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AuthLocalDataSource value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AuthLocalDataSource>(value),
    );
  }
}

String _$authLocalDataSourceHash() =>
    r'382d0ebd1c1edbe3aef40584f01282a2feff70b1';

@ProviderFor(authRepository)
final authRepositoryProvider = AuthRepositoryProvider._();

final class AuthRepositoryProvider
    extends $FunctionalProvider<AuthRepository, AuthRepository, AuthRepository>
    with $Provider<AuthRepository> {
  AuthRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'authRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$authRepositoryHash();

  @$internal
  @override
  $ProviderElement<AuthRepository> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  AuthRepository create(Ref ref) {
    return authRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AuthRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AuthRepository>(value),
    );
  }
}

String _$authRepositoryHash() => r'fe61613c0a7fe3c53812792bebc2644f43b37b8c';

@ProviderFor(loginUseCase)
final loginUseCaseProvider = LoginUseCaseProvider._();

final class LoginUseCaseProvider
    extends $FunctionalProvider<LoginUseCase, LoginUseCase, LoginUseCase>
    with $Provider<LoginUseCase> {
  LoginUseCaseProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'loginUseCaseProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$loginUseCaseHash();

  @$internal
  @override
  $ProviderElement<LoginUseCase> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  LoginUseCase create(Ref ref) {
    return loginUseCase(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(LoginUseCase value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<LoginUseCase>(value),
    );
  }
}

String _$loginUseCaseHash() => r'5a95b111ff086652f0c947b88bcfe26ea7ce95be';

@ProviderFor(googleLoginUseCase)
final googleLoginUseCaseProvider = GoogleLoginUseCaseProvider._();

final class GoogleLoginUseCaseProvider
    extends
        $FunctionalProvider<
          GoogleLoginUseCase,
          GoogleLoginUseCase,
          GoogleLoginUseCase
        >
    with $Provider<GoogleLoginUseCase> {
  GoogleLoginUseCaseProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'googleLoginUseCaseProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$googleLoginUseCaseHash();

  @$internal
  @override
  $ProviderElement<GoogleLoginUseCase> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  GoogleLoginUseCase create(Ref ref) {
    return googleLoginUseCase(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(GoogleLoginUseCase value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<GoogleLoginUseCase>(value),
    );
  }
}

String _$googleLoginUseCaseHash() =>
    r'b4324912d5a53f4eb99c577d3a30ba91cb344624';

@ProviderFor(biometricLoginUseCase)
final biometricLoginUseCaseProvider = BiometricLoginUseCaseProvider._();

final class BiometricLoginUseCaseProvider
    extends
        $FunctionalProvider<
          BiometricLoginUseCase,
          BiometricLoginUseCase,
          BiometricLoginUseCase
        >
    with $Provider<BiometricLoginUseCase> {
  BiometricLoginUseCaseProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'biometricLoginUseCaseProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$biometricLoginUseCaseHash();

  @$internal
  @override
  $ProviderElement<BiometricLoginUseCase> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  BiometricLoginUseCase create(Ref ref) {
    return biometricLoginUseCase(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(BiometricLoginUseCase value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<BiometricLoginUseCase>(value),
    );
  }
}

String _$biometricLoginUseCaseHash() =>
    r'e365a2dd31d2ad95c0602c61d83ace3cc60da97d';

@ProviderFor(logoutUseCase)
final logoutUseCaseProvider = LogoutUseCaseProvider._();

final class LogoutUseCaseProvider
    extends $FunctionalProvider<LogoutUseCase, LogoutUseCase, LogoutUseCase>
    with $Provider<LogoutUseCase> {
  LogoutUseCaseProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'logoutUseCaseProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$logoutUseCaseHash();

  @$internal
  @override
  $ProviderElement<LogoutUseCase> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  LogoutUseCase create(Ref ref) {
    return logoutUseCase(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(LogoutUseCase value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<LogoutUseCase>(value),
    );
  }
}

String _$logoutUseCaseHash() => r'c3c6c589cbff5a2f6618cc56b1f9faae632da27a';

@ProviderFor(registerUseCase)
final registerUseCaseProvider = RegisterUseCaseProvider._();

final class RegisterUseCaseProvider
    extends
        $FunctionalProvider<RegisterUseCase, RegisterUseCase, RegisterUseCase>
    with $Provider<RegisterUseCase> {
  RegisterUseCaseProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'registerUseCaseProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$registerUseCaseHash();

  @$internal
  @override
  $ProviderElement<RegisterUseCase> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  RegisterUseCase create(Ref ref) {
    return registerUseCase(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(RegisterUseCase value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<RegisterUseCase>(value),
    );
  }
}

String _$registerUseCaseHash() => r'18669430c22e1c7844c19dd3dcbe2285a2250a73';

@ProviderFor(toggleBiometricUseCase)
final toggleBiometricUseCaseProvider = ToggleBiometricUseCaseProvider._();

final class ToggleBiometricUseCaseProvider
    extends
        $FunctionalProvider<
          ToggleBiometricUseCase,
          ToggleBiometricUseCase,
          ToggleBiometricUseCase
        >
    with $Provider<ToggleBiometricUseCase> {
  ToggleBiometricUseCaseProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'toggleBiometricUseCaseProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$toggleBiometricUseCaseHash();

  @$internal
  @override
  $ProviderElement<ToggleBiometricUseCase> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  ToggleBiometricUseCase create(Ref ref) {
    return toggleBiometricUseCase(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ToggleBiometricUseCase value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ToggleBiometricUseCase>(value),
    );
  }
}

String _$toggleBiometricUseCaseHash() =>
    r'2d85263eb09c43f185cbc53c4c14a5851089250b';

/// Whether the login screen should show the "sign in with fingerprint"
/// shortcut: the device supports it, the user opted in, and there are
/// remembered credentials to replay after the biometric check.

@ProviderFor(canUseBiometricLogin)
final canUseBiometricLoginProvider = CanUseBiometricLoginProvider._();

/// Whether the login screen should show the "sign in with fingerprint"
/// shortcut: the device supports it, the user opted in, and there are
/// remembered credentials to replay after the biometric check.

final class CanUseBiometricLoginProvider
    extends $FunctionalProvider<AsyncValue<bool>, bool, FutureOr<bool>>
    with $FutureModifier<bool>, $FutureProvider<bool> {
  /// Whether the login screen should show the "sign in with fingerprint"
  /// shortcut: the device supports it, the user opted in, and there are
  /// remembered credentials to replay after the biometric check.
  CanUseBiometricLoginProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'canUseBiometricLoginProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$canUseBiometricLoginHash();

  @$internal
  @override
  $FutureProviderElement<bool> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<bool> create(Ref ref) {
    return canUseBiometricLogin(ref);
  }
}

String _$canUseBiometricLoginHash() =>
    r'dc5f5653b0f8d3fba8b838f197831c534df11375';

/// The logged-in customer's id (decoded from the JWT at login time). Every
/// Guests-controller endpoint is scoped by this id.

@ProviderFor(currentCustomerId)
final currentCustomerIdProvider = CurrentCustomerIdProvider._();

/// The logged-in customer's id (decoded from the JWT at login time). Every
/// Guests-controller endpoint is scoped by this id.

final class CurrentCustomerIdProvider
    extends $FunctionalProvider<AsyncValue<String>, String, FutureOr<String>>
    with $FutureModifier<String>, $FutureProvider<String> {
  /// The logged-in customer's id (decoded from the JWT at login time). Every
  /// Guests-controller endpoint is scoped by this id.
  CurrentCustomerIdProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'currentCustomerIdProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$currentCustomerIdHash();

  @$internal
  @override
  $FutureProviderElement<String> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<String> create(Ref ref) {
    return currentCustomerId(ref);
  }
}

String _$currentCustomerIdHash() => r'775e9fe337cde59f6cfc6b4e435f221e37ab0bad';

@ProviderFor(biometricDeviceSupported)
final biometricDeviceSupportedProvider = BiometricDeviceSupportedProvider._();

final class BiometricDeviceSupportedProvider
    extends $FunctionalProvider<AsyncValue<bool>, bool, FutureOr<bool>>
    with $FutureModifier<bool>, $FutureProvider<bool> {
  BiometricDeviceSupportedProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'biometricDeviceSupportedProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$biometricDeviceSupportedHash();

  @$internal
  @override
  $FutureProviderElement<bool> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<bool> create(Ref ref) {
    return biometricDeviceSupported(ref);
  }
}

String _$biometricDeviceSupportedHash() =>
    r'276e852dcaa015b7ba5230c425ed9e368a4fae24';

@ProviderFor(biometricEnabled)
final biometricEnabledProvider = BiometricEnabledProvider._();

final class BiometricEnabledProvider
    extends $FunctionalProvider<AsyncValue<bool>, bool, FutureOr<bool>>
    with $FutureModifier<bool>, $FutureProvider<bool> {
  BiometricEnabledProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'biometricEnabledProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$biometricEnabledHash();

  @$internal
  @override
  $FutureProviderElement<bool> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<bool> create(Ref ref) {
    return biometricEnabled(ref);
  }
}

String _$biometricEnabledHash() => r'ccdb1eb6dd76da10e5239ea9a11f64e46a125950';

@ProviderFor(rememberedCredentials)
final rememberedCredentialsProvider = RememberedCredentialsProvider._();

final class RememberedCredentialsProvider
    extends
        $FunctionalProvider<
          AsyncValue<({String email, String password})?>,
          ({String email, String password})?,
          FutureOr<({String email, String password})?>
        >
    with
        $FutureModifier<({String email, String password})?>,
        $FutureProvider<({String email, String password})?> {
  RememberedCredentialsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'rememberedCredentialsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$rememberedCredentialsHash();

  @$internal
  @override
  $FutureProviderElement<({String email, String password})?> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<({String email, String password})?> create(Ref ref) {
    return rememberedCredentials(ref);
  }
}

String _$rememberedCredentialsHash() =>
    r'385e6e0eb0abc0757ac0fa4020cebe0a7958cf69';

/// Web only: fires with the account's tokens whenever the rendered
/// `GoogleSignInButton` completes a sign-in. `LoginScreen` listens to this
/// to drive `AuthController.completeGoogleLogin`.

@ProviderFor(googleWebTokens)
final googleWebTokensProvider = GoogleWebTokensProvider._();

/// Web only: fires with the account's tokens whenever the rendered
/// `GoogleSignInButton` completes a sign-in. `LoginScreen` listens to this
/// to drive `AuthController.completeGoogleLogin`.

final class GoogleWebTokensProvider
    extends
        $FunctionalProvider<
          AsyncValue<GoogleTokens?>,
          GoogleTokens?,
          Stream<GoogleTokens?>
        >
    with $FutureModifier<GoogleTokens?>, $StreamProvider<GoogleTokens?> {
  /// Web only: fires with the account's tokens whenever the rendered
  /// `GoogleSignInButton` completes a sign-in. `LoginScreen` listens to this
  /// to drive `AuthController.completeGoogleLogin`.
  GoogleWebTokensProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'googleWebTokensProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$googleWebTokensHash();

  @$internal
  @override
  $StreamProviderElement<GoogleTokens?> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<GoogleTokens?> create(Ref ref) {
    return googleWebTokens(ref);
  }
}

String _$googleWebTokensHash() => r'479e9e3a0dfbd6df1a1413898517d318fab36777';
