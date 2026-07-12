import 'package:flutter/material.dart';
import 'package:makhzanflow/core/constants/app_colors.dart';
import 'package:makhzanflow/core/constants/app_sizes.dart';
import 'package:makhzanflow/core/constants/app_strings.dart';

class ProductsSectionHeader extends StatelessWidget {
  final int productCount;
  final VoidCallback onAddProduct;

  const ProductsSectionHeader({
    super.key,
    required this.productCount,
    required this.onAddProduct,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          '${AppStrings.productsCount} ($productCount)',
          style: TextStyle(
            fontSize: AppSizes.fontXLarge,
            fontWeight: FontWeight.w600,
            color: AppColors.textDark,
          ),
        ),
        TextButton.icon(
          onPressed: onAddProduct,
          icon: Icon(
            Icons.add_circle_outline,
            color: AppColors.primary,
            size: AppSizes.iconSmall,
          ),
          label: Text(
            AppStrings.addProduct,
            style: TextStyle(
              color: AppColors.primary,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }
}
