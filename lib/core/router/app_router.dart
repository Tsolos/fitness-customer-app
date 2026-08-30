import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../features/auth/presentation/providers/auth_controller.dart';
import '../../features/auth/presentation/providers/auth_state.dart';
import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/auth/presentation/screens/register_screen.dart';
import '../../features/contracts/presentation/screens/contracts_screen.dart';
import '../../features/home/presentation/screens/home_shell.dart';
import '../../features/profile/presentation/screens/profile_screen.dart';
import '../../features/progress/presentation/screens/progress_screen.dart';
import 'go_router_refresh_notifier.dart';
import 'route_paths.dart';

part 'app_router.g.dart';

@Riverpod(keepAlive: true)
GoRouter goRouter(Ref ref) {
  final refreshNotifier = GoRouterRefreshNotifier(ref);
  ref.onDispose(refreshNotifier.dispose);

  return GoRouter(
    initialLocation: RoutePaths.login,
    refreshListenable: refreshNotifier,
    redirect: (context, state) {
      final authState = ref.read(authControllerProvider);
      final isLoggingIn = state.matchedLocation == RoutePaths.login;
      final isRegistering = state.matchedLocation == RoutePaths.register;

      if (authState.status == AuthStatus.unknown) {
        // Still restoring the session (checking for a cached token) — don't redirect yet.
        return null;
      }
      if (authState.status != AuthStatus.authenticated && !isLoggingIn && !isRegistering) {
        return RoutePaths.login;
      }
      if (authState.status == AuthStatus.authenticated && (isLoggingIn || isRegistering)) {
        return RoutePaths.profile;
      }
      return null;
    },
    routes: [
      GoRoute(
        path: RoutePaths.login,
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: RoutePaths.register,
        builder: (context, state) => const RegisterScreen(),
      ),
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) => HomeShell(navigationShell: navigationShell),
        branches: [
          StatefulShellBranch(
            routes: [GoRoute(path: RoutePaths.profile, builder: (context, state) => const ProfileScreen())],
          ),
          StatefulShellBranch(
            routes: [GoRoute(path: RoutePaths.contracts, builder: (context, state) => const ContractsScreen())],
          ),
          StatefulShellBranch(
            routes: [GoRoute(path: RoutePaths.progress, builder: (context, state) => const ProgressScreen())],
          ),
        ],
      ),
    ],
  );
}
