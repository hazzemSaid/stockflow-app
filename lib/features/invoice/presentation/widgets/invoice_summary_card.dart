import 'package:flutter/material.dart';
import 'package:stockflow/core/constants/app_colors.dart';
import 'package:stockflow/core/constants/app_sizes.dart';
import 'package:stockflow/core/constants/app_strings.dart';
import 'package:stockflow/features/invoice/presentation/cubit/create_invoice/create_invoice_cubit.dart';

class InvoiceSummaryCard extends StatelessWidget {
  final CreateInvoiceCubit cubit;

  const InvoiceSummaryCard({super.key, required this.cubit});

  @override
  Widget build(BuildContext context) {
    final showDiscount = cubit.discountValue > 0;
    final showPaidNow = cubit.paymentMethod == 'partial' && cubit.paidNow > 0;
    final showRemaining = cubit.remainingDebt > 0;

    return Container(
      padding: EdgeInsets.all(AppSizes.spacingMedium),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSizes.radiusLarge),
      ),
      child: Column(
        children: [
          _SummaryRow(
            label: AppStrings.subtotal,
            value: cubit.subtotal,
            valueColor: AppColors.textDark,
          ),
          if (showDiscount) ...[
            SizedBox(height: AppSizes.spacingSmall),
            _SummaryRow(
              label: AppStrings.discountLabel,
              value: -cubit.discountAmount,
              valueColor: AppColors.redDark,
            ),
          ],
          if (showDiscount) ...[
            SizedBox(height: AppSizes.spacingSmall),
            _SummaryRow(
              label: AppStrings.afterDiscount,
              value: cubit.totalAfterDiscount,
              valueColor: AppColors.textDark,
              bold: true,
            ),
          ],
          Divider(height: AppSizes.spacingMedium, color: AppColors.inputBorder),
          if (showPaidNow) ...[
            _SummaryRow(
              label: AppStrings.paidNowLabel,
              value: -cubit.paidNow,
              valueColor: AppColors.trendUp,
            ),
            Divider(height: AppSizes.spacingMedium, color: AppColors.inputBorder),
          ],
          _SummaryRow(
            label: AppStrings.totalLabel,
            value: cubit.totalAfterDiscount,
            valueColor: AppColors.accent,
            bold: true,
            large: true,
          ),
          if (showRemaining) ...[
            SizedBox(height: AppSizes.spacingSmall),
            _SummaryRow(
              label: AppStrings.remainingDebt,
              value: cubit.remainingDebt,
              valueColor: AppColors.redDark,
            ),
          ],
        ],
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  final String label;
  final double value;
  final Color valueColor;
  final bool bold;
  final bool large;

  const _SummaryRow({
    required this.label,
    required this.value,
    required this.valueColor,
    this.bold = false,
    this.large = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: large ? AppSizes.fontXLarge : AppSizes.fontLarge,
            fontWeight: bold ? FontWeight.w600 : FontWeight.normal,
            color: AppColors.textSecondary,
          ),
        ),
        Text(
          '${value >= 0 ? '' : '-'}${value.abs().toStringAsFixed(0)} ${AppStrings.currencyEg}',
          style: TextStyle(
            fontSize: large ? AppSizes.fontXXLarge : AppSizes.fontLarge,
            fontWeight: bold ? FontWeight.w700 : FontWeight.w500,
            color: valueColor,
          ),
        ),
      ],
    );
  }
}
