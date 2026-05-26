import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';

class AuthHeader extends StatelessWidget {
  final String title;
  final String subtitle;

  const AuthHeader({
    super.key,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: AppSizes.loginIconBoxSize,
          height: AppSizes.loginIconBoxSize,
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(AppSizes.radiusLarge),
          ),
          child: Image.asset(
            'assets/images/logo.png',
            height: 60,
            width: 60,
            fit: BoxFit.contain,
          ),
        ),
        SizedBox(height: AppSizes.spacingMedium),
        Text(
          title,
          style: TextStyle(
            fontFamily: 'Cairo',
            fontSize: AppSizes.fontXXLarge,
            color: AppColors.secondary,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: AppSizes.spacingTiny),
        Text(
          subtitle,
          style: TextStyle(
            fontFamily: 'Cairo',
            fontSize: AppSizes.fontMedium,
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }
}
