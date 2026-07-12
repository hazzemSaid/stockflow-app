import 'package:flutter/material.dart';
import 'package:makhzanflow/core/constants/app_colors.dart';
import 'package:makhzanflow/core/constants/app_strings.dart';

class CustomerPickerEmptyState extends StatelessWidget {
  const CustomerPickerEmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        AppStrings.customerEmptySearch,
        style: TextStyle(color: AppColors.textSecondary),
      ),
    );
  }
}
