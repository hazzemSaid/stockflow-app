import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_strings.dart';

class CustomerListHeader extends StatelessWidget {
  final int totalCount;
  final double totalDebt;

  const CustomerListHeader({
    super.key,
    required this.totalCount,
    required this.totalDebt,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: AppSizes.spacingMedium,
        right: AppSizes.spacingMedium,
        top: AppSizes.spacingMedium,
        bottom: AppSizes.spacingSmall,
      ),
      child: Row(
        textDirection: TextDirection.rtl,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppStrings.customersTitle,
                  style: TextStyle(
                    fontFamily: 'Cairo',
                    fontSize: AppSizes.fontXXLarge,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                SizedBox(height: AppSizes.spacingTiny),
                Text(
                  '$totalCount ${AppStrings.customerStore}',
                  style: TextStyle(
                    fontFamily: 'Cairo',
                    fontSize: AppSizes.fontMedium,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: AppSizes.spacingSmall),
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: AppSizes.spacingSmall,
              vertical: 4.h,
            ),
            decoration: BoxDecoration(
              color: AppColors.lightOrange,
              borderRadius: BorderRadius.circular(AppSizes.radiusSmall),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.account_balance_wallet_outlined,
                  size: AppSizes.iconSmall,
                  color: AppColors.accent,
                ),
                SizedBox(width: AppSizes.spacingSmall),
                Text(
                  '${AppStrings.customerDebtsLabel}: ${totalDebt.toStringAsFixed(0)} ${AppStrings.currencyEg}',
                  style: TextStyle(
                    fontFamily: 'Cairo',
                    fontSize: AppSizes.fontMedium,
                    fontWeight: FontWeight.w600,
                    color: AppColors.accent,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
