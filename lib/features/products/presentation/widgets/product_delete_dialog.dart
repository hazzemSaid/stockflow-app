import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';

class DeleteConfirmationDialog extends StatelessWidget {
  final String title;
  final String message;
  final String confirmLabel;
  final String cancelLabel;

  const DeleteConfirmationDialog({
    super.key,
    this.title = AppStrings.productDelete,
    this.message = AppStrings.productDeleteConfirm,
    this.confirmLabel = AppStrings.productDelete,
    this.cancelLabel = AppStrings.productCancel,
  });

  static Future<bool?> show(BuildContext context, {
    String? title,
    String? message,
    String? confirmLabel,
    String? cancelLabel,
  }) {
    return showDialog<bool>(
      context: context,
      builder: (_) => DeleteConfirmationDialog(
        title: title ?? AppStrings.productDelete,
        message: message ?? AppStrings.productDeleteConfirm,
        confirmLabel: confirmLabel ?? AppStrings.productDelete,
        cancelLabel: cancelLabel ?? AppStrings.productCancel,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title),
      content: Text(message),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          child: Text(cancelLabel),
        ),
        TextButton(
          onPressed: () => Navigator.pop(context, true),
          child: Text(
            confirmLabel,
            style: const TextStyle(color: AppColors.error),
          ),
        ),
      ],
    );
  }
}
