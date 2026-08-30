import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'auth_providers.dart';
import 'register_state.dart';

part 'register_controller.g.dart';

/// Screen-scoped (not `keepAlive`) — unlike [AuthController] this holds no
/// session, just the in-flight state of a single registration submission.
@riverpod
class RegisterController extends _$RegisterController {
  @override
  RegisterState build() => const RegisterState.idle();

  Future<void> submit({required String email, required String password}) async {
    state = const RegisterState.submitting();
    final result = await ref.read(registerUseCaseProvider).call(email: email, password: password);
    state = result.fold(
      (failure) => RegisterState.error(failure.message),
      (message) => RegisterState.submitted(message),
    );
  }

  void reset() => state = const RegisterState.idle();
}
