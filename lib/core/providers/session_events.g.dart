// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'session_events.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Ticks up whenever the API responds 401. [AuthController] listens to
/// this to force a logout, without core/ needing to import features/auth.

@ProviderFor(SessionExpired)
final sessionExpiredProvider = SessionExpiredProvider._();

/// Ticks up whenever the API responds 401. [AuthController] listens to
/// this to force a logout, without core/ needing to import features/auth.
final class SessionExpiredProvider
    extends $NotifierProvider<SessionExpired, int> {
  /// Ticks up whenever the API responds 401. [AuthController] listens to
  /// this to force a logout, without core/ needing to import features/auth.
  SessionExpiredProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'sessionExpiredProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$sessionExpiredHash();

  @$internal
  @override
  SessionExpired create() => SessionExpired();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(int value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<int>(value),
    );
  }
}

String _$sessionExpiredHash() => r'1e55fd2b75ee7c05057a64ba9ecca00b0388ee96';

/// Ticks up whenever the API responds 401. [AuthController] listens to
/// this to force a logout, without core/ needing to import features/auth.

abstract class _$SessionExpired extends $Notifier<int> {
  int build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<int, int>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<int, int>,
              int,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
