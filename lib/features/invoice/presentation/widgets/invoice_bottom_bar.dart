import 'package:flutter/material.dart';
import 'package:stockflow/core/constants/app_colors.dart';
import 'package:stockflow/core/constants/app_sizes.dart';
import 'package:stockflow/core/constants/app_strings.dart';
import 'package:stockflow/features/invoice/presentation/cubit/create_invoice/create_invoice_cubit.dart';

class InvoiceBottomBar extends StatelessWidget {
  final CreateInvoiceCubit cubit;
  final VoidCallback onConfirm;

  const InvoiceBottomBar({
    super.key,
    required this.cubit,
    required this.onConfirm,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(
        AppSizes.spacingMedium,
        AppSizes.spacingSmall,
        AppSizes.spacingMedium,
        AppSizes.spacingMedium,
      ),
      decoration: BoxDecoration(
        color: AppColors.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppStrings.totalLabel,
                    style: TextStyle(
                      fontSize: AppSizes.fontSmall,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  Text(
                    '${cubit.totalAfterDiscount.toInt()} ${AppStrings.currencyEg}',
                    style: TextStyle(
                      fontSize: AppSizes.fontXXLarge,
                      fontWeight: FontWeight.w700,
                      color: AppColors.primary,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(width: AppSizes.spacingMedium),
            SizedBox(
              height: AppSizes.buttonHeight,
              child: ElevatedButton(
                onPressed: onConfirm,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: AppColors.surface,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppSizes.radiusSmall),
                  ),
                  padding: EdgeInsets.symmetric(
                    horizontal: AppSizes.spacingLarge,
                  ),
                ),
                child: Text(
                  AppStrings.confirmAndIssue,
                  style: TextStyle(
                    fontSize: AppSizes.fontLarge,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
