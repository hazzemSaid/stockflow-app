import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:stockflow/core/company/company_cubit.dart';
import 'package:stockflow/core/company/company_state.dart';
import 'package:stockflow/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:stockflow/core/constants/app_colors.dart';
import 'package:stockflow/core/constants/app_sizes.dart';
import 'package:stockflow/core/constants/app_routes.dart';
import 'package:stockflow/core/constants/app_strings.dart';
import 'package:stockflow/core/widgets/action_row.dart';
import 'package:stockflow/core/widgets/app_network_image.dart';
import 'package:stockflow/core/widgets/company_card.dart';
import 'package:stockflow/features/companies/domain/entities/company.dart';

class CompanySwitcher extends StatefulWidget {
  const CompanySwitcher({super.key});

  @override
  State<CompanySwitcher> createState() => _CompanySwitcherState();
}

class _CompanySwitcherState extends State<CompanySwitcher> {
  @override
  void initState() {
    super.initState();
    final state = context.read<CompanyCubit>().state;
    if (state is CompanyInitial) {
      context.read<CompanyCubit>().loadCompanies();
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CompanyCubit, CompanyState>(
      builder: (context, state) {
        Company? selectedCompany;

        if (state is CompaniesLoaded) {
          selectedCompany = null;
        } else if (state is CompanySelected) {
          selectedCompany = state.company;
        }

        return GestureDetector(
          onTap: _showCompanySwitcherSheet,
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: AppSizes.spacingMedium,
              vertical: AppSizes.spacingSmall,
            ),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
            ),
            child: Row(
              children: [
                AppNetworkImage(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppSizes.radiusSmall),
                  ),
                  imageUrl: selectedCompany?.logoUrl ?? '',
                  width: AppSizes.iconMedium,
                  height: AppSizes.iconMedium,
                  errorBuilder: (context, error, stackTrace) => Icon(
                    Icons.business,
                    color: AppColors.primary,
                    size: AppSizes.iconMedium,
                  ),
                ),
                SizedBox(width: AppSizes.spacingSmall),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        selectedCompany?.name ?? AppStrings.selectCompany,
                        style: TextStyle(
                          fontSize: AppSizes.fontMedium,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(Icons.swap_horiz, color: AppColors.grey),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showCompanySwitcherSheet() {
    final state = context.read<CompanyCubit>().state;
    final companies = switch (state) {
      CompaniesLoaded(:final companies) => companies,
      CompanySelected(:final allCompanies) =>
        allCompanies.isNotEmpty ? allCompanies : [state.company],
      _ => <Company>[],
    };
    final selected = switch (state) {
      CompanySelected(:final company) => company,
      _ => null,
    };
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppSizes.radiusXLarge),
        ),
      ),
      builder: (_) => SafeArea(
        child: SizedBox(
          height: 510.h,
          child: Padding(
            padding: EdgeInsets.fromLTRB(
              AppSizes.spacingMedium,
              0,
              AppSizes.spacingMedium,
              AppSizes.spacingMedium,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  alignment: Alignment.center,
                  padding: EdgeInsets.only(top: 12.h, bottom: 4.h),
                  child: Container(
                    width: 40.w,
                    height: 4.h,
                    decoration: BoxDecoration(
                      color: AppColors.gripColor,
                      borderRadius: BorderRadius.circular(9999),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 4.h),
                  child: Text(
                    AppStrings.selectBusiness,
                    style: TextStyle(
                      fontFamily: 'Cairo',
                      fontSize: AppSizes.fontLarge,
                      fontWeight: FontWeight.w400,
                      color: AppColors.secondary,
                    ),
                  ),
                ),
                Expanded(
                  child: companies.isEmpty && state is! CompanyLoading
                      ? Center(
                          child: Text(
                            'لا توجد شركات',
                            style: TextStyle(
                              color: AppColors.textSecondary,
                              fontSize: AppSizes.fontMedium,
                            ),
                          ),
                        )
                      : ListView(
                          children: [
                            ...companies.asMap().entries.map((entry) {
                              final i = entry.key;
                              final company = entry.value;
                              final isSelected = selected?.id == company.id;
                              return Padding(
                                padding: EdgeInsets.only(
                                  top: i == 0 ? 0 : 10.h,
                                ),
                                child: CompanyCard(
                                  company: company,
                                  isSelected: isSelected,
                                  onTap: () {
                                    final router = GoRouter.of(context);
                                    context.read<CompanyCubit>().switchCompany(
                                      company,
                                    );
                                    Navigator.pop(context);
                                    Future.microtask(() {
                                      router.go(AppRoutes.dashboard);
                                    });
                                  },
                                ),
                              );
                            }),
                            Padding(
                              padding: EdgeInsets.only(
                                top: AppSizes.spacingMedium,
                              ),
                              child: Divider(
                                color: AppColors.searchBg,
                                height: 1,
                                thickness: 1,
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(
                                top: AppSizes.spacingMedium,
                              ),
                              child: ActionRow(
                                icon: Icons.add,
                                label: AppStrings.createNewBusiness,
                                iconBg: AppColors.lightGreen,
                                iconColor: AppColors.primary,
                                labelColor: AppColors.primary,
                                onTap: () {
                                  final router = GoRouter.of(context);
                                  Navigator.pop(context);
                                  router.push(AppRoutes.companyCreate);
                                },
                              ),
                            ),
                            ActionRow(
                              icon: Icons.person_add_alt_1,
                              label: AppStrings.joinByCode,
                              iconBg: AppColors.blueLight,
                              iconColor: AppColors.bluePrimary,
                              labelColor: AppColors.bluePrimary,
                              onTap: () {
                                final router = GoRouter.of(context);
                                Navigator.pop(context);
                                router.push(AppRoutes.welcomeJoin);
                              },
                              showTopPadding: true,
                            ),
                            ActionRow(
                              icon: Icons.logout_rounded,
                              label: AppStrings.signOut,
                              iconBg: AppColors.lightRed,
                              iconColor: AppColors.redDark,
                              labelColor: AppColors.redDark,
                              onTap: () {
                                Navigator.pop(context);
                                context.read<CompanyCubit>().clearCompany();
                                context.read<AuthCubit>().signOut();
                              },
                              showTopPadding: true,
                            ),
                          ],
                        ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
