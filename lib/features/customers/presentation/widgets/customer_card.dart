import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_strings.dart';
import '../../domain/entities/customer.dart';

class CustomerCard extends StatelessWidget {
  final Customer customer;
  final VoidCallback? onTap;

  const CustomerCard({
    super.key,
    required this.customer,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(AppSizes.radiusLarge),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withValues(alpha: 0.06),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Padding(
          padding: EdgeInsets.all(AppSizes.spacingMedium),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTopRow(),
              SizedBox(height: AppSizes.spacingSmall),
              _buildStatBoxes(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTopRow() {
    return Row(
      textDirection: TextDirection.rtl,
      children: [
        _buildAvatar(),
        SizedBox(width: AppSizes.spacingSmall),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                customer.name,
                style: TextStyle(
                  fontFamily: 'Cairo',
                  fontSize: AppSizes.fontXLarge,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textDark,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              if (customer.address != null && customer.address!.isNotEmpty)
                Padding(
                  padding: EdgeInsets.only(top: 2.h),
                  child: Text(
                    customer.address!,
                    style: TextStyle(
                      fontFamily: 'Cairo',
                      fontSize: AppSizes.fontSmall,
                      color: AppColors.textSecondary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStatBoxes() {
    final remaining = customer.totalDebt;
    final remainingColor =
        remaining > 0 ? AppColors.accent : AppColors.amountGrey;
    return Row(
      textDirection: TextDirection.rtl,
      children: [
        Expanded(
          child: _StatBox(
            label: AppStrings.customerTotalPurchases,
            amount: customer.totalPurchases,
            amountColor: AppColors.textPrimary,
            bgColor: AppColors.chipBg,
          ),
        ),
        SizedBox(width: AppSizes.spacingSmall),
        Expanded(
          child: _StatBox(
            label: AppStrings.customerPaidLabel,
            amount: customer.totalPaid,
            amountColor: AppColors.primary,
            bgColor: AppColors.lightPrimaryBg,
          ),
        ),
        SizedBox(width: AppSizes.spacingSmall),
        Expanded(
          child: _StatBox(
            label: AppStrings.customerRemainingLabel,
            amount: remaining,
            amountColor: remainingColor,
            bgColor: AppColors.lightOrange,
          ),
        ),
      ],
    );
  }

  Widget _buildAvatar() {
    if (customer.imageUrl != null && customer.imageUrl!.isNotEmpty) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
        child: CachedNetworkImage(
          imageUrl: customer.imageUrl!,
          width: 44.w,
          height: 44.w,
          fit: BoxFit.cover,
          placeholder: (_, __) => _buildPlaceholder(),
          errorWidget: (_, __, ___) => _buildPlaceholder(),
        ),
      );
    }
    return _buildPlaceholder();
  }

  Widget _buildPlaceholder() {
    return Container(
      width: 44.w,
      height: 44.w,
      decoration: BoxDecoration(
        color: AppColors.lightPrimaryBg,
        borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
      ),
      child: Icon(
        Icons.store_outlined,
        size: 20.w,
        color: AppColors.primary,
      ),
    );
  }
}

class _StatBox extends StatelessWidget {
  final String label;
  final double amount;
  final Color amountColor;
  final Color bgColor;

  const _StatBox({
    required this.label,
    required this.amount,
    required this.amountColor,
    required this.bgColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(AppSizes.spacingSmall),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontFamily: 'Cairo',
              fontSize: AppSizes.fontSmall,
              color: AppColors.labelSecondary,
            ),
          ),
          SizedBox(height: 2.h),
          Row(
            children: [
              Text(
                amount == 0 && amount.truncateToDouble() == 0
                    ? '0'
                    : amount.toInt().toString(),
                style: TextStyle(
                  fontFamily: 'Cairo',
                  fontSize: AppSizes.fontXLarge,
                  fontWeight: FontWeight.w600,
                  color: amountColor,
                ),
              ),
              SizedBox(width: 2.w),
              Text(
                AppStrings.currencyEg,
                style: TextStyle(
                  fontFamily: 'Cairo',
                  fontSize: AppSizes.fontSmall,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
