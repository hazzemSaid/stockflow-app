import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_strings.dart';

class ProductErrorView extends StatelessWidget {
  final String message;
  final VoidCallback? onRetry;

  const ProductErrorView({
    super.key,
    this.message = AppStrings.productLoadError,
    this.onRetry,
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
              Icons.error_outline,
              size: 64.w,
              color: AppColors.error,
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
            if (onRetry != null) ...[
              SizedBox(height: AppSizes.spacingMedium),
              ElevatedButton(
                onPressed: onRetry,
                child: Text(AppStrings.productRetry),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
