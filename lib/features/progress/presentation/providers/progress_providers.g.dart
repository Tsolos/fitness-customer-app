// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'progress_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(progressRemoteDataSource)
final progressRemoteDataSourceProvider = ProgressRemoteDataSourceProvider._();

final class ProgressRemoteDataSourceProvider
    extends
        $FunctionalProvider<
          ProgressRemoteDataSource,
          ProgressRemoteDataSource,
          ProgressRemoteDataSource
        >
    with $Provider<ProgressRemoteDataSource> {
  ProgressRemoteDataSourceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'progressRemoteDataSourceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$progressRemoteDataSourceHash();

  @$internal
  @override
  $ProviderElement<ProgressRemoteDataSource> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  ProgressRemoteDataSource create(Ref ref) {
    return progressRemoteDataSource(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ProgressRemoteDataSource value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ProgressRemoteDataSource>(value),
    );
  }
}

String _$progressRemoteDataSourceHash() =>
    r'd3cb20d9f78afbb0d7a49647017f36ae38a63dd7';

@ProviderFor(progressRepository)
final progressRepositoryProvider = ProgressRepositoryProvider._();

final class ProgressRepositoryProvider
    extends
        $FunctionalProvider<
          ProgressRepository,
          ProgressRepository,
          ProgressRepository
        >
    with $Provider<ProgressRepository> {
  ProgressRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'progressRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$progressRepositoryHash();

  @$internal
  @override
  $ProviderElement<ProgressRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  ProgressRepository create(Ref ref) {
    return progressRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ProgressRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ProgressRepository>(value),
    );
  }
}

String _$progressRepositoryHash() =>
    r'18339e247b56655e3b71688620cb97726e8ad047';

@ProviderFor(progressEntries)
final progressEntriesProvider = ProgressEntriesProvider._();

final class ProgressEntriesProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<ProgressEntry>>,
          List<ProgressEntry>,
          FutureOr<List<ProgressEntry>>
        >
    with
        $FutureModifier<List<ProgressEntry>>,
        $FutureProvider<List<ProgressEntry>> {
  ProgressEntriesProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'progressEntriesProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$progressEntriesHash();

  @$internal
  @override
  $FutureProviderElement<List<ProgressEntry>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<ProgressEntry>> create(Ref ref) {
    return progressEntries(ref);
  }
}

String _$progressEntriesHash() => r'282ee5bf9a94a9f781838db63aef16c26395a9ed';
