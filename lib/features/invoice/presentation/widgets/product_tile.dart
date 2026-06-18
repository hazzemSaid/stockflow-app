import 'package:flutter/material.dart';
import 'package:stockflow/core/constants/app_colors.dart';
import 'package:stockflow/core/constants/app_sizes.dart';
import 'package:stockflow/core/constants/app_strings.dart';
import 'package:stockflow/features/products/domain/entities/product.dart';

class ProductTile extends StatelessWidget {
  final Product product;
  final bool isSelected;
  final VoidCallback onToggle;

  const ProductTile({
    super.key,
    required this.product,
    required this.isSelected,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(AppSizes.spacingSmall),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
      ),
      child: Row(
        children: [
          Container(
            width: AppSizes.iconLarge,
            height: AppSizes.iconLarge,
            decoration: BoxDecoration(
              color: AppColors.lightGreen,
              borderRadius: BorderRadius.circular(AppSizes.radiusSmall),
            ),
            child: Icon(
              Icons.inventory_2_outlined,
              color: AppColors.primary,
              size: AppSizes.iconMedium,
            ),
          ),
          SizedBox(width: AppSizes.spacingSmall),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.name,
                  style: TextStyle(
                    fontSize: AppSizes.fontLarge,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textDark,
                  ),
                ),
                Row(
                  children: [
                    Text(
                      '${product.price.toInt()} ${AppStrings.currencyEg}',
                      style: TextStyle(
                        color: AppColors.accent,
                        fontSize: AppSizes.fontMedium,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(width: AppSizes.spacingSmall),
                    Text(
                      '${AppStrings.stockLabel}${product.quantity}',
                      style: TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: AppSizes.fontSmall,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: onToggle,
            child: Container(
              width: AppSizes.iconLarge,
              height: AppSizes.iconLarge,
              decoration: BoxDecoration(
                color: isSelected ? AppColors.primary : AppColors.lightGreen,
                borderRadius: BorderRadius.circular(AppSizes.radiusSmall),
              ),
              child: Icon(
                isSelected ? Icons.check : Icons.add,
                size: AppSizes.iconSmall,
                color: isSelected ? AppColors.surface : AppColors.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
