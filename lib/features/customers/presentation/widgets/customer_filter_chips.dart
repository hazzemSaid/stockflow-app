import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_strings.dart';

class FilterOption {
  final String key;
  final String label;
  final int count;

  const FilterOption({
    required this.key,
    required this.label,
    required this.count,
  });
}

class CustomerFilterChips extends StatelessWidget {
  final String selectedFilter;
  final ValueChanged<String> onFilterChanged;
  final int totalCount;
  final int paidCount;
  final int partialCount;
  final int deferredCount;

  const CustomerFilterChips({
    super.key,
    required this.selectedFilter,
    required this.onFilterChanged,
    required this.totalCount,
    required this.paidCount,
    required this.partialCount,
    required this.deferredCount,
  });

  List<FilterOption> get _options => [
    FilterOption(key: 'all', label: AppStrings.customerAllFilter, count: totalCount),
    FilterOption(key: 'paid', label: AppStrings.customerPaidFilter, count: paidCount),
    FilterOption(key: 'partial', label: AppStrings.customerPartialFilter, count: partialCount),
    FilterOption(key: 'deferred', label: AppStrings.customerDeferredFilter, count: deferredCount),
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: AppSizes.spacingMedium,
        vertical: AppSizes.spacingSmall,
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Directionality(
          textDirection: TextDirection.rtl,
          child: Row(
          children: _options.map((opt) {
            final isSelected = opt.key == selectedFilter;
            return Padding(
              padding: EdgeInsets.only(left: 8.w),
              child: _FilterChipItem(
                option: opt,
                isSelected: isSelected,
                onTap: () => onFilterChanged(opt.key),
              ),
            );
          }          ).toList(),
        ),
        ),
      ),
    );
  }
}

class _FilterChipItem extends StatelessWidget {
  final FilterOption option;
  final bool isSelected;
  final VoidCallback onTap;

  const _FilterChipItem({
    required this.option,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: AppSizes.spacingMedium,
          vertical: AppSizes.spacingSmall,
        ),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : AppColors.chipBg,
          borderRadius: BorderRadius.circular(AppSizes.radiusXLarge),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              option.label,
              style: TextStyle(
                fontFamily: 'Cairo',
                fontSize: AppSizes.fontLarge,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                color: isSelected ? AppColors.white : AppColors.textSecondary,
              ),
            ),
            SizedBox(width: 4.w),
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: 6.w,
                vertical: 2.h,
              ),
              decoration: BoxDecoration(
                color: isSelected
                    ? AppColors.white.withValues(alpha: 0.2)
                    : AppColors.inputBorder,
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Text(
                option.count.toString(),
                style: TextStyle(
                  fontFamily: 'Cairo',
                  fontSize: AppSizes.fontSmall,
                  fontWeight: FontWeight.w600,
                  color: isSelected ? AppColors.white : AppColors.textSecondary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
