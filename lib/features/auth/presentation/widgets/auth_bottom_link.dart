import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';

class AuthBottomLink extends StatelessWidget {
  final String label;
  final String actionLabel;
  final String route;

  const AuthBottomLink({
    super.key,
    required this.label,
    required this.actionLabel,
    required this.route,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          label,
          style: TextStyle(
            fontFamily: 'Cairo',
            fontSize: AppSizes.fontMedium,
            color: AppColors.textSecondary,
          ),
        ),
        GestureDetector(
          onTap: () => context.go(route),
          child: Text(
            actionLabel,
            style: TextStyle(
              fontFamily: 'Cairo',
              fontSize: AppSizes.fontMedium,
              color: AppColors.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}
