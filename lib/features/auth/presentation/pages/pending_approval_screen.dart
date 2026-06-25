import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:stockflow/core/constants/app_colors.dart';
import 'package:stockflow/core/constants/app_sizes.dart';
import 'package:stockflow/core/constants/app_routes.dart';
import 'package:stockflow/core/constants/app_strings.dart';
import 'package:stockflow/features/companies/presentation/cubit/join_company_cubit.dart';

class PendingApprovalScreen extends StatelessWidget {
  /// The cubit is passed from [JoinBusinessScreen] via route extra so that
  /// the same polling instance is reused here — not a new factory instance.
  final JoinCompanyCubit cubit;

  const PendingApprovalScreen({super.key, required this.cubit});

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: cubit,
      child: BlocListener<JoinCompanyCubit, JoinCompanyState>(
        listener: (context, state) {
          if (state is JoinCompanyApproved) {
            context.go(AppRoutes.dashboard);
          }
        },
        child: Scaffold(
          backgroundColor: AppColors.appBackground,
          body: Center(
            child: Padding(
              padding: EdgeInsets.all(AppSizes.spacingXLarge),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.hourglass_empty_outlined,
                    size: AppSizes.iconXLarge * 2,
                    color: AppColors.secondary,
                  ),
                  SizedBox(height: AppSizes.spacingXLarge),
                  Text(
                    AppStrings.pendingTitle,
                    style: TextStyle(
                      fontSize: AppSizes.fontXXLarge,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  SizedBox(height: AppSizes.spacingMedium),
                  Text(
                    AppStrings.pendingSubtitle,
                    style: TextStyle(
                      fontSize: AppSizes.fontMedium,
                      color: AppColors.textSecondary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: AppSizes.spacingXLarge * 2),
                  CircularProgressIndicator(
                    color: AppColors.primary,
                  ),
                  SizedBox(height: AppSizes.spacingMedium),
                  Text(
                    AppStrings.pendingChecking,
                    style: TextStyle(
                      fontSize: AppSizes.fontSmall,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
