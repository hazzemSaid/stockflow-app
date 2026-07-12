import 'package:flutter/material.dart';
import 'package:makhzanflow/core/constants/app_colors.dart';
import 'package:makhzanflow/core/constants/app_sizes.dart';

class ShareCodeWidget extends StatelessWidget {
  final String code;
  final VoidCallback onCopy;
  final VoidCallback onRegenerate;

  const ShareCodeWidget({
    super.key,
    required this.code,
    required this.onCopy,
    required this.onRegenerate,
  });

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(AppSizes.spacingMedium),
        decoration: BoxDecoration(
          color: AppColors.lightGreen,
          borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
          border: Border.all(
            color: AppColors.primary.withAlpha(51),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                code,
                textDirection: TextDirection.ltr,
                style: TextStyle(
                  fontFamily: 'monospace',
                  fontSize: AppSizes.fontXXLarge,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                  letterSpacing: 4,
                ),
              ),
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(
                    Icons.copy,
                    color: AppColors.primary,
                    size: AppSizes.iconMedium,
                  ),
                  onPressed: onCopy,
                  tooltip: 'نسخ',
                ),
                IconButton(
                  icon: Icon(
                    Icons.refresh,
                    color: AppColors.primary,
                    size: AppSizes.iconMedium,
                  ),
                  onPressed: onRegenerate,
                  tooltip: 'تغيير',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
