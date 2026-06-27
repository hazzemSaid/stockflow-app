import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stockflow/core/company/company_cubit.dart';
import 'package:stockflow/core/company/company_state.dart';
import 'package:stockflow/features/auth/domain/entities/user.dart';
import 'package:stockflow/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:stockflow/features/auth/presentation/cubit/auth_state.dart';
import 'package:stockflow/features/companies/domain/entities/company.dart';
import 'package:stockflow/features/companies/domain/entities/company_member.dart';

class TestSetup {
  static void ensureInitialized() {}

  static AuthCubit createMockAuthCubit({
    bool authenticated = true,
  }) {
    return _MockAuthCubit(authenticated: authenticated);
  }

  static CompanyCubit createMockCompanyCubit({
    bool hasCompanies = true,
    bool selected = false,
  }) {
    return _MockCompanyCubit(hasCompanies: hasCompanies, selected: selected);
  }

  static Widget wrapWithProviders({
    required Widget child,
    AuthCubit? authCubit,
    CompanyCubit? companyCubit,
  }) {
    return MultiBlocProvider(
      providers: [
        if (authCubit != null)
          BlocProvider<AuthCubit>.value(value: authCubit),
        if (companyCubit != null)
          BlocProvider<CompanyCubit>.value(value: companyCubit),
      ],
      child: MaterialApp(
        home: child,
        supportedLocales: const [Locale('ar', 'EG')],
        locale: const Locale('ar', 'EG'),
      ),
    );
  }

  static Widget wrapWithApp({required Widget child}) {
    return MaterialApp(
      home: child,
      supportedLocales: const [Locale('ar', 'EG')],
      locale: const Locale('ar', 'EG'),
    );
  }

  static final _now = DateTime(2026, 6, 26);
}

class _MockAuthCubit extends Cubit<AuthState> implements AuthCubit {
  _MockAuthCubit({bool authenticated = true})
    : super(
        authenticated
            ? Authenticated(
                UserEntity(
                  id: 'test-user-id',
                  email: 'test@stockflow.eg',
                  name: 'أحمد محمد',
                ),
              )
            : Unauthenticated(),
      );

  @override
  Future<void> checkSession() async {}

  @override
  Future<void> signIn(String email, String password) async {}

  @override
  Future<void> signUp(String email, String password, String name) async {}

  @override
  Future<void> signOut() async {}
}

class _MockCompanyCubit extends Cubit<CompanyState> implements CompanyCubit {
  _MockCompanyCubit({bool hasCompanies = true, bool selected = false})
    : super(
        selected
            ? CompanySelected(
                company: Company(
                  id: 'test-company-id',
                  name: 'متجر اختبار',
                  createdAt: TestSetup._now,
                ),
                allCompanies: [
                  Company(
                    id: 'test-company-id',
                    name: 'متجر اختبار',
                    createdAt: TestSetup._now,
                  ),
                ],
              )
            : CompaniesLoaded(
                companies: hasCompanies
                    ? [
                        Company(
                          id: 'test-company-id',
                          name: 'متجر اختبار',
                          createdAt: TestSetup._now,
                        ),
                      ]
                    : [],
              ),
      );

  @override
  Future<void> loadCompanies() async {}

  @override
  Future<void> switchCompany(
    Company company, {
    CompanyMember? membership,
    List<Company>? allCompanies,
  }) async {}

  @override
  Future<void> clearCompany() async {}
}
