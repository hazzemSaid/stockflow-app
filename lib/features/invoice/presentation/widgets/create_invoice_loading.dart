import 'package:flutter/material.dart';
import 'package:makhzanflow/core/constants/app_colors.dart';

class CreateInvoiceLoadingState extends StatelessWidget {
  const CreateInvoiceLoadingState({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.appBackground.withValues(alpha: 0.7),
      child: const Center(child: CircularProgressIndicator()),
    );
  }
}
