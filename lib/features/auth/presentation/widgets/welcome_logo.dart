import 'package:flutter/material.dart';
import 'package:stockflow/core/constants/app_colors.dart';
import 'package:stockflow/core/constants/app_sizes.dart';
import 'package:stockflow/core/constants/app_strings.dart';
import 'package:stockflow/features/auth/presentation/widgets/welcome_painters.dart';

class WelcomeLogo extends StatelessWidget {
  const WelcomeLogo({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: AppSizes.logoContainerSize,
          height: AppSizes.logoContainerSize,
          decoration: BoxDecoration(
            color: AppColors.white.withValues(alpha: 0.12),
            border: Border.all(
              color: AppColors.white.withValues(alpha: 0.2),
              width: AppSizes.borderWidthThin,
            ),
            borderRadius: BorderRadius.circular(AppSizes.radiusXLarge),
          ),
          child: Center(
            child: SizedBox(
              width: AppSizes.logoIconSize,
              height: AppSizes.logoIconSize,
              child: const CustomPaint(painter: StockIconPainter()),
            ),
          ),
        ),
        SizedBox(height: AppSizes.spacingSmall),
        Text(
          AppStrings.appName,
          style: TextStyle(
            fontFamily: 'Cairo',
            color: AppColors.white,
            fontSize: AppSizes.fontXXLarge,
            fontWeight: FontWeight.w400,
            letterSpacing: AppSizes.welcomeLetterSpacing,
          ),
        ),
        SizedBox(height: AppSizes.spacingTiny),
        Text(
          AppStrings.welcomeAppSubtitle,
          style: TextStyle(
            fontFamily: 'Cairo',
            color: AppColors.white.withValues(alpha: 0.6),
            fontSize: AppSizes.fontMedium,
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    );
  }
}

