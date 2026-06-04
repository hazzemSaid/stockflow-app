import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_strings.dart';

class ProductScreenHeader extends StatelessWidget {
  final int totalCount;

  const ProductScreenHeader({super.key, required this.totalCount});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: AppSizes.spacingMedium),
      child: Row(
        mainAxisAlignment: .spaceEvenly,
        children: [
          Expanded(
            child: Text(
              AppStrings.productsTitle,
              style: TextStyle(
                fontFamily: 'Cairo',
                fontSize: AppSizes.fontXXLarge,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
          ),
          Flexible(
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: AppSizes.spacingSmall,
                vertical: AppSizes.spacingTiny,
              ),
              decoration: BoxDecoration(
                color: AppColors.lightGreen,
                borderRadius: BorderRadius.circular(AppSizes.radiusSmall),
              ),
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  '$totalCount ${AppStrings.productCount}',
                  style: TextStyle(
                    fontFamily: 'Cairo',
                    fontSize: AppSizes.fontSmall,
                    color: AppColors.primary,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
