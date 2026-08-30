// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'profile_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(customerRemoteDataSource)
final customerRemoteDataSourceProvider = CustomerRemoteDataSourceProvider._();

final class CustomerRemoteDataSourceProvider
    extends
        $FunctionalProvider<
          CustomerRemoteDataSource,
          CustomerRemoteDataSource,
          CustomerRemoteDataSource
        >
    with $Provider<CustomerRemoteDataSource> {
  CustomerRemoteDataSourceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'customerRemoteDataSourceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$customerRemoteDataSourceHash();

  @$internal
  @override
  $ProviderElement<CustomerRemoteDataSource> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  CustomerRemoteDataSource create(Ref ref) {
    return customerRemoteDataSource(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(CustomerRemoteDataSource value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<CustomerRemoteDataSource>(value),
    );
  }
}

String _$customerRemoteDataSourceHash() =>
    r'c6b0a79b92800b26bbb41098977571278d361b19';

@ProviderFor(customerRepository)
final customerRepositoryProvider = CustomerRepositoryProvider._();

final class CustomerRepositoryProvider
    extends
        $FunctionalProvider<
          CustomerRepository,
          CustomerRepository,
          CustomerRepository
        >
    with $Provider<CustomerRepository> {
  CustomerRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'customerRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$customerRepositoryHash();

  @$internal
  @override
  $ProviderElement<CustomerRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  CustomerRepository create(Ref ref) {
    return customerRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(CustomerRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<CustomerRepository>(value),
    );
  }
}

String _$customerRepositoryHash() =>
    r'dca10c85956afcd0045378dfd2d046faed5f4f0d';

@ProviderFor(ProfileController)
final profileControllerProvider = ProfileControllerProvider._();

final class ProfileControllerProvider
    extends $AsyncNotifierProvider<ProfileController, Customer> {
  ProfileControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'profileControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$profileControllerHash();

  @$internal
  @override
  ProfileController create() => ProfileController();
}

String _$profileControllerHash() => r'd40fb7f1076107b7c3c23ab21a924c7574321d8d';

abstract class _$ProfileController extends $AsyncNotifier<Customer> {
  FutureOr<Customer> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AsyncValue<Customer>, Customer>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<Customer>, Customer>,
              AsyncValue<Customer>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
