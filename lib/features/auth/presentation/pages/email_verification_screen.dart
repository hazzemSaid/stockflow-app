import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:makhzanflow/core/constants/app_colors.dart';
import 'package:makhzanflow/core/constants/app_routes.dart';
import 'package:makhzanflow/core/constants/app_sizes.dart';
import 'package:makhzanflow/core/widgets/app_snackbar.dart';
import 'package:makhzanflow/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:makhzanflow/features/auth/presentation/cubit/auth_state.dart';

class EmailVerificationScreen extends StatefulWidget {
  final String email;

  const EmailVerificationScreen({super.key, required this.email});

  @override
  State<EmailVerificationScreen> createState() =>
      _EmailVerificationScreenState();
}

class _EmailVerificationScreenState extends State<EmailVerificationScreen> {
  final _tokenController = TextEditingController();
  bool _isResending = false;

  @override
  void dispose() {
    _tokenController.dispose();
    super.dispose();
  }

  Future<void> _verify() async {
    final token = _tokenController.text.trim();
    if (token.isEmpty) {
      AppSnackbar.error(context, 'يرجى إدخال رمز التحقق');
      return;
    }
    final cubit = context.read<AuthCubit>();
    await cubit.verifyEmail(widget.email, token);
  }

  Future<void> _resend() async {
    setState(() => _isResending = true);
    final cubit = context.read<AuthCubit>();
    await cubit.resendVerificationEmail(widget.email);
    if (mounted) {
      setState(() => _isResending = false);
      AppSnackbar.success(context, 'تم إعادة إرسال رمز التحقق');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.appBackground,
      body: BlocListener<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state is Authenticated) {
            context.read<AuthCubit>().checkSession();
            context.go(AppRoutes.dashboard);
          } else if (state is AuthError) {
            AppSnackbar.error(context, state.message);
          }
        },
        child: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(
                    horizontal: AppSizes.spacingLarge,
                    vertical: AppSizes.spacingXLarge,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(AppSizes.radiusXXLarge),
                      topRight: Radius.circular(AppSizes.radiusXXLarge),
                    ),
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(height: AppSizes.spacingXLarge),
                        Icon(
                          Icons.mark_email_unread_outlined,
                          size: AppSizes.iconXLarge * 2.5,
                          color: AppColors.primary,
                        ),
                        SizedBox(height: AppSizes.spacingLarge),
                        Text(
                          'تحقق من بريدك الإلكتروني',
                          style: TextStyle(
                            fontSize: AppSizes.fontXXLarge,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: AppSizes.spacingMedium),
                        Text(
                          'تم إرسال رمز التحقق إلى',
                          style: TextStyle(
                            fontSize: AppSizes.fontMedium,
                            color: AppColors.textSecondary,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: AppSizes.spacingSmall),
                        Text(
                          widget.email,
                          style: TextStyle(
                            fontSize: AppSizes.fontLarge,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: AppSizes.spacingXLarge),
                        TextField(
                          controller: _tokenController,
                          keyboardType: TextInputType.number,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: AppSizes.fontXLarge,
                            letterSpacing: 8,
                            fontWeight: FontWeight.bold,
                          ),
                          decoration: InputDecoration(
                            hintText: '000000',
                            hintStyle: TextStyle(
                              color: AppColors.textSecondary.withValues(alpha: 0.5),
                              letterSpacing: 8,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(
                                AppSizes.radiusLarge,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(
                                AppSizes.radiusLarge,
                              ),
                              borderSide: BorderSide(
                                color: AppColors.primary,
                                width: 2,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: AppSizes.spacingXLarge),
                        SizedBox(
                          width: double.infinity,
                          height: AppSizes.buttonHeight,
                          child: ElevatedButton(
                            onPressed: _verify,
                            child: Text(
                              'تحقق',
                              style: TextStyle(
                                fontSize: AppSizes.fontLarge,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: AppSizes.spacingLarge),
                        TextButton(
                          onPressed: _isResending ? null : _resend,
                          child: _isResending
                              ? SizedBox(
                                  width: 16,
                                  height: 16,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: AppColors.primary,
                                  ),
                                )
                              : Text(
                                  'إعادة إرسال الرمز',
                                  style: TextStyle(
                                    color: AppColors.primary,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                        ),
                        SizedBox(height: AppSizes.spacingLarge),
                        TextButton(
                          onPressed: () => context.go(AppRoutes.login),
                          child: Text(
                            'العودة إلى تسجيل الدخول',
                            style: TextStyle(
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
