import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:stockflow/core/company/company_cubit.dart';
import 'package:stockflow/core/constants/app_colors.dart';
import 'package:stockflow/core/constants/app_sizes.dart';
import 'package:stockflow/core/constants/app_routes.dart';
import 'package:stockflow/core/constants/app_strings.dart';
import 'package:stockflow/core/di/service_locator.dart';
import 'package:stockflow/features/companies/presentation/cubit/join_company_cubit.dart';

class PendingApprovalScreen extends StatefulWidget {
  final String requestId;
  final String companyId;
  final String companyName;
  final String? companyLogo;

  const PendingApprovalScreen({
    super.key,
    required this.requestId,
    required this.companyId,
    required this.companyName,
    this.companyLogo,
  });

  @override
  State<PendingApprovalScreen> createState() => _PendingApprovalScreenState();
}

class _PendingApprovalScreenState extends State<PendingApprovalScreen> {
  late final JoinCompanyCubit _cubit;

  @override
  void initState() {
    super.initState();
    _cubit = sl<JoinCompanyCubit>();
    _cubit.resumePolling(
      requestId: widget.requestId,
      companyId: widget.companyId,
      companyName: widget.companyName,
      companyLogo: widget.companyLogo,
    );
  }

  @override
  void dispose() {
    _cubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _cubit,
      child: BlocListener<JoinCompanyCubit, JoinCompanyState>(
        listener: (context, state) async {
          if (state is JoinCompanyApproved) {
            await context.read<CompanyCubit>().loadCompanies(selectCompanyId: state.companyId);
            if (context.mounted) {
              context.go(AppRoutes.dashboard);
            }
          } else if (state is JoinCompanyInitial) {
            context.go(AppRoutes.welcomeJoin);
          }
        },
        child: Scaffold(
          backgroundColor: AppColors.appBackground,
          body: Center(
            child: Padding(
              padding: EdgeInsets.all(AppSizes.spacingXLarge),
              child: BlocBuilder<JoinCompanyCubit, JoinCompanyState>(
                builder: (context, state) {
                  return switch (state) {
                    JoinCompanyRejected() => _buildRejected(context),
                    JoinCompanyInitial() => _buildCancelled(),
                    JoinCompanyRequestData() => _buildPending(context, state),
                    _ => _buildPending(context, null),
                  };
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPending(BuildContext context, JoinCompanyRequestData? data) {
    return Column(
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
        SizedBox(height: AppSizes.spacingXLarge * 2),
        SizedBox(
          width: double.infinity,
          child: OutlinedButton.icon(
            onPressed: () {
              _cubit.cancelJoinRequest(data?.requestId ?? widget.requestId);
            },
            icon: Icon(Icons.close, size: AppSizes.iconMedium),
            label: Text(AppStrings.cancelButton),
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.redDark,
              side: BorderSide(color: AppColors.redDark),
              padding: EdgeInsets.all(AppSizes.spacingMedium),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppSizes.radiusLarge),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRejected(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.cancel_outlined,
          size: AppSizes.iconXLarge * 2,
          color: AppColors.redDark,
        ),
        SizedBox(height: AppSizes.spacingXLarge),
        Text(
          AppStrings.requestRejected,
          style: TextStyle(
            fontSize: AppSizes.fontXXLarge,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        SizedBox(height: AppSizes.spacingMedium),
        Text(
          'لم يتم الموافقة على طلب الانضمام',
          style: TextStyle(
            fontSize: AppSizes.fontMedium,
            color: AppColors.textSecondary,
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: AppSizes.spacingXLarge * 2),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: () {
              context.go(AppRoutes.welcomeJoin);
            },
            icon: Icon(Icons.refresh, size: AppSizes.iconMedium),
            label: Text(AppStrings.retry),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: AppColors.white,
              padding: EdgeInsets.all(AppSizes.spacingMedium),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppSizes.radiusLarge),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCancelled() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.info_outline,
          size: AppSizes.iconXLarge * 2,
          color: AppColors.textSecondary,
        ),
        SizedBox(height: AppSizes.spacingXLarge),
        Text(
          'تم إلغاء الطلب',
          style: TextStyle(
            fontSize: AppSizes.fontXXLarge,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
      ],
    );
  }
}
