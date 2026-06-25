import 'package:flutter/material.dart';
import 'package:stockflow/core/constants/app_colors.dart';
import 'package:stockflow/core/constants/app_sizes.dart';
import 'package:stockflow/core/constants/app_strings.dart';

class InviteMemberDialog extends StatefulWidget {
  final Function(String email) onInvite;

  const InviteMemberDialog({
    super.key,
    required this.onInvite,
  });

  @override
  State<InviteMemberDialog> createState() => _InviteMemberDialogState();
}

class _InviteMemberDialogState extends State<InviteMemberDialog> {
  final _emailController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: AlertDialog(
        title: Text(
          AppStrings.inviteMember,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: _emailController,
              enabled: !_isLoading,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                labelText: AppStrings.emailLabel,
                hintText: AppStrings.emailHint,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
                ),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: _isLoading ? null : () => Navigator.pop(context),
            child: Text(
              AppStrings.cancel,
              style: TextStyle(),
            ),
          ),
          ElevatedButton(
            onPressed: _isLoading ? null : _invite,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: AppColors.white,
            ),
            child: _isLoading
                ? SizedBox(
                    height: AppSizes.iconMedium,
                    width: AppSizes.iconMedium,
                    child: CircularProgressIndicator(
                      strokeWidth: AppSizes.strokeWidthMedium,
                      color: AppColors.white,
                    ),
                  )
                : Text(
                    AppStrings.invite,
                    style: TextStyle(),
                  ),
          ),
        ],
      ),
    );
  }

  void _invite() {
    if (_emailController.text.trim().isEmpty) return;
    setState(() => _isLoading = true);
    widget.onInvite(_emailController.text.trim());
  }
}
