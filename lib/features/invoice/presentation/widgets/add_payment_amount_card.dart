import 'package:flutter/material.dart';
import 'package:stockflow/core/constants/app_colors.dart';
import 'package:stockflow/core/constants/app_sizes.dart';
import 'package:stockflow/core/constants/app_strings.dart';

class AddPaymentAmountCard extends StatelessWidget {
  final TextEditingController controller;
  final String? errorText;
  final double? maxAmount;
  final ValueChanged<String> onChanged;

  const AddPaymentAmountCard({
    super.key,
    required this.controller,
    this.errorText,
    this.maxAmount,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final borderColor = errorText != null
        ? AppColors.trendDown
        : AppColors.inputBorder;

    return Container(
      padding: EdgeInsets.all(AppSizes.spacingMedium),
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: Border.all(color: borderColor, width: 0.8),
        borderRadius: BorderRadius.circular(AppSizes.radiusLarge),
        boxShadow: [
          BoxShadow(
            color: AppColors.secondary.withValues(alpha: 0.06),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 2,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: AppSizes.spacingTiny),
            child: Text(
              AppStrings.addPaymentAmountLabel,
              style: TextStyle(
                fontFamily: 'Cairo',
                fontWeight: FontWeight.w500,
                fontSize: AppSizes.fontSmall + 1,
                color: AppColors.textSecondary,
              ),
            ),
          ),
          if (maxAmount != null) ...[
            SizedBox(height: AppSizes.spacingTiny),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: AppSizes.spacingTiny),
              child: Text(
                '${AppStrings.customerRemainingLabel}: ${maxAmount!.toInt()} ج.م',
                style: TextStyle(
                  fontFamily: 'Cairo',
                  fontSize: AppSizes.fontSmall - 1,
                  color: AppColors.textSecondary,
                ),
              ),
            ),
          ],
          SizedBox(height: AppSizes.spacingSmall),
          TextField(
            controller: controller,
            onChanged: onChanged,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            textAlign: TextAlign.right,
            decoration: InputDecoration(
              hintText: AppStrings.addPaymentAmountHint,
              hintStyle: TextStyle(
                fontFamily: 'Cairo',
                color: AppColors.hintText,
                fontSize: AppSizes.fontLarge,
              ),
              filled: true,
              fillColor: AppColors.inputBackground,
              contentPadding: EdgeInsets.symmetric(
                horizontal: AppSizes.spacingMedium,
                vertical: AppSizes.spacingMedium - 4,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
                borderSide: BorderSide(color: borderColor, width: 0.8),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
                borderSide: BorderSide(color: borderColor, width: 0.8),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
                borderSide: BorderSide(
                  color: errorText != null
                      ? AppColors.trendDown
                      : AppColors.primary,
                  width: 0.8,
                ),
              ),
              suffixIcon: Padding(
                padding: EdgeInsets.only(left: AppSizes.spacingMedium),
                child: Text(
                  'ج.م',
                  style: TextStyle(
                    fontFamily: 'Cairo',
                    fontSize: AppSizes.fontMedium,
                    color: AppColors.hintText,
                  ),
                ),
              ),
              suffixIconConstraints: const BoxConstraints(),
            ),
          ),
          if (errorText != null) ...[
            SizedBox(height: AppSizes.spacingTiny),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: AppSizes.spacingTiny),
              child: Text(
                errorText!,
                style: TextStyle(
                  fontFamily: 'Cairo',
                  fontSize: AppSizes.fontSmall,
                  color: AppColors.trendDown,
                ),
              ),
            ),
          ],
          SizedBox(height: AppSizes.spacingMedium - 4),
          Divider(color: AppColors.searchBg, height: 1, thickness: 1),
        ],
      ),
    );
  }
}
