import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stockflow/core/constants/app_colors.dart';
import 'package:stockflow/core/constants/app_sizes.dart';
import 'package:stockflow/core/constants/app_strings.dart';
import 'package:stockflow/features/invoice/presentation/cubit/create_invoice/create_invoice_cubit.dart';

class InvoiceSummaryCard extends StatelessWidget {
  const InvoiceSummaryCard({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CreateInvoiceCubit, CreateInvoiceState>(
      buildWhen: (prev, next) => next is CreateInvoiceFormState,
      builder: (context, state) {
        if (state is! CreateInvoiceFormState) return const SizedBox.shrink();
        final loaded = state;

        final showDiscount = loaded.discountValue > 0;
        final showPaidNow =
            loaded.paymentMethod == 'partial' && loaded.paidNow > 0;
        final showRemaining = loaded.remainingDebt > 0;

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
                value: loaded.subtotal,
                valueColor: AppColors.textDark,
              ),
              if (showDiscount) ...[
                SizedBox(height: AppSizes.spacingSmall),
                _SummaryRow(
                  label: AppStrings.discountLabel,
                  value: -loaded.discountAmount,
                  valueColor: AppColors.redDark,
                ),
              ],
              if (showDiscount) ...[
                SizedBox(height: AppSizes.spacingSmall),
                _SummaryRow(
                  label: AppStrings.afterDiscount,
                  value: loaded.totalAfterDiscount,
                  valueColor: AppColors.textDark,
                  bold: true,
                ),
              ],
              Divider(
                height: AppSizes.spacingMedium,
                color: AppColors.inputBorder,
              ),
              if (showPaidNow) ...[
                _SummaryRow(
                  label: AppStrings.paidNowLabel,
                  value: -loaded.paidNow,
                  valueColor: AppColors.trendUp,
                ),
                Divider(
                  height: AppSizes.spacingMedium,
                  color: AppColors.inputBorder,
                ),
              ],
              _SummaryRow(
                label: AppStrings.totalLabel,
                value: loaded.totalAfterDiscount,
                valueColor: AppColors.accent,
                bold: true,
                large: true,
              ),
              if (showRemaining) ...[
                SizedBox(height: AppSizes.spacingSmall),
                _SummaryRow(
                  label: AppStrings.remainingDebt,
                  value: loaded.remainingDebt,
                  valueColor: AppColors.redDark,
                ),
              ],
            ],
          ),
        );
      },
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
          '${value >= 0 ? '' : '-'}${value.abs().toInt()} ${AppStrings.currencyEg}',
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
