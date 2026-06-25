import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../models/weekly_point.dart';

class WeeklySalesChart extends StatelessWidget {
  final List<WeeklyPoint> points;

  const WeeklySalesChart({super.key, required this.points});

  @override
  Widget build(BuildContext context) {
    final maxValue = points
        .map((point) => point.value)
        .reduce((a, b) => a > b ? a : b);
    const maxBarHeight = 90.0;
    final isRtl = Directionality.of(context) == TextDirection.rtl;

    return Container(
      padding: EdgeInsets.fromLTRB(
        AppSizes.spacingSmall,
        AppSizes.spacingMedium,
        AppSizes.spacingSmall,
        AppSizes.spacingSmall,
      ),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(AppSizes.radiusLarge),
        boxShadow: [
          BoxShadow(
            color: AppColors.textPrimary.withValues(alpha: 0.04),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: List.generate(points.length, (i) {
          final point = isRtl ? points[points.length - 1 - i] : points[i];
          final height = maxBarHeight * (point.value / maxValue);
          final isMax = point.value == maxValue;

          return Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 2.w),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    height: 16.h,
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        '${point.value}',
                        style: TextStyle(
                          fontFamily: 'Cairo',
                          fontSize: AppSizes.fontSmall,
                          fontWeight: point.isHighlighted
                              ? FontWeight.w700
                              : FontWeight.w600,
                          color: point.isHighlighted
                              ? AppColors.accent
                              : AppColors.primary,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Container(
                    width: 22.w,
                    height: height.clamp(4.0, maxBarHeight).h,
                    decoration: BoxDecoration(
                      color: point.isHighlighted
                          ? AppColors.accent
                          : AppColors.lightGreen,
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(4.r),
                        bottom: Radius.circular(isMax ? 0 : 4.r),
                      ),
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    point.label,
                    style: TextStyle(
                      fontFamily: 'Cairo',
                      fontSize: AppSizes.fontSmall,
                      fontWeight: point.isHighlighted
                          ? FontWeight.w700
                          : FontWeight.w400,
                      color: point.isHighlighted
                          ? AppColors.accent
                          : AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}

