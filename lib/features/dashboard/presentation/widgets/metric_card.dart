import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../models/dashboard_metric.dart';

class MetricCard extends StatelessWidget {
  final DashboardMetric metric;

  const MetricCard({
    super.key,
    required this.metric,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding:  EdgeInsets.all(AppSizes.spacingSmall),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: 32.w,
                height: 32.w,
                decoration: BoxDecoration(
                  color: metric.iconBackground,
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child:
                    Icon(metric.icon, size: 16.w, color: metric.iconColor),
              ),
            ],
          ),
          SizedBox(height: AppSizes.spacingSmall),
          Text(
            metric.title,
            style:  TextStyle(
              fontFamily: 'Cairo',
              fontSize: AppSizes.fontSmall,
              color: AppColors.textSecondary,
            ),
          ),
          SizedBox(height: AppSizes.spacingTiny),
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: metric.value,
                  style: TextStyle(
                    fontFamily: 'Cairo',
                    fontSize: AppSizes.fontXLarge,
                    color: metric.valueColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (metric.currency != null) ...[
                  const TextSpan(text: ' '),
                  TextSpan(
                    text: metric.currency,
                    style:  TextStyle(
                      fontFamily: 'Cairo',
                      fontSize: AppSizes.fontSmall,
                      color: AppColors.textSecondary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
