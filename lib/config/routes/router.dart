import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:stockflow/features/companies/presentation/cubit/company_settings_cubit.dart';
import '../../core/constants/app_routes.dart';
import '../../core/di/service_locator.dart';
import '../../core/company/company_cubit.dart';
import '../../core/company/company_state.dart';
import '../../features/auth/presentation/cubit/auth_cubit.dart';
import '../../features/auth/presentation/cubit/auth_state.dart';
import '../../features/auth/presentation/pages/splash_screen.dart';
import '../../features/auth/presentation/pages/login_screen.dart';
import '../../features/auth/presentation/pages/register_screen.dart';
import '../../features/auth/presentation/pages/company_selection_screen.dart';
import '../../features/auth/presentation/pages/create_company_screen.dart';
import '../../features/auth/presentation/pages/welcome_screen.dart';
import '../../features/auth/presentation/pages/join_business_screen.dart';
import '../../features/auth/presentation/pages/pending_approval_screen.dart';
import '../../features/companies/presentation/cubit/join_company_cubit.dart';
import '../../features/dashboard/presentation/pages/dashboard_screen.dart';
import '../../features/products/presentation/pages/products_screen.dart';
import '../../features/products/presentation/pages/add_edit_product_screen.dart';
import '../../features/products/presentation/pages/product_details_screen.dart';
import '../../features/customers/presentation/pages/customers_screen.dart';
import '../../features/customers/presentation/pages/add_edit_customer_screen.dart';
import '../../features/customers/presentation/pages/customer_details_screen.dart';
import '../../features/customers/presentation/pages/customer_invoices_screen.dart';
import '../../features/invoice/presentation/cubit/invoices/invoices_cubit.dart';
import '../../features/invoice/presentation/pages/invoices_screen.dart';
import '../../features/invoice/presentation/pages/create_invoice_screen.dart';
import '../../features/invoice/presentation/pages/add_payment_screen.dart';
import '../../features/invoice/presentation/pages/invoice_details_screen.dart';
import '../../features/companies/presentation/pages/company_settings_page.dart';
import '../../features/companies/presentation/pages/members_page.dart';
import '../../features/settings/presentation/pages/settings_screen.dart';
import '../../features/shell/presentation/pages/app_shell.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>();

final List<String> _authRoutes = [
  AppRoutes.splash,
  AppRoutes.login,
  AppRoutes.register,
];
final List<String> _companyRoutes = [
  AppRoutes.companySelect,
  AppRoutes.companyCreate,
  AppRoutes.welcome,
  AppRoutes.welcomeCreate,
  AppRoutes.welcomeJoin,
  AppRoutes.welcomePending,
];
final List<String> _protectedRoutes = [
  ...AppRoutes.shellRoutes,
  AppRoutes.productNew,
  AppRoutes.productDetails,
  AppRoutes.productEdit,
  AppRoutes.customerNew,
  AppRoutes.customerDetails,
  AppRoutes.customerEdit,
  AppRoutes.invoiceCreate,
  AppRoutes.invoiceDetails,
  AppRoutes.customerAddPayment,
  AppRoutes.customerInvoices,
  AppRoutes.companySettings,
  AppRoutes.members,
];

bool _isAuthRoute(String location) => _authRoutes.contains(location);
bool _isCompanyRoute(String location) => _companyRoutes.contains(location);
bool _isProtectedRoute(String location) => _protectedRoutes.any((route) {
  if (route == location) return true;
  if (route.contains(':id')) {
    final pattern = route.replaceAll(':id', '[^/]+');
    return RegExp('^$pattern\$').hasMatch(location);
  }
  return false;
});

final ChangeNotifier _authStateNotifier = _AuthStateNotifier();

class _AuthStateNotifier extends ChangeNotifier {
  _AuthStateNotifier() {
    sl<AuthCubit>().stream.listen((_) => notifyListeners());
    sl<CompanyCubit>().stream.listen((_) => notifyListeners());
  }
}

