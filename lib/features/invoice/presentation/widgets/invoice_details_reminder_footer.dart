import 'package:flutter/material.dart';
import 'package:stockflow/core/constants/app_colors.dart';
import 'package:stockflow/core/constants/app_sizes.dart';
import 'package:stockflow/core/constants/app_strings.dart';

class InvoiceDetailsReminderFooter extends StatelessWidget {
  const InvoiceDetailsReminderFooter({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(AppSizes.spacingMedium),
      decoration: BoxDecoration(
        color: AppColors.lightOrange,
        borderRadius: BorderRadius.circular(AppSizes.radiusLarge),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.info_outline,
            color: AppColors.accent,
            size: AppSizes.iconSmall,
          ),
          SizedBox(width: AppSizes.spacingSmall),
          Text(
            AppStrings.paymentReminder,
            style: TextStyle(
              color: AppColors.accent,
              fontSize: AppSizes.fontMedium,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
