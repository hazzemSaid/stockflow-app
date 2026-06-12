import 'package:flutter/material.dart';
import 'package:stockflow/core/constants/app_colors.dart';
import 'package:stockflow/core/constants/app_strings.dart';

class ProductPickerEmptyState extends StatelessWidget {
  const ProductPickerEmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        AppStrings.productEmptySearch,
        style: TextStyle(color: AppColors.textSecondary),
      ),
    );
  }
}
