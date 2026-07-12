import 'package:flutter/material.dart';
import 'package:makhzanflow/core/constants/app_colors.dart';
import 'package:makhzanflow/core/constants/app_sizes.dart';
import 'package:makhzanflow/core/constants/app_strings.dart';
import 'package:makhzanflow/features/invoice/domain/entities/invoice.dart';

class InvoiceDetailsSummarySection extends StatelessWidget {
  final Invoice invoice;

  const InvoiceDetailsSummarySection({super.key, required this.invoice});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(AppSizes.spacingMedium),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSizes.radiusLarge),
      ),
      child: Column(
        children: [
          _SummaryRow(label: AppStrings.subtotal, value: invoice.subtotal),
          if (invoice.discountValue > 0) ...[
            SizedBox(height: AppSizes.spacingSmall),
            _SummaryRow(
              label: AppStrings.discountLabel,
              value: -invoice.discountAmount,
              valueColor: AppColors.redDark,
            ),
          ],
          Divider(height: AppSizes.spacingMedium, color: AppColors.inputBorder),
          _SummaryRow(
            label: AppStrings.totalLabel,
            value: invoice.totalAmount,
            valueColor: AppColors.accent,
            bold: true,
          ),
          if (invoice.remainingAmount > 0) ...[
            SizedBox(height: AppSizes.spacingSmall),
            _SummaryRow(
              label: AppStrings.remainingDebt,
              value: invoice.remainingAmount,
              valueColor: AppColors.redDark,
              bold: true,
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

  const _SummaryRow({
    required this.label,
    required this.value,
    this.valueColor = AppColors.textDark,
    this.bold = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: AppSizes.fontLarge,
            fontWeight: bold ? FontWeight.w600 : FontWeight.normal,
            color: AppColors.textSecondary,
          ),
        ),
        Text(
          '${value >= 0 ? '' : '-'}${value.abs().toInt()} ${AppStrings.currencyEg}',
          style: TextStyle(
            fontSize: AppSizes.fontLarge,
            fontWeight: bold ? FontWeight.w700 : FontWeight.w500,
            color: valueColor,
          ),
        ),
      ],
    );
  }
}
