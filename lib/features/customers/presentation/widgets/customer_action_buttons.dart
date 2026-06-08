import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_strings.dart';

class CustomerActionButtons extends StatelessWidget {
  final VoidCallback? onNewInvoice;
  final VoidCallback? onRecordPayment;

  const CustomerActionButtons({
    super.key,
    this.onNewInvoice,
    this.onRecordPayment,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton.icon(
              onPressed: onNewInvoice,
              icon: Icon(Icons.add, size: 15.w, color: AppColors.secondary),
              label: Text(
                AppStrings.customerNewInvoice,
                style: TextStyle(
                  fontFamily: 'Cairo',
                  fontSize: AppSizes.fontMedium,
                  fontWeight: FontWeight.w500,
                  color: AppColors.secondary,
                ),
              ),
              style: OutlinedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 12.h),
                side: const BorderSide(color: AppColors.inputBorder),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
                ),
              ),
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: ElevatedButton.icon(
              onPressed: onRecordPayment,
              icon: Icon(Icons.add, size: 15.w, color: AppColors.white),
              label: Text(
                AppStrings.customerRecordPayment,
                style: TextStyle(
                  fontFamily: 'Cairo',
                  fontSize: AppSizes.fontMedium,
                  fontWeight: FontWeight.w500,
                  color: AppColors.white,
                ),
              ),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 12.h),
                backgroundColor: AppColors.accent,
                foregroundColor: AppColors.white,
                elevation: 8,
                shadowColor: AppColors.accent.withValues(alpha: 0.35),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
