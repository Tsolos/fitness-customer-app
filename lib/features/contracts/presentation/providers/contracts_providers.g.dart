// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'contracts_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(contractsRemoteDataSource)
final contractsRemoteDataSourceProvider = ContractsRemoteDataSourceProvider._();

final class ContractsRemoteDataSourceProvider
    extends
        $FunctionalProvider<
          ContractsRemoteDataSource,
          ContractsRemoteDataSource,
          ContractsRemoteDataSource
        >
    with $Provider<ContractsRemoteDataSource> {
  ContractsRemoteDataSourceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'contractsRemoteDataSourceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$contractsRemoteDataSourceHash();

  @$internal
  @override
  $ProviderElement<ContractsRemoteDataSource> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  ContractsRemoteDataSource create(Ref ref) {
    return contractsRemoteDataSource(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ContractsRemoteDataSource value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ContractsRemoteDataSource>(value),
    );
  }
}

String _$contractsRemoteDataSourceHash() =>
    r'd03549eb1164f6bcca10a25bc8137fe05f964844';

@ProviderFor(contractsRepository)
final contractsRepositoryProvider = ContractsRepositoryProvider._();

final class ContractsRepositoryProvider
    extends
        $FunctionalProvider<
          ContractsRepository,
          ContractsRepository,
          ContractsRepository
        >
    with $Provider<ContractsRepository> {
  ContractsRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'contractsRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$contractsRepositoryHash();

  @$internal
  @override
  $ProviderElement<ContractsRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  ContractsRepository create(Ref ref) {
    return contractsRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ContractsRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ContractsRepository>(value),
    );
  }
}

String _$contractsRepositoryHash() =>
    r'bec55df5643ad6db639d95b81fa9e530053f77ac';

@ProviderFor(createAppointmentUseCase)
final createAppointmentUseCaseProvider = CreateAppointmentUseCaseProvider._();

