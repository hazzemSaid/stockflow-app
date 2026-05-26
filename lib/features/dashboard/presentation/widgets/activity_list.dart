import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_strings.dart';
import '../models/activity_item.dart';

class ActivityList extends StatelessWidget {
  final List<ActivityItem> items;

  const ActivityList({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) {
      return Text(
        AppStrings.emptyActivity,
        style: TextStyle(
          fontFamily: 'Cairo',
          fontSize: AppSizes.fontMedium,
          color: AppColors.textSecondary,
        ),
      );
    }

    return Column(
      children: items.map((item) => _ActivityCard(item: item)).toList(),
    );
  }
}

class _ActivityCard extends StatelessWidget {
  final ActivityItem item;

  const _ActivityCard({required this.item});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: AppSizes.spacingSmall),
      padding: EdgeInsets.all(AppSizes.spacingSmall),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(AppSizes.radiusLarge),
      ),
      child: Row(
        children: [
          Container(
            width: 36.w,
            height: 36.w,
            decoration: BoxDecoration(
              color: item.iconBackground,
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Icon(item.icon, color: item.iconColor, size: 18.w),
          ),
          SizedBox(width: AppSizes.spacingSmall),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.title,
                  style: TextStyle(
                    fontFamily: 'Cairo',
                    fontSize: AppSizes.fontMedium,
                    color: AppColors.textPrimary,
                  ),
                ),
                Text(
                  item.subtitle,
                  style: TextStyle(
                    fontFamily: 'Cairo',
                    fontSize: AppSizes.fontSmall,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          if (item.amount != null)
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: item.amount,
                    style: TextStyle(
                      fontFamily: 'Cairo',
                      fontSize: AppSizes.fontMedium,
                      color: item.amountColor,
                    ),
                  ),
                  const TextSpan(text: ' '),
                  TextSpan(
                    text: AppStrings.currencyEg,
                    style: TextStyle(
                      fontFamily: 'Cairo',
                      fontSize: AppSizes.fontSmall,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
