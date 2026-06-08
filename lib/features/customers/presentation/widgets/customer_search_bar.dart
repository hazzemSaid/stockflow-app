import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_strings.dart';

class CustomerSearchBar extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  final VoidCallback? onClear;
  final VoidCallback? onAdd;

  const CustomerSearchBar({
    super.key,
    required this.controller,
    required this.onChanged,
    this.onClear,
    this.onAdd,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: AppSizes.spacingMedium,
        vertical: AppSizes.spacingSmall,
      ),
      child: Row(
        textDirection: TextDirection.rtl,
        children: [
          Expanded(
            child: Container(
              height: 40.h,
              decoration: BoxDecoration(
                color: AppColors.searchBg,
                borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
              ),
              child: TextField(
                controller: controller,
                onChanged: onChanged,
                textDirection: TextDirection.rtl,
                textAlign: TextAlign.right,
                style: TextStyle(
                  fontFamily: 'Cairo',
                  fontSize: AppSizes.fontLarge,
                  color: AppColors.textPrimary,
                ),
                decoration: InputDecoration(
                  hintText: AppStrings.customersSearchHint,
                  hintStyle: TextStyle(
                    fontFamily: 'Cairo',
                    fontSize: AppSizes.fontLarge,
                    color: AppColors.hintText,
                  ),
                  prefixIcon: Icon(
                    Icons.search,
                    color: AppColors.hintText,
                  ),
                  suffixIcon: controller.text.isNotEmpty
                      ? IconButton(
                          onPressed: onClear,
                          icon: Icon(
                            Icons.close,
                            color: AppColors.hintText,
                          ),
                        )
                      : null,
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 12.w,
                    vertical: 10.h,
                  ),
                ),
              ),
            ),
          ),
          SizedBox(width: AppSizes.spacingSmall),
        ],
      ),
    );
  }
}