final class CreateAppointmentUseCaseProvider
    extends
        $FunctionalProvider<
          CreateAppointmentUseCase,
          CreateAppointmentUseCase,
          CreateAppointmentUseCase
        >
    with $Provider<CreateAppointmentUseCase> {
  CreateAppointmentUseCaseProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'createAppointmentUseCaseProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$createAppointmentUseCaseHash();

  @$internal
  @override
  $ProviderElement<CreateAppointmentUseCase> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  CreateAppointmentUseCase create(Ref ref) {
    return createAppointmentUseCase(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(CreateAppointmentUseCase value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<CreateAppointmentUseCase>(value),
    );
  }
}

String _$createAppointmentUseCaseHash() =>
    r'280ae8ac6f636072cacd736d2e23431ffaf79f94';

@ProviderFor(rescheduleAppointmentUseCase)
final rescheduleAppointmentUseCaseProvider =
    RescheduleAppointmentUseCaseProvider._();

final class RescheduleAppointmentUseCaseProvider
    extends
        $FunctionalProvider<
          RescheduleAppointmentUseCase,
          RescheduleAppointmentUseCase,
          RescheduleAppointmentUseCase
        >
    with $Provider<RescheduleAppointmentUseCase> {
  RescheduleAppointmentUseCaseProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'rescheduleAppointmentUseCaseProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$rescheduleAppointmentUseCaseHash();

  @$internal
  @override
  $ProviderElement<RescheduleAppointmentUseCase> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  RescheduleAppointmentUseCase create(Ref ref) {
    return rescheduleAppointmentUseCase(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(RescheduleAppointmentUseCase value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<RescheduleAppointmentUseCase>(value),
    );
  }
}

String _$rescheduleAppointmentUseCaseHash() =>
    r'049fe4e2648107fd62c914721fb44db0065234b5';

@ProviderFor(cancelAppointmentUseCase)
final cancelAppointmentUseCaseProvider = CancelAppointmentUseCaseProvider._();

final class CancelAppointmentUseCaseProvider
    extends
        $FunctionalProvider<
          CancelAppointmentUseCase,
          CancelAppointmentUseCase,
          CancelAppointmentUseCase
        >
    with $Provider<CancelAppointmentUseCase> {
  CancelAppointmentUseCaseProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'cancelAppointmentUseCaseProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$cancelAppointmentUseCaseHash();

  @$internal
  @override
  $ProviderElement<CancelAppointmentUseCase> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  CancelAppointmentUseCase create(Ref ref) {
    return cancelAppointmentUseCase(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(CancelAppointmentUseCase value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<CancelAppointmentUseCase>(value),
    );
  }
}

String _$cancelAppointmentUseCaseHash() =>
    r'f2a145e6e89d3960a301ca89fe2220088b87f1ab';

@ProviderFor(restoreAppointmentUseCase)
final restoreAppointmentUseCaseProvider = RestoreAppointmentUseCaseProvider._();

final class RestoreAppointmentUseCaseProvider
    extends
        $FunctionalProvider<
          RestoreAppointmentUseCase,
          RestoreAppointmentUseCase,
          RestoreAppointmentUseCase
        >
    with $Provider<RestoreAppointmentUseCase> {
  RestoreAppointmentUseCaseProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'restoreAppointmentUseCaseProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$restoreAppointmentUseCaseHash();

  @$internal
  @override
  $ProviderElement<RestoreAppointmentUseCase> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  RestoreAppointmentUseCase create(Ref ref) {
    return restoreAppointmentUseCase(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(RestoreAppointmentUseCase value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<RestoreAppointmentUseCase>(value),
    );
  }
}

String _$restoreAppointmentUseCaseHash() =>
    r'7d85778367ab61c5275527abea87728bde2e8bac';

@ProviderFor(contracts)
final contractsProvider = ContractsProvider._();

final class ContractsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Contract>>,
          List<Contract>,
          FutureOr<List<Contract>>
        >
    with $FutureModifier<List<Contract>>, $FutureProvider<List<Contract>> {
  ContractsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'contractsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$contractsHash();

  @$internal
  @override
  $FutureProviderElement<List<Contract>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<Contract>> create(Ref ref) {
    return contracts(ref);
  }
}

String _$contractsHash() => r'60d8e671daf3b7aa9e02ac0230f4aa9afb559472';

@ProviderFor(slotAvailability)
final slotAvailabilityProvider = SlotAvailabilityFamily._();

final class SlotAvailabilityProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<AppointmentSlot>>,
          List<AppointmentSlot>,
          FutureOr<List<AppointmentSlot>>
        >
    with
        $FutureModifier<List<AppointmentSlot>>,
        $FutureProvider<List<AppointmentSlot>> {
  SlotAvailabilityProvider._({
    required SlotAvailabilityFamily super.from,
    required ({
      String customerId,
      String branchId,
      DateTime startDate,
      int days,
    })
    super.argument,
  }) : super(
         retry: null,
         name: r'slotAvailabilityProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$slotAvailabilityHash();

  @override
  String toString() {
    return r'slotAvailabilityProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  $FutureProviderElement<List<AppointmentSlot>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<AppointmentSlot>> create(Ref ref) {
    final argument =
        this.argument
            as ({
              String customerId,
              String branchId,
              DateTime startDate,
              int days,
            });
    return slotAvailability(
      ref,
      customerId: argument.customerId,
      branchId: argument.branchId,
      startDate: argument.startDate,
      days: argument.days,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is SlotAvailabilityProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$slotAvailabilityHash() => r'23b4af73666303569983df3daeb851f7a3a1e7eb';

final class SlotAvailabilityFamily extends $Family
    with
        $FunctionalFamilyOverride<
          FutureOr<List<AppointmentSlot>>,
          ({String customerId, String branchId, DateTime startDate, int days})
        > {
  SlotAvailabilityFamily._()
    : super(
        retry: null,
        name: r'slotAvailabilityProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  SlotAvailabilityProvider call({
    required String customerId,
    required String branchId,
    required DateTime startDate,
    required int days,
  }) => SlotAvailabilityProvider._(
    argument: (
      customerId: customerId,
      branchId: branchId,
      startDate: startDate,
      days: days,
    ),
    from: this,
  );

  @override
  String toString() => r'slotAvailabilityProvider';
}
