import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_strings.dart';
import 'google_sign_in_button.dart';

class GoogleAuthSection extends StatelessWidget {
  final String label;
  final bool isLoading;
  final VoidCallback? onPressed;

  const GoogleAuthSection({
    super.key,
    required this.label,
    required this.isLoading,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            const Expanded(child: Divider(color: AppColors.inputBorder)),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: AppSizes.spacingSmall,
              ),
              child: Text(
                AppStrings.orContinueWith,
                style: TextStyle(
                  color: AppColors.hintText,
                  fontSize: AppSizes.fontMedium,
                  fontFamily: 'Cairo',
                ),
              ),
            ),
            const Expanded(child: Divider(color: AppColors.inputBorder)),
          ],
        ),
        SizedBox(height: AppSizes.spacingLarge),
        GoogleSignInButton(
          label: label,
          isLoading: isLoading,
          onPressed: onPressed,
        ),
      ],
    );
  }
}
