import 'package:flutter/material.dart';
import 'package:makhzanflow/core/constants/app_colors.dart';
import 'package:makhzanflow/core/constants/app_sizes.dart';
import 'package:makhzanflow/core/constants/app_strings.dart';

class WelcomeActions extends StatelessWidget {
  final VoidCallback onCreateBusiness;
  final VoidCallback onJoinBusiness;

  const WelcomeActions({
    super.key,
    required this.onCreateBusiness,
    required this.onJoinBusiness,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: AppSizes.spacingLarge),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: double.infinity,
            height: AppSizes.buttonMinHeight,
            child: ElevatedButton.icon(
              onPressed: onCreateBusiness,
              icon: Icon(
                Icons.add_rounded,
                size: AppSizes.iconMedium,
                color: AppColors.white,
              ),
              label: Text(
                AppStrings.createBusiness,
                style: TextStyle(
                  fontFamily: 'Cairo',
                  fontSize: AppSizes.fontLarge,
                  fontWeight: FontWeight.w500,
                  color: AppColors.white,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.accent,
                foregroundColor: AppColors.white,
                shadowColor: AppColors.accent.withValues(alpha: 0.45),
                elevation: 10,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppSizes.radiusLarge),
                ),
              ),
            ),
          ),
          SizedBox(height: AppSizes.spacingSmall),
          SizedBox(
            width: double.infinity,
            height: AppSizes.buttonMinHeight,
            child: OutlinedButton.icon(
              onPressed: onJoinBusiness,
              icon: Icon(
                Icons.group_add_outlined,
                size: AppSizes.iconMedium,
                color: AppColors.white,
              ),
              label: Text(
                AppStrings.joinBusiness,
                style: TextStyle(
                  fontFamily: 'Cairo',
                  fontSize: AppSizes.fontLarge,
                  fontWeight: FontWeight.w500,
                  color: AppColors.white,
                ),
              ),
              style: OutlinedButton.styleFrom(
                backgroundColor: AppColors.white.withValues(alpha: 0.12),
                foregroundColor: AppColors.white,
                side: BorderSide(
                  color: AppColors.white.withValues(alpha: 0.2),
                  width: AppSizes.borderWidthThin,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppSizes.radiusLarge),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