Page<void> _buildFullScreenPage<T>(GoRouterState state, Widget child) {
  return NoTransitionPage(key: state.pageKey, child: child);
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
      final companyCubit = sl<CompanyCubit>();
      final companyState = companyCubit.state;

      // Still loading company info — wait
      if (companyState is CompanyInitial) {
        companyCubit.loadCompanies();
        return null;
      }

      if (companyState is CompanyLoading) {
        return null;
      }

      // Company is selected — block auth screens and first-time setup flows
      if (companyState is CompanySelected) {
        final isBlockedCompanyRoute =
            _isCompanyRoute(location) &&
            location != AppRoutes.companyCreate &&
            location != AppRoutes.welcomeJoin;
        if (_isAuthRoute(location) || isBlockedCompanyRoute) {
          return AppRoutes.dashboard;
        }
        return null;
      }

      // Companies loaded but none selected yet
      if (companyState is CompaniesLoaded) {
        if (_isAuthRoute(location) || _isProtectedRoute(location)) {
          // No companies at all — show welcome (create/join)
          if (companyState.companies.isEmpty) {
            return AppRoutes.welcome;
          }
          // Has companies — let user pick one
          return AppRoutes.companySelect;
        }
        return null;
      }

      if (companyState is CompanyError && !_isCompanyRoute(location)) {
        return AppRoutes.companySelect;
      }

      return null;
    }

    // Not authenticated (Unauthenticated or AuthError)
    // If on splash, send to login. If already on login/register, stay put.
    if (location == AppRoutes.splash ||
        _isProtectedRoute(location) ||
        _isCompanyRoute(location)) {
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
      path: AppRoutes.companySelect,
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => const CompanySelectionScreen(),
    ),
    GoRoute(
      path: AppRoutes.companyCreate,
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => const CreateCompanyScreen(),
    ),
    GoRoute(
      path: AppRoutes.welcome,
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => const WelcomeScreen(),
    ),
    GoRoute(
      path: AppRoutes.welcomeCreate,
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => const CreateCompanyScreen(),
    ),
    GoRoute(
      path: AppRoutes.welcomeJoin,
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => const JoinBusinessScreen(),
    ),
    GoRoute(
      path: AppRoutes.welcomePending,
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) {
        final cubit = state.extra as JoinCompanyCubit;
        return PendingApprovalScreen(cubit: cubit);
      },
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
                  pageBuilder: (context, state) =>
                      _buildFullScreenPage(state, const AddEditProductScreen()),
                ),
                GoRoute(
                  path: ':id',
                  parentNavigatorKey: _rootNavigatorKey,
                  pageBuilder: (context, state) {
                    final id = state.pathParameters['id']!;
                    return _buildFullScreenPage(
                      state,
                      ProductDetailsScreen(productId: id),
                    );
                  },
                  routes: [
                    GoRoute(
                      path: 'edit',
                      parentNavigatorKey: _rootNavigatorKey,
                      pageBuilder: (context, state) {
                        final id = state.pathParameters['id']!;
                        return _buildFullScreenPage(
                          state,
                          AddEditProductScreen(productId: id),
                        );
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
              routes: [
                GoRoute(
                  path: 'add',
                  parentNavigatorKey: _rootNavigatorKey,
                  pageBuilder: (context, state) => _buildFullScreenPage(
                    state,
                    const AddEditCustomerScreen(),
                  ),
                ),
                GoRoute(
                  path: ':id',
                  parentNavigatorKey: _rootNavigatorKey,
                  pageBuilder: (context, state) {
                    final id = state.pathParameters['id']!;
                    return _buildFullScreenPage(
                      state,
                      CustomerDetailsScreen(customerId: id),
                    );
                  },
                  routes: [
                    GoRoute(
                      path: 'edit',
                      parentNavigatorKey: _rootNavigatorKey,
                      pageBuilder: (context, state) {
                        final id = state.pathParameters['id']!;
                        return _buildFullScreenPage(
                          state,
                          AddEditCustomerScreen(customerId: id),
                        );
                      },
                    ),
                    GoRoute(
                      path: 'payment',
                      parentNavigatorKey: _rootNavigatorKey,
                      pageBuilder: (context, state) {
                        final id = state.pathParameters['id']!;
                        final customerName = state.extra as String?;
                        return _buildFullScreenPage(
                          state,
                          AddPaymentScreen(
                            customerId: id,
                            customerName: customerName,
                          ),
                        );
                      },
                    ),
                    GoRoute(
                      path: 'invoices',
                      parentNavigatorKey: _rootNavigatorKey,
                      pageBuilder: (context, state) {
                        final id = state.pathParameters['id']!;
                        final customerName = state.extra as String? ?? '';
                        return _buildFullScreenPage(
                          state,
                          CustomerInvoicesScreen(
                            customerId: id,
                            customerName: customerName,
                          ),
                        );
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
              path: AppRoutes.invoices,
              builder: (context, state) => BlocProvider<InvoicesCubit>(
                create: (_) => sl<InvoicesCubit>(),
                child: const InvoicesScreen(),
              ),
              routes: [
                GoRoute(
                  path: 'create',
                  parentNavigatorKey: _rootNavigatorKey,
                  pageBuilder: (context, state) {
                    final extra = state.extra as Map<String, String>?;
                    final hasCustomer =
                        extra != null && extra.containsKey('customerId');
                    return _buildFullScreenPage(
                      state,
                      CreateInvoiceScreen(
                        preselectedCustomerId: extra?['customerId'],
                        preselectedCustomerName: extra?['customerName'],
                        lockCustomer: hasCustomer,
                      ),
                    );
                  },
                ),
                GoRoute(
                  path: ':id',
                  parentNavigatorKey: _rootNavigatorKey,
                  pageBuilder: (context, state) {
                    final id = state.pathParameters['id']!;
                    return _buildFullScreenPage(
                      state,
                      InvoiceDetailsScreen(invoiceId: id),
                    );
                  },
                ),
              ],
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: AppRoutes.settings,
              builder: (context, state) => const SettingsScreen(),
              routes: [
                GoRoute(
                  path: 'company',
                  parentNavigatorKey: _rootNavigatorKey,
                  pageBuilder: (context, state) => _buildFullScreenPage(
                    state,
                    BlocProvider(
                      create: (_) => sl<CompanySettingsCubit>(),
                      child: const CompanySettingsPage(),
                    ),
                  ),
                ),
                GoRoute(
                  path: 'members',
                  parentNavigatorKey: _rootNavigatorKey,
                  pageBuilder: (context, state) =>
                      _buildFullScreenPage(state, const MembersPage()),
                ),

              ],
            ),
          ],
        ),
      ],
    ),
  ],
);
