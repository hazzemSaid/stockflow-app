import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_strings.dart';

class CustomerDebtDisplay extends StatelessWidget {
  final String debtText;

  const CustomerDebtDisplay({
    super.key,
    required this.debtText,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(AppSizes.spacingMedium),
      decoration: BoxDecoration(
        color: AppColors.debtAmberBg,
        borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.lock_outline,
            color: AppColors.accent,
          ),
          SizedBox(width: AppSizes.spacingSmall),
          Expanded(
            child: Text(
              '${AppStrings.customerDebtTotal}: $debtText ${AppStrings.currencyEg}'
              ' - ${AppStrings.customerDebtEditNote}',
              style: TextStyle(
                fontFamily: 'Cairo',
                fontSize: AppSizes.fontLarge,
                color: AppColors.textPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
