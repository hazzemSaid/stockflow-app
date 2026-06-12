import 'package:flutter/material.dart';
import 'package:stockflow/core/constants/app_colors.dart';
import 'package:stockflow/core/constants/app_sizes.dart';
import 'package:stockflow/core/constants/app_strings.dart';
import 'package:stockflow/features/invoice/domain/entities/invoice.dart';

class InvoiceDetailsInfoSection extends StatelessWidget {
  final Invoice invoice;
  final String dateStr;

  const InvoiceDetailsInfoSection({
    super.key,
    required this.invoice,
    required this.dateStr,
  });

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
          _InfoRow(
            label: AppStrings.invoiceNumber,
            value: '${AppStrings.barcodeRef}-${invoice.id.substring(0, 8)}',
          ),
          SizedBox(height: AppSizes.spacingSmall),
          _InfoRow(label: AppStrings.date, value: dateStr),
          SizedBox(height: AppSizes.spacingSmall),
          if (invoice.createdByName != null)
            _InfoRow(label: AppStrings.employee, value: invoice.createdByName!),
          SizedBox(height: AppSizes.spacingSmall),
          if (invoice.customerName != null)
            _InfoRow(
              label: AppStrings.customerSection,
              value: invoice.customerName!,
            ),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;

  const _InfoRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            color: AppColors.textSecondary,
            fontSize: AppSizes.fontLarge,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            color: AppColors.textDark,
            fontSize: AppSizes.fontLarge,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
