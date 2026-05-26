import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import '../../core/constants/app_routes.dart';
import '../../core/di/service_locator.dart';
import '../../features/auth/presentation/cubit/auth_cubit.dart';
import '../../features/auth/presentation/cubit/auth_state.dart';
import '../../features/auth/presentation/pages/splash_screen.dart';
import '../../features/auth/presentation/pages/login_screen.dart';
import '../../features/auth/presentation/pages/register_screen.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>();

final List<String> _authRoutes = [
  AppRoutes.splash,
  AppRoutes.login,
  AppRoutes.register,
];
final List<String> _protectedRoutes = [AppRoutes.dashboard];

bool _isAuthRoute(String location) => _authRoutes.contains(location);
bool _isProtectedRoute(String location) => _protectedRoutes.contains(location);

final ChangeNotifier _authStateNotifier = _AuthStateNotifier();

class _AuthStateNotifier extends ChangeNotifier {
  _AuthStateNotifier() {
    sl<AuthCubit>().stream.listen((_) => notifyListeners());
  }
}

final GoRouter appRouter = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: AppRoutes.splash,
  refreshListenable: _authStateNotifier,
  redirect: (context, state) {
    final authCubit = sl<AuthCubit>();
    final authState = authCubit.state;
    final location = state.matchedLocation;

    if (authState is AuthInitial || authState is AuthLoading) {
      return null;
    }

    if (authState is Authenticated) {
      if (_isAuthRoute(location)) {
        return AppRoutes.dashboard;
      }
      return null;
    }

    if (_isProtectedRoute(location)) {
      return AppRoutes.login;
    }

    return null;
  },
  routes: [
    GoRoute(
      path: AppRoutes.splash,
      builder: (context, state) => const SplashScreen(),
    ),
    GoRoute(
      path: AppRoutes.login,
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: AppRoutes.register,
      builder: (context, state) => const RegisterScreen(),
    ),
    GoRoute(
      path: AppRoutes.dashboard,
      builder: (context, state) {
        final authCubit = context.read<AuthCubit>();
        final userName = authCubit.state is Authenticated
            ? (authCubit.state as Authenticated).user.name
            : 'User';
        return Scaffold(
          appBar: AppBar(title: Text('Welcome, $userName!')),
          body: Center(
            child: TextButton.icon(
              icon: const Icon(Icons.logout),
              label: const Text('Logout'),
              onPressed: () => authCubit.signOut(),
            ),
          ),
        );
      },
    ),
  ],
);
