import 'package:flutter/material.dart';
import 'package:makhzanflow/core/constants/app_colors.dart';
import 'package:makhzanflow/core/constants/app_sizes.dart';

class InvoiceFilterChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const InvoiceFilterChip({
    super.key,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: AppSizes.spacingMedium,
          vertical: AppSizes.spacingTiny + 4,
        ),
        decoration: BoxDecoration(
          color: selected ? AppColors.primary : AppColors.inputBackground,
          borderRadius: BorderRadius.circular(AppSizes.radiusXLarge),
          border: Border.all(
            color: selected ? AppColors.primary : AppColors.inputBorder,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: selected ? AppColors.surface : AppColors.textSecondary,
            fontWeight: selected ? FontWeight.w600 : FontWeight.normal,
            fontSize: AppSizes.fontMedium,
          ),
        ),
      ),
    );
  }
}
