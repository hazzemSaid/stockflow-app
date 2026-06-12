import 'package:flutter/material.dart';
import 'package:stockflow/core/constants/app_colors.dart';
import 'package:stockflow/core/constants/app_sizes.dart';
import 'package:stockflow/core/constants/app_strings.dart';

class EmptyProductsPlaceholder extends StatelessWidget {
  final VoidCallback onTap;

  const EmptyProductsPlaceholder({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(AppSizes.spacingXLarge),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppSizes.radiusLarge),
          border: Border.all(color: AppColors.inputBorder),
        ),
        child: Column(
          children: [
            Icon(
              Icons.add_shopping_cart_outlined,
              size: AppSizes.iconXLarge,
              color: AppColors.textSecondary,
            ),
            SizedBox(height: AppSizes.spacingSmall),
            Text(
              AppStrings.selectProducts,
              style: TextStyle(
                color: AppColors.textSecondary,
                fontSize: AppSizes.fontLarge,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
