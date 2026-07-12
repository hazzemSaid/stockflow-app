import 'package:flutter/material.dart';
import 'package:makhzanflow/core/constants/app_colors.dart';
import 'package:makhzanflow/core/constants/app_sizes.dart';
import 'package:makhzanflow/core/constants/app_strings.dart';

class InvoiceDetailsCompanyHeader extends StatelessWidget {
  const InvoiceDetailsCompanyHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(AppSizes.spacingMedium),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSizes.radiusLarge),
      ),
      child: Column(
        children: [
          Container(
            width: AppSizes.iconLarge,
            height: AppSizes.iconLarge,
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(AppSizes.radiusSmall),
            ),
            child: Icon(
              Icons.store,
              color: AppColors.surface,
              size: AppSizes.iconMedium,
            ),
          ),
          SizedBox(height: AppSizes.spacingSmall),
          Text(
            AppStrings.mainWarehouse,
            style: TextStyle(
              fontSize: AppSizes.fontXLarge,
              fontWeight: FontWeight.w600,
              color: AppColors.textDark,
            ),
          ),
        ],
      ),
    );
  }
}
