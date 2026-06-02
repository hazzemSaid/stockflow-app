import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_strings.dart';

class ProductEmptyView extends StatelessWidget {
  final String message;
  final VoidCallback? onAction;

  const ProductEmptyView({
    super.key,
    this.message = AppStrings.emptyProducts,
    this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(AppSizes.spacingLarge),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.inventory_2_outlined,
              size: 64.w,
              color: AppColors.grey,
            ),
            SizedBox(height: AppSizes.spacingMedium),
            Text(
              message,
              style: TextStyle(
                fontFamily: 'Cairo',
                fontSize: AppSizes.fontLarge,
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
