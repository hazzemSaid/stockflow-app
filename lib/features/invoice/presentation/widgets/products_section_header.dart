import 'package:flutter/material.dart';
import 'package:stockflow/core/constants/app_colors.dart';
import 'package:stockflow/core/constants/app_sizes.dart';
import 'package:stockflow/core/constants/app_strings.dart';
import 'package:stockflow/features/invoice/presentation/cubit/create_invoice/create_invoice_cubit.dart';

class ProductsSectionHeader extends StatelessWidget {
  final CreateInvoiceCubit cubit;
  final VoidCallback onAddProduct;

  const ProductsSectionHeader({
    super.key,
    required this.cubit,
    required this.onAddProduct,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          '${AppStrings.productsCount} (${cubit.products.length})',
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
