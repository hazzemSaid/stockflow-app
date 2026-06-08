import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_strings.dart';

enum TransactionType { payment, invoice }

class _TransactionItemData {
  final TransactionType type;
  final IconData icon;
  final Color iconBg;
  final Color iconColor;
  final String title;
  final String subtitle;
  final String amount;
  final Color amountColor;
  final String? statusLabel;
  final Color? statusTextColor;
  final Color? statusBgColor;

  const _TransactionItemData({
    required this.type,
    required this.icon,
    required this.iconBg,
    required this.iconColor,
    required this.title,
    required this.subtitle,
    required this.amount,
    required this.amountColor,
    this.statusLabel,
    this.statusTextColor,
    this.statusBgColor,
  });
}

String _arNum(num n) {
  final fmt = NumberFormat.decimalPattern('ar');
  return fmt.format(n);
}

class CustomerTransactionList extends StatelessWidget {
  final int selectedTab;

  const CustomerTransactionList({super.key, this.selectedTab = 0});

  List<_TransactionItemData> get _allTransactions => [
    _TransactionItemData(
      type: TransactionType.payment,
      icon: Icons.receipt_long,
      iconBg: AppColors.lightOrange,
      iconColor: AppColors.accent,
      title: AppStrings.customerCashPayment,
      subtitle: '${AppStrings.customerCash} • ${AppStrings.customerYesterday}',
      amount: _arNum(800),
      amountColor: AppColors.primary,
      statusLabel: AppStrings.customerReceived,
      statusTextColor: AppColors.primary,
      statusBgColor: AppColors.lightPrimaryBg,
    ),
    _TransactionItemData(
      type: TransactionType.invoice,
      icon: Icons.receipt,
      iconBg: AppColors.lightPrimaryBg,
      iconColor: AppColors.primary,
      title: '${AppStrings.customerInvoicePrefix}${_arNum(1018)}',
      subtitle: '${_arNum(5)} ${AppStrings.customerProductsUnit} • ${AppStrings.customerDaysAgo} ${_arNum(3)} ${AppStrings.customerDays}',
      amount: _arNum(940),
      amountColor: AppColors.secondary,
      statusLabel: AppStrings.customerInvoiceLabel,
      statusTextColor: AppColors.primary,
      statusBgColor: AppColors.lightPrimaryBg,
    ),
    _TransactionItemData(
      type: TransactionType.payment,
      icon: Icons.receipt_long,
      iconBg: AppColors.lightOrange,
      iconColor: AppColors.accent,
      title: AppStrings.customerBankTransfer,
      subtitle: '${AppStrings.customerMeeza} • ${AppStrings.customerDaysAgo} ${AppStrings.customerWeek}',
      amount: _arNum(500),
      amountColor: AppColors.primary,
      statusLabel: AppStrings.customerReceived,
      statusTextColor: AppColors.primary,
      statusBgColor: AppColors.lightPrimaryBg,
    ),
    _TransactionItemData(
      type: TransactionType.invoice,
      icon: Icons.receipt,
      iconBg: AppColors.lightPrimaryBg,
      iconColor: AppColors.primary,
      title: '${AppStrings.customerInvoicePrefix}${_arNum(1002)}',
      subtitle: '${_arNum(12)} ${AppStrings.customerProductsUnit} • ${AppStrings.customerDaysAgo} ${AppStrings.customerWeeks}',
      amount: _arNum(2310),
      amountColor: AppColors.secondary,
      statusLabel: AppStrings.customerDeferred,
      statusTextColor: AppColors.redDark,
      statusBgColor: AppColors.lightRed,
    ),
  ];

  List<_TransactionItemData> get _filteredTransactions {
    if (selectedTab == 0) return _allTransactions;
    if (selectedTab == 1) {
      return _allTransactions
          .where((t) => t.type == TransactionType.invoice)
          .toList();
    }
    return _allTransactions
        .where((t) => t.type == TransactionType.payment)
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final items = _filteredTransactions;
    if (items.isEmpty) {
      return Padding(
        padding: EdgeInsets.symmetric(vertical: AppSizes.spacingLarge),
        child: Center(
          child: Text(
            AppStrings.emptyCustomers,
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
            onTap: () {},
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

  Widget _transactionItem(_TransactionItemData data) {
    final isLast = _filteredTransactions.last == data;
    return Container(
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
              color: data.iconBg,
              borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
            ),
            child: Icon(data.icon, size: 16.w, color: data.iconColor),
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
                    if (data.statusLabel != null) ...[
                      SizedBox(width: AppSizes.spacingSmall),
                      _statusChip(
                        data.statusLabel!,
                        data.statusTextColor ?? AppColors.primary,
                        data.statusBgColor ?? AppColors.lightPrimaryBg,
                      ),
                    ],
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
                data.amount,
                style: TextStyle(
                  fontFamily: 'Cairo',
                  fontSize: 13.sp,
                  color: data.amountColor,
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
    );
  }

  Widget _statusChip(String label, Color textColor, Color bgColor) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: AppSizes.spacingSmall, vertical: 2.h),
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
