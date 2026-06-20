import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:stockflow/features/customers/domain/entities/customer_transaction.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_strings.dart';

String _arNum(num n) {
  final fmt = NumberFormat.decimalPattern('ar');
  return fmt.format(n);
}

class CustomerTransactionList extends StatelessWidget {
  final int selectedTab;
  final List<CustomerTransaction> transactions;
  final VoidCallback? onViewAll;
  final ValueChanged<String>? onInvoiceTap;

  const CustomerTransactionList({
    super.key,
    this.selectedTab = 0,
    this.transactions = const [],
    this.onViewAll,
    this.onInvoiceTap,
  });

  List<CustomerTransaction> get _filteredTransactions {
    if (selectedTab == 0) return transactions;
    if (selectedTab == 1) {
      return transactions.where((t) => t.type == 'invoice').toList();
    }
    return transactions.where((t) => t.type == 'payment').toList();
  }

  @override
  Widget build(BuildContext context) {
    final items = _filteredTransactions;
    if (items.isEmpty) {
      return Padding(
        padding: EdgeInsets.symmetric(vertical: AppSizes.spacingLarge),
        child: Center(
          child: Text(
            AppStrings.emptyInvoices,
            style: TextStyle(
              fontFamily: 'Cairo',
              fontSize: AppSizes.fontMedium,
              color: AppColors.textSecondary,
            ),
          ),
        ),
      );
    }

    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: 16.w),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppSizes.radiusLarge),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.06),
            blurRadius: 10.r,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(children: [_header(), ...items.map(_transactionItem)]),
    );
  }

  Widget _header() {
    return Container(
      padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 8.h),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: AppColors.searchBg, width: 0.8),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: onViewAll,
            child: Text(
              AppStrings.customerViewAll,
              style: TextStyle(
                fontFamily: 'Cairo',
                fontSize: AppSizes.fontSmall,
                color: AppColors.accent,
              ),
            ),
          ),
          Text(
            AppStrings.customerTransactionLog,
            style: TextStyle(
              fontFamily: 'Cairo',
              fontSize: AppSizes.fontMedium,
              color: AppColors.secondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _transactionItem(CustomerTransaction data) {
    final isInvoice = data.type == 'invoice';
    final isPayment = data.type == 'payment';
    final isLast = _filteredTransactions.last == data;

    final icon = isPayment ? Icons.receipt_long : Icons.receipt;
    final iconBg = isPayment ? AppColors.lightOrange : AppColors.lightPrimaryBg;
    final iconColor = isPayment ? AppColors.accent : AppColors.primary;
    final amountColor = isPayment ? AppColors.primary : AppColors.secondary;

    return GestureDetector(
      onTap: isInvoice ? () => onInvoiceTap?.call(data.id) : null,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        decoration: BoxDecoration(
          border: isLast
              ? null
              : Border(
                  bottom: BorderSide(color: AppColors.searchBg, width: 0.8),
                ),
        ),
        child: Row(
          children: [
            Container(
              width: 40.w,
              height: 40.w,
              decoration: BoxDecoration(
                color: iconBg,
                borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
              ),
              child: Icon(icon, size: 16.w, color: iconColor),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Flexible(
                        child: Text(
                          data.title,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontFamily: 'Cairo',
                            fontSize: AppSizes.fontMedium,
                            color: AppColors.textDark,
                          ),
                        ),
                      ),
                      SizedBox(width: AppSizes.spacingSmall),
                      _statusChip(data.statusLabel),
                    ],
                  ),
                  SizedBox(height: AppSizes.spacingTiny),
                  Text(
                    data.subtitle,
                    style: TextStyle(
                      fontFamily: 'Cairo',
                      fontSize: AppSizes.fontSmall,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(width: 12.w),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  _arNum(data.amount),
                  style: TextStyle(
                    fontFamily: 'Cairo',
                    fontSize: 13.sp,
                    color: amountColor,
                  ),
                ),
                Text(
                  AppStrings.currencyEg,
                  style: TextStyle(
                    fontFamily: 'Cairo',
                    fontSize: 9.sp,
                    color: AppColors.hintText,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _statusChip(String label) {
    final isRed = label == 'آجل' || label == 'معلق';
    final isGreen = label == 'مدفوع' || label == 'مستلم';
    final textColor = isRed
        ? AppColors.redDark
        : (isGreen ? AppColors.primary : AppColors.accent);
    final bgColor = isRed
        ? AppColors.lightRed
        : (isGreen ? AppColors.lightPrimaryBg : AppColors.lightOrange);

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppSizes.spacingSmall,
        vertical: 2.h,
      ),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(AppSizes.radiusXLarge),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontFamily: 'Cairo',
          fontSize: AppSizes.fontSmall,
          color: textColor,
        ),
      ),
    );
  }
}
