import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:makhzanflow/core/constants/app_colors.dart';
import 'package:makhzanflow/core/constants/app_sizes.dart';
import 'package:makhzanflow/core/constants/app_strings.dart';
import 'package:makhzanflow/features/invoice/domain/entities/invoice.dart';

class InvoiceDetailsPaymentHistory extends StatelessWidget {
  final Invoice invoice;

  const InvoiceDetailsPaymentHistory({super.key, required this.invoice});

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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppStrings.paymentHistory,
            style: TextStyle(
              fontSize: AppSizes.fontLarge,
              fontWeight: FontWeight.w600,
              color: AppColors.textDark,
            ),
          ),
          SizedBox(height: AppSizes.spacingSmall),
          ...invoice.payments.map(
            (payment) => Padding(
              padding: EdgeInsets.symmetric(vertical: AppSizes.spacingTiny),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    DateFormat(
                      'yyyy/MM/dd – hh:mm a',
                    ).format(payment.createdAt.toLocal()),
                    style: TextStyle(
                      fontSize: AppSizes.fontMedium,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  Text(
                    '${payment.amount.toInt()} ${AppStrings.currencyEg}',
                    style: TextStyle(
                      fontSize: AppSizes.fontMedium,
                      fontWeight: FontWeight.w600,
                      color: AppColors.trendUp,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
