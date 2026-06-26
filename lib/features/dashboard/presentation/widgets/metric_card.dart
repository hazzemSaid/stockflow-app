import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';

/// Metric value display model — now uses real [double] values.
class MetricCardData {
  const MetricCardData({
    required this.title,
    required this.value,
    this.currency,
    required this.icon,
    required this.iconBackground,
    required this.iconColor,
    required this.valueColor,
    this.isCount = false,
  });

  final String title;

  /// Numeric value (count or monetary amount).
  final double value;

  /// Optional currency suffix (e.g. 'ج.م').
  final String? currency;
  final IconData icon;
  final Color iconBackground;
  final Color iconColor;
  final Color valueColor;

  /// If true, formats as integer (for counts like products/customers).
  final bool isCount;
}

class MetricCard extends StatelessWidget {
  const MetricCard({super.key, required this.data});

  final MetricCardData data;

  @override
  Widget build(BuildContext context) {
    final formatted = data.isCount
        ? NumberFormat('#,##0', 'ar').format(data.value.toInt())
        : NumberFormat('#,##0', 'ar').format(data.value);

    return Container(
      padding: EdgeInsets.all(AppSizes.spacingSmall),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(AppSizes.radiusLarge),
        boxShadow: [
          BoxShadow(
            color: AppColors.textPrimary.withValues(alpha: 0.04),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 36.w,
            height: 36.w,
            decoration: BoxDecoration(
              color: data.iconBackground,
              borderRadius: BorderRadius.circular(10.r),
            ),
            child: Icon(data.icon, size: 18.w, color: data.iconColor),
          ),
          SizedBox(height: AppSizes.spacingSmall),
          Text(
            data.title,
            style: TextStyle(
              fontFamily: 'Cairo',
              fontSize: AppSizes.fontSmall,
              color: AppColors.textSecondary,
            ),
          ),
          SizedBox(height: AppSizes.spacingTiny),
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: formatted,
                  style: TextStyle(
                    fontFamily: 'Cairo',
                    fontSize: AppSizes.fontXLarge,
                    color: data.valueColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (data.currency != null) ...[
                  const TextSpan(text: ' '),
                  TextSpan(
                    text: data.currency,
                    style: TextStyle(
                      fontFamily: 'Cairo',
                      fontSize: AppSizes.fontSmall,
                      color: AppColors.textSecondary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
