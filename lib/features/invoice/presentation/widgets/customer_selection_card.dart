import 'package:flutter/material.dart';
import 'package:stockflow/core/constants/app_colors.dart';
import 'package:stockflow/core/constants/app_sizes.dart';
import 'package:stockflow/core/constants/app_strings.dart';
import 'package:stockflow/features/customers/domain/entities/customer.dart';

class CustomerSelectionCard extends StatelessWidget {
  final Customer? customer;
  final VoidCallback? onTap;

  const CustomerSelectionCard({
    super.key,
    required this.customer,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isSelected = customer != null;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(AppSizes.spacingMedium),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppSizes.radiusLarge),
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
                Icons.person_outline,
                color: AppColors.primary,
                size: AppSizes.iconMedium,
              ),
            ),
            SizedBox(width: AppSizes.spacingMedium),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    isSelected ? customer!.name : AppStrings.selectCustomer,
                    style: TextStyle(
                      fontSize: AppSizes.fontXLarge,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textDark,
                    ),
                  ),
                  if (isSelected && customer!.nameOfficial != null)
                    Text(
                      customer!.nameOfficial!,
                      style: TextStyle(
                        fontSize: AppSizes.fontMedium,
                        color: AppColors.textSecondary,
                      ),
                    ),
                ],
              ),
            ),
            Icon(
              isSelected ? Icons.check_circle : Icons.chevron_left,
              color: isSelected ? AppColors.primary : AppColors.textSecondary,
              size: AppSizes.iconMedium,
            ),
          ],
        ),
      ),
    );
  }
}
