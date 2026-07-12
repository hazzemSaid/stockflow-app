import 'package:flutter/material.dart';
import 'package:makhzanflow/core/constants/app_colors.dart';
import 'package:makhzanflow/core/constants/app_sizes.dart';
import 'package:makhzanflow/features/invoice/presentation/cubit/create_invoice/create_invoice_cubit.dart';

class ProductItemRow extends StatelessWidget {
  final CreateInvoiceCubit cubit;
  final String productId;
  final String productName;
  final double unitPrice;
  final int quantity;

  const ProductItemRow({
    super.key,
    required this.cubit,
    required this.productId,
    required this.productName,
    required this.unitPrice,
    required this.quantity,
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
                  productName,
                  style: TextStyle(
                    fontSize: AppSizes.fontLarge,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textDark,
                  ),
                ),
                Text(
                  '${unitPrice.toInt()} ج.م',
                  style: TextStyle(
                    fontSize: AppSizes.fontMedium,
                    color: AppColors.accent,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              GestureDetector(
                onTap: () => cubit.updateProductQuantity(productId, quantity - 1),
                child: Container(
                  width: AppSizes.iconMedium,
                  height: AppSizes.iconMedium,
                  decoration: BoxDecoration(
                    color: AppColors.lightGreen,
                    borderRadius: BorderRadius.circular(AppSizes.radiusSmall),
                  ),
                  child: Icon(
                    Icons.remove,
                    size: AppSizes.iconSmall,
                    color: AppColors.primary,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: AppSizes.spacingSmall),
                child: Text(
                  '$quantity',
                  style: TextStyle(
                    fontSize: AppSizes.fontLarge,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textDark,
                  ),
                ),
              ),
              GestureDetector(
                onTap: () => cubit.updateProductQuantity(productId, quantity + 1),
                child: Container(
                  width: AppSizes.iconMedium,
                  height: AppSizes.iconMedium,
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(AppSizes.radiusSmall),
                  ),
                  child: Icon(
                    Icons.add,
                    size: AppSizes.iconSmall,
                    color: AppColors.surface,
                  ),
                ),
              ),
              SizedBox(width: AppSizes.spacingSmall),
              GestureDetector(
                onTap: () => cubit.removeProduct(productId),
                child: Container(
                  width: AppSizes.iconMedium,
                  height: AppSizes.iconMedium,
                  decoration: BoxDecoration(
                    color: AppColors.lightRed,
                    borderRadius: BorderRadius.circular(AppSizes.radiusSmall),
                  ),
                  child: Icon(
                    Icons.close,
                    size: AppSizes.iconSmall,
                    color: AppColors.redDark,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
