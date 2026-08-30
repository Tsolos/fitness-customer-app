// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'gym_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(gymRemoteDataSource)
final gymRemoteDataSourceProvider = GymRemoteDataSourceProvider._();

final class GymRemoteDataSourceProvider
    extends
        $FunctionalProvider<
          GymRemoteDataSource,
          GymRemoteDataSource,
          GymRemoteDataSource
        >
    with $Provider<GymRemoteDataSource> {
  GymRemoteDataSourceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'gymRemoteDataSourceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$gymRemoteDataSourceHash();

  @$internal
  @override
  $ProviderElement<GymRemoteDataSource> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  GymRemoteDataSource create(Ref ref) {
    return gymRemoteDataSource(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(GymRemoteDataSource value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<GymRemoteDataSource>(value),
    );
  }
}

String _$gymRemoteDataSourceHash() =>
    r'ffaf8bf9c861c625623aa9a7c76bc52d36e2d665';

@ProviderFor(gymRepository)
final gymRepositoryProvider = GymRepositoryProvider._();

final class GymRepositoryProvider
    extends $FunctionalProvider<GymRepository, GymRepository, GymRepository>
    with $Provider<GymRepository> {
  GymRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'gymRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$gymRepositoryHash();

  @$internal
  @override
  $ProviderElement<GymRepository> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  GymRepository create(Ref ref) {
    return gymRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(GymRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<GymRepository>(value),
    );
  }
}

String _$gymRepositoryHash() => r'dbe3d0b18ff0a1d1de2dfcca48d9ed4a9f9e49be';

@ProviderFor(gyms)
final gymsProvider = GymsProvider._();

final class GymsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Gym>>,
          List<Gym>,
          FutureOr<List<Gym>>
        >
    with $FutureModifier<List<Gym>>, $FutureProvider<List<Gym>> {
  GymsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'gymsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$gymsHash();

  @$internal
  @override
  $FutureProviderElement<List<Gym>> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<List<Gym>> create(Ref ref) {
    return gyms(ref);
  }
}

String _$gymsHash() => r'a8dd8f6f95fe4a70db381ab7345dff1fa1a04469';

@ProviderFor(SelectedGym)
final selectedGymProvider = SelectedGymProvider._();

final class SelectedGymProvider
    extends $AsyncNotifierProvider<SelectedGym, Gym?> {
  SelectedGymProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'selectedGymProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$selectedGymHash();

  @$internal
  @override
  SelectedGym create() => SelectedGym();
}

String _$selectedGymHash() => r'0112b48a3f55cd7084ec8fbac8b4e4d779defc43';

abstract class _$SelectedGym extends $AsyncNotifier<Gym?> {
  FutureOr<Gym?> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AsyncValue<Gym?>, Gym?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<Gym?>, Gym?>,
              AsyncValue<Gym?>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
