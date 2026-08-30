import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../features/auth/presentation/providers/auth_controller.dart';
import '../../features/auth/presentation/providers/auth_state.dart';

/// Notifies [GoRouter] to re-evaluate its `redirect` whenever the auth
/// state changes, without recreating the router (which would drop the
/// navigation stack).
class GoRouterRefreshNotifier extends ChangeNotifier {
  GoRouterRefreshNotifier(Ref ref) {
    ref.listen<AuthState>(authControllerProvider, (previous, next) {
      if (previous?.status != next.status) {
        notifyListeners();
      }
    });
  }
}
