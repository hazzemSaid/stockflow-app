import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_strings.dart';

class DashboardHeader extends StatelessWidget {
  final String userName;
  final String userInitial;

  const DashboardHeader({
    super.key,
    required this.userName,
    required this.userInitial,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        padding: EdgeInsets.fromLTRB(
          AppSizes.spacingMedium,
          AppSizes.spacingSmall,
          AppSizes.spacingMedium,
          AppSizes.spacingMedium,
        ),
        decoration: BoxDecoration(
          color: AppColors.primary,
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(AppSizes.radiusXLarge),
          ),
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppStrings.dashboardGreeting,
                      style: TextStyle(
                        fontFamily: 'Cairo',
                        fontSize: AppSizes.fontSmall,
                        color: AppColors.white.withOpacity(0.7),
                      ),
                    ),
                    Text(
                      userName.isEmpty ? AppStrings.appNameArabic : userName,
                      style: TextStyle(
                        fontFamily: 'Cairo',
                        fontSize: AppSizes.fontXLarge,
                        color: AppColors.white,
                      ),
                    ),
                  ],
                ),

              ],
            ),
            SizedBox(height: AppSizes.spacingMedium),
            Container(
              padding: EdgeInsets.all(AppSizes.spacingSmall),
              decoration: BoxDecoration(
                color: AppColors.white.withOpacity(0.1),
                borderRadius: BorderRadius.all(
                  Radius.circular(AppSizes.radiusLarge),
                ),
                border: Border.all(
                  color: AppColors.white.withOpacity(0.15),
                  width: 1,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppStrings.dashboardTodaySales,
                    style: TextStyle(
                      fontFamily: 'Cairo',
                      fontSize: AppSizes.fontSmall,
                      color: AppColors.white,
                    ),
                  ),
                  SizedBox(height: AppSizes.spacingTiny),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const _TodaySalesAmount(),
                      const _TodaySalesTrend(),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TodaySalesAmount extends StatelessWidget {
  const _TodaySalesAmount();

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        children: [
          TextSpan(
            text: '24,500',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontFamily: 'Cairo',
              fontSize: AppSizes.fontXXLarge,
              color: AppColors.white,
            ),
          ),
          const TextSpan(text: ' '),
          TextSpan(
            text: AppStrings.currencyEg,
            style: TextStyle(
              fontFamily: 'Cairo',
              fontSize: AppSizes.fontSmall,
              color: AppColors.white,
            ),
          ),
        ],
      ),
    );
  }
}

class _TodaySalesTrend extends StatelessWidget {
  const _TodaySalesTrend();

  @override
  Widget build(BuildContext context) {
    const trendColor = Color(0xFFFDBA74);

    return Row(
      children: [
        Text(
          '+12.4%',
          style: TextStyle(
            fontFamily: 'Cairo',
            fontSize: AppSizes.fontSmall,
            color: trendColor,
          ),
        ),
        SizedBox(width: AppSizes.spacingTiny),
        Icon(
          Icons.trending_up,
          size: 14.w,
          color: trendColor,
        ),
      ],
    );
  }
}
