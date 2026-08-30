import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'session_events.g.dart';

/// Ticks up whenever the API responds 401. [AuthController] listens to
/// this to force a logout, without core/ needing to import features/auth.
@Riverpod(keepAlive: true)
class SessionExpired extends _$SessionExpired {
  @override
  int build() => 0;

  void bump() => state++;
}
