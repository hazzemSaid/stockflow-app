import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_strings.dart';

class CustomerDebtSummaryCard extends StatelessWidget {
  final double totalDebt;
  final double totalPurchases;
  final double totalPaid;

  const CustomerDebtSummaryCard({
    super.key,
    required this.totalDebt,
    this.totalPurchases = 0,
    this.totalPaid = 0,
  });

  @override
  Widget build(BuildContext context) {
    final ratio =
        totalPurchases > 0 ? (totalPaid / totalPurchases * 100) : 0.0;

    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: 16.w),
      padding: EdgeInsets.all(AppSizes.spacingMedium),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppSizes.radiusLarge),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.14),
            blurRadius: 30.r,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                AppStrings.customerOutstandingBalance,
                style: TextStyle(
                  fontFamily: 'Cairo',
                  fontSize: AppSizes.fontSmall,
                  color: AppColors.textSecondary,
                ),
              ),
              _debtBadge(),
            ],
          ),
          SizedBox(height: 2.h),
          _amountRow(),
          SizedBox(height: 12.h),
          _ratioRow(ratio),
          SizedBox(height: 6.h),
          _progressBar(ratio),
          SizedBox(height: 12.h),
          _statBoxes(),
        ],
      ),
    );
  }

  Widget _debtBadge() {
    return Container(
      width: 56.w,
      height: 56.w,
      decoration: BoxDecoration(
        color: AppColors.lightOrange,
        borderRadius: BorderRadius.circular(AppSizes.radiusLarge),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.warning_amber_rounded, size: 18.w, color: AppColors.accent),
          SizedBox(height: 2.h),
          Text(
            AppStrings.customerDebtLabel,
            style: TextStyle(
              fontFamily: 'Cairo',
              fontSize: 9.sp,
              color: AppColors.accent,
            ),
          ),
        ],
      ),
    );
  }

  Widget _amountRow() {
    final formatted = _formatCurrency(totalDebt);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          AppStrings.currencyEg,
          style: TextStyle(
            fontFamily: 'Cairo',
            fontSize: AppSizes.fontSmall,
            color: AppColors.textSecondary,
          ),
        ),
        SizedBox(width: 4.w),
        Text(
          formatted,
          style: TextStyle(
            fontFamily: 'Cairo',
            fontSize: 24.sp,
            color: AppColors.accent,
          ),
        ),
      ],
    );
  }

  Widget _ratioRow(double ratio) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          AppStrings.customerPaymentRatio,
          style: TextStyle(
            fontFamily: 'Cairo',
            fontSize: AppSizes.fontSmall,
            color: AppColors.textSecondary,
          ),
        ),
        Text(
          '${ratio.toStringAsFixed(0)}${AppStrings.customerPaidPercent}',
          style: TextStyle(
            fontFamily: 'Cairo',
            fontSize: AppSizes.fontSmall,
            color: AppColors.primary,
          ),
        ),
      ],
    );
  }

  Widget _progressBar(double ratio) {
    return Container(
      width: double.infinity,
      height: 10.h,
      decoration: BoxDecoration(
        color: AppColors.searchBg,
        borderRadius: BorderRadius.circular(AppSizes.radiusXLarge),
      ),
      child: FractionallySizedBox(
        alignment: Alignment.centerRight,
        widthFactor: ratio.clamp(0, 100) / 100,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppSizes.radiusXLarge),
            gradient: const LinearGradient(
              colors: [AppColors.primary, AppColors.trendUp],
            ),
          ),
        ),
      ),
    );
  }

  Widget _statBoxes() {
    final purchasesFormatted = _formatCurrency(totalPurchases);
    final paidFormatted = _formatCurrency(totalPaid);
    final remainingFormatted = _formatCurrency(totalDebt);

    return Row(
      children: [
        _statBox(
          AppStrings.customerTotalPurchases,
          purchasesFormatted,
          AppColors.chipBg,
          AppColors.textPrimary,
        ),
        SizedBox(width: AppSizes.spacingSmall),
        _statBox(
          AppStrings.customerPaidLabel,
          paidFormatted,
          AppColors.lightPrimaryBg,
          AppColors.primary,
        ),
        SizedBox(width: AppSizes.spacingSmall),
        _statBox(
          AppStrings.customerRemainingLabel,
          remainingFormatted,
          AppColors.lightOrange,
          AppColors.accent,
        ),
      ],
    );
  }

  Widget _statBox(String label, String amount, Color bg, Color amountColor) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.all(10.w),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              label,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Cairo',
                fontSize: 9.sp,
                color: AppColors.textSecondary,
              ),
            ),
            SizedBox(height: 4.h),
            Text(
              amount,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Cairo',
                fontSize: AppSizes.fontLarge,
                color: amountColor,
              ),
            ),
            Text(
              AppStrings.currencyEg,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Cairo',
                fontSize: AppSizes.fontSmall,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatCurrency(double value) {
    final fmt = NumberFormat.decimalPattern('ar');
    return fmt.format(value.round());
  }
}
