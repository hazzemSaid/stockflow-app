import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../models/quick_action.dart';

class QuickActionCard extends StatelessWidget {
  final QuickAction action;

  const QuickActionCard({super.key, required this.action});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: action.onTap,
      child: Container(
        padding: EdgeInsets.symmetric(
          vertical: AppSizes.spacingSmall,
          horizontal: AppSizes.spacingSmall,
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
        child: Column(
          children: [
            Container(
              width: 40.w,
              height: 40.w,
              decoration: BoxDecoration(
                color: action.iconBackground,
                borderRadius: BorderRadius.circular(14.r),
              ),
              child: Icon(action.icon, color: action.iconColor, size: 18.w),
            ),
            SizedBox(height: AppSizes.spacingSmall),
            Text(
              action.label,
              style: TextStyle(
                fontFamily: 'Cairo',
                fontSize: AppSizes.fontSmall,
                color: AppColors.textPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

