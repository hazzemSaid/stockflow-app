import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:makhzanflow/core/company/company_cubit.dart';
import 'package:makhzanflow/core/company/company_state.dart';
import 'package:makhzanflow/core/constants/app_colors.dart';
import 'package:makhzanflow/core/constants/app_sizes.dart';
import 'package:makhzanflow/core/constants/app_strings.dart';
import 'package:makhzanflow/core/constants/app_routes.dart';
import 'package:makhzanflow/core/widgets/app_snackbar.dart';
import 'package:makhzanflow/features/companies/domain/entities/company.dart';

class CompanySelectionScreen extends StatefulWidget {
  const CompanySelectionScreen({super.key});

  @override
  State<CompanySelectionScreen> createState() => _CompanySelectionScreenState();
}

class _CompanySelectionScreenState extends State<CompanySelectionScreen> {
  @override
  void initState() {
    super.initState();
    debugPrint('[CompanySelectionScreen] initState — calling loadCompanies');
    context.read<CompanyCubit>().loadCompanies();
  }

  Future<void> _selectCompany(Company company) async {
    debugPrint('[CompanySelectionScreen] _selectCompany — id=${company.id}, name=${company.name}, businessType=${company.businessType}, logoUrl=${company.logoUrl}, inviteCode=${company.inviteCode}');
    await context.read<CompanyCubit>().switchCompany(company);
    if (!mounted) return;
    context.go(AppRoutes.dashboard);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.appBackground,
        body: BlocConsumer<CompanyCubit, CompanyState>(
          listener: (context, state) {
          debugPrint('[CompanySelectionScreen] listener — state=$state');
          if (state is CompaniesLoaded) {
            debugPrint('[CompanySelectionScreen] CompaniesLoaded — count=${state.companies.length}');
            for (final c in state.companies) {
              debugPrint('  company: id=${c.id}, name=${c.name}, status=${c.status}');
            }
            if (state.companies.isEmpty) {
              debugPrint('[CompanySelectionScreen] no companies — redirecting to /welcome');
              context.go(AppRoutes.welcome);
            }
          } else if (state is CompanyError) {
            AppSnackbar.error(context, state.message);
          }
        },
        builder: (context, state) {
          if (state is CompanyLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is CompaniesLoaded && state.companies.isNotEmpty) {
            return SafeArea(
              child: Padding(
                padding: EdgeInsets.all(AppSizes.spacingLarge),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: AppSizes.spacingXLarge * 2),
                    Text(
                      AppStrings.selectCompany,
                      style: TextStyle(
                        fontSize: AppSizes.fontXXLarge,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    SizedBox(height: AppSizes.spacingSmall),
                    Text(
                      AppStrings.selectCompanySubtitle,
                      style: TextStyle(
                        fontSize: AppSizes.fontLarge,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    SizedBox(height: AppSizes.spacingXLarge),
                    Expanded(
                      child: ListView.separated(
                        itemCount: state.companies.length,
                        separatorBuilder: (_, _) =>
                            SizedBox(height: AppSizes.spacingMedium),
                        itemBuilder: (context, index) {
                          final company = state.companies[index];
                          return Card(
                            color: AppColors.white,
                            child: ListTile(
                              contentPadding: EdgeInsets.all(
                                AppSizes.spacingMedium,
                              ),
                              title: Text(
                                company.name,
                                style: TextStyle(
                                  fontSize: AppSizes.fontXLarge,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                              subtitle: company.address != null
                                  ? Text(
                                      company.address!,
                                      style: TextStyle(
                                        fontSize: AppSizes.fontMedium,
                                        color: AppColors.textSecondary,
                                      ),
                                    )
                                  : null,
                              trailing: Icon(
                                Icons.arrow_forward_ios,
                                color: AppColors.primary,
                              ),
                              onTap: () => _selectCompany(company),
                            ),
                          );
                        },
                      ),
                    ),
                    SizedBox(height: AppSizes.spacingMedium),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: () => context.go(AppRoutes.welcomeCreate),
                        icon: Icon(Icons.business_outlined, color: AppColors.white),
                        label: Text(
                          AppStrings.createCompany,
                          style: TextStyle(
                            fontSize: AppSizes.fontLarge,
                            color: AppColors.white,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          padding: EdgeInsets.all(AppSizes.spacingMedium),
                        ),
                      ),
                    ),
                    SizedBox(height: AppSizes.spacingSmall),
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton.icon(
                        onPressed: () => context.go(AppRoutes.welcomeJoin),
                        icon: Icon(Icons.group_add_outlined, color: AppColors.primary),
                        label: Text(
                          AppStrings.joinCompany,
                          style: TextStyle(
                            fontSize: AppSizes.fontLarge,
                            color: AppColors.primary,
                          ),
                        ),
                        style: OutlinedButton.styleFrom(
                          padding: EdgeInsets.all(AppSizes.spacingMedium),
                          side: BorderSide(color: AppColors.primary),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }

          if (state is CompanyError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    state.message,
                    style: TextStyle(
                      fontSize: AppSizes.fontLarge,
                      color: AppColors.error,
                    ),
                  ),
                  SizedBox(height: AppSizes.spacingMedium),
                  ElevatedButton(
                    onPressed: () =>
                        context.read<CompanyCubit>().loadCompanies(),
                    child: Text(AppStrings.retry, style: TextStyle()),
                  ),
                ],
              ),
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }
}
