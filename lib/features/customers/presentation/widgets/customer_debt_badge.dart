import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_strings.dart';

class CustomerDebtBadge extends StatelessWidget {
  final double debt;

  const CustomerDebtBadge({
    super.key,
    required this.debt,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(AppSizes.spacingMedium),
      decoration: BoxDecoration(
        color: debt > 0 ? AppColors.debtRedBg : AppColors.debtGreenBg,
        borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
      ),
      child: Row(
        children: [
          Icon(
            debt > 0 ? Icons.warning_amber_rounded : Icons.check_circle,
            color: debt > 0 ? AppColors.error : AppColors.primary,
          ),
          SizedBox(width: AppSizes.spacingSmall),
          Expanded(
            child: Text(
              '${AppStrings.customerDebtTotal}: ${debt.toStringAsFixed(2)} ${AppStrings.currencyEg}',
              style: TextStyle(
                fontFamily: 'Cairo',
                fontSize: AppSizes.fontXLarge,
                fontWeight: FontWeight.bold,
                color: debt > 0 ? AppColors.error : AppColors.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
