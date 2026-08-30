import 'package:equatable/equatable.dart';

enum RegisterStatus { idle, submitting, submitted, error }

class RegisterState extends Equatable {
  const RegisterState({required this.status, this.message});

  const RegisterState.idle() : this(status: RegisterStatus.idle);

  const RegisterState.submitting() : this(status: RegisterStatus.submitting);

  /// [message] is the server's (deliberately generic) confirmation text —
  /// shown as-is, e.g. "check your inbox".
  const RegisterState.submitted(String message) : this(status: RegisterStatus.submitted, message: message);

  const RegisterState.error(String message) : this(status: RegisterStatus.error, message: message);

  final RegisterStatus status;
  final String? message;

  @override
  List<Object?> get props => [status, message];
}
