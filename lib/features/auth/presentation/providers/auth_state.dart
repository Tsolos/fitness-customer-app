import 'package:equatable/equatable.dart';

enum AuthStatus { unknown, authenticated, unauthenticated }

class AuthState extends Equatable {
  const AuthState({required this.status, this.errorMessage});

  const AuthState.unknown() : this(status: AuthStatus.unknown);

  const AuthState.authenticated() : this(status: AuthStatus.authenticated);

  const AuthState.unauthenticated([String? message]) : this(status: AuthStatus.unauthenticated, errorMessage: message);

  final AuthStatus status;
  final String? errorMessage;

  bool get isAuthenticated => status == AuthStatus.authenticated;

  @override
  List<Object?> get props => [status, errorMessage];
}
