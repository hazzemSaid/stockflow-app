import 'package:flutter/material.dart';
import 'package:makhzanflow/core/constants/app_colors.dart';
import 'package:makhzanflow/core/constants/app_sizes.dart';
import 'package:makhzanflow/core/constants/app_strings.dart';

class WelcomeHero extends StatelessWidget {
  const WelcomeHero({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          AppStrings.welcomeTitle,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontFamily: 'Cairo',
            color: AppColors.white,
            fontSize: AppSizes.fontXXXLarge,
            fontWeight: FontWeight.w400,
            height: AppSizes.welcomeLineHeight,
          ),
        ),
        SizedBox(height: AppSizes.spacingSmall),
        Text(
          AppStrings.welcomeSubtitle,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontFamily: 'Cairo',
            color: AppColors.white.withValues(alpha: 0.6),
            fontSize: AppSizes.fontMedium,
            fontWeight: FontWeight.w400,
            height: AppSizes.welcomeSubtitleLineHeight,
          ),
        ),
      ],
    );
  }
}

