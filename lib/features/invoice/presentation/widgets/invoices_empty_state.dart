import 'package:flutter/material.dart';
import 'package:makhzanflow/core/constants/app_colors.dart';
import 'package:makhzanflow/core/constants/app_sizes.dart';
import 'package:makhzanflow/core/constants/app_strings.dart';

class InvoicesEmptyState extends StatelessWidget {
  final bool hasFilter;

  const InvoicesEmptyState({super.key, required this.hasFilter});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.receipt_long_outlined,
            size: AppSizes.iconXLarge * 2,
            color: AppColors.textSecondary,
          ),
          SizedBox(height: AppSizes.spacingMedium),
          Text(
            hasFilter
                ? AppStrings.productEmptySearch
                : AppStrings.emptyInvoices,
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: AppSizes.fontXLarge,
            ),
          ),
        ],
      ),
    );
  }
}
