// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'register_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Screen-scoped (not `keepAlive`) — unlike [AuthController] this holds no
/// session, just the in-flight state of a single registration submission.

@ProviderFor(RegisterController)
final registerControllerProvider = RegisterControllerProvider._();

/// Screen-scoped (not `keepAlive`) — unlike [AuthController] this holds no
/// session, just the in-flight state of a single registration submission.
final class RegisterControllerProvider
    extends $NotifierProvider<RegisterController, RegisterState> {
  /// Screen-scoped (not `keepAlive`) — unlike [AuthController] this holds no
  /// session, just the in-flight state of a single registration submission.
  RegisterControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'registerControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$registerControllerHash();

  @$internal
  @override
  RegisterController create() => RegisterController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(RegisterState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<RegisterState>(value),
    );
  }
}

String _$registerControllerHash() =>
    r'b7e99aa4d89058342634e5b9c86173a57658f7ab';

/// Screen-scoped (not `keepAlive`) — unlike [AuthController] this holds no
/// session, just the in-flight state of a single registration submission.

abstract class _$RegisterController extends $Notifier<RegisterState> {
  RegisterState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<RegisterState, RegisterState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<RegisterState, RegisterState>,
              RegisterState,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
