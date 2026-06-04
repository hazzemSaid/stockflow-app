import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_strings.dart';

class ProfitSummaryCard extends StatelessWidget {
  const ProfitSummaryCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(AppSizes.spacingSmall),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(AppSizes.radiusLarge),
        boxShadow: [
          BoxShadow(
            color: AppColors.textPrimary.withOpacity(0.04),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppStrings.dashboardTodayProfit,
                  style: TextStyle(
                    fontFamily: 'Cairo',
                    fontSize: AppSizes.fontLarge,
                    color: AppColors.secondary,
                  ),
                ),
                Text(
                  AppStrings.dashboardTodayProfitSubtitle,
                  style: TextStyle(
                    fontFamily: 'Cairo',
                    fontSize: AppSizes.fontSmall,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: AppSizes.spacingSmall),
          const _ProfitAmount(),
        ],
      ),
    );
  }
}

class _ProfitAmount extends StatelessWidget {
  const _ProfitAmount();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        FittedBox(
          fit: BoxFit.scaleDown,
          child: RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: '5,650',
                  style: TextStyle(
                    fontFamily: 'Cairo',
                    fontSize: AppSizes.fontXLarge,
                    color: AppColors.primary,
                  ),
                ),
                TextSpan(text: ' '),
                TextSpan(
                  text: AppStrings.currencyEg,
                  style: TextStyle(
                    fontFamily: 'Cairo',
                    fontSize: AppSizes.fontSmall,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ),
        SizedBox(width: AppSizes.spacingSmall),
        Container(
          width: 40.w,
          height: 40.w,
          decoration: BoxDecoration(
            color: AppColors.lightOrange,
            borderRadius: BorderRadius.circular(14.r),
          ),
          child: const Icon(
            Icons.trending_up,
            color: AppColors.accent,
            size: 20,
          ),
        ),
      ],
    );
  }
}
