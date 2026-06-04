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
import '../../features/dashboard/presentation/pages/dashboard_screen.dart';
import '../../features/products/presentation/pages/products_screen.dart';
import '../../features/products/presentation/pages/add_edit_product_screen.dart';
import '../../features/products/presentation/pages/product_details_screen.dart';
import '../../features/customers/presentation/pages/customers_screen.dart';
import '../../features/invoices/presentation/pages/invoices_screen.dart';
import '../../features/settings/presentation/pages/settings_screen.dart';
import '../../features/shell/presentation/pages/app_shell.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>();

final List<String> _authRoutes = [
  AppRoutes.splash,
  AppRoutes.login,
  AppRoutes.register,
];
final List<String> _protectedRoutes = [
  ...AppRoutes.shellRoutes,
  AppRoutes.productNew,
  AppRoutes.productDetails,
  AppRoutes.productEdit,
];

bool _isAuthRoute(String location) => _authRoutes.contains(location);
bool _isProtectedRoute(String location) => _protectedRoutes.any(
  (route) {
    if (route == location) return true;
    if (route.contains(':id')) {
      final pattern = route.replaceAll(':id', '[^/]+');
      return RegExp('^$pattern\$').hasMatch(location);
    }
    return false;
  },
);

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
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) =>
          AppShell(navigationShell: navigationShell),
      branches: [
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: AppRoutes.dashboard,
              builder: (context, state) => const DashboardScreen(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: AppRoutes.products,
              builder: (context, state) => const ProductsScreen(),
              routes: [
                GoRoute(
                  path: 'new',
                  parentNavigatorKey: _rootNavigatorKey,
                  builder: (context, state) => const AddEditProductScreen(),
                ),
                GoRoute(
                  path: ':id',
                  parentNavigatorKey: _rootNavigatorKey,
                  builder: (context, state) {
                    final id = state.pathParameters['id']!;
                    return ProductDetailsScreen(productId: id);
                  },
                  routes: [
                    GoRoute(
                      path: 'edit',
                      parentNavigatorKey: _rootNavigatorKey,
                      builder: (context, state) {
                        final id = state.pathParameters['id']!;
                        return AddEditProductScreen(productId: id);
                      },
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: AppRoutes.customers,
              builder: (context, state) => const CustomersScreen(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: AppRoutes.invoices,
              builder: (context, state) => const InvoicesScreen(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: AppRoutes.settings,
              builder: (context, state) => const SettingsScreen(),
            ),
          ],
        ),
      ],
    ),
  ],
);
