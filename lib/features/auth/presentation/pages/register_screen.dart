import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/constants/app_routes.dart';
import '../../../../core/company/company_cubit.dart';
import '../../../../core/widgets/app_snackbar.dart';
import '../cubit/auth_cubit.dart';
import '../cubit/auth_state.dart';
import '../widgets/auth_text_field.dart';
import '../widgets/auth_header.dart';
import '../widgets/auth_button.dart';
import '../widgets/auth_bottom_link.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _onRegister() {
    if (_formKey.currentState!.validate()) {
      context.read<AuthCubit>().signUp(
        _emailController.text.trim(),
        _passwordController.text,
        _nameController.text.trim(),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.appBackground,
      body: BlocConsumer<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state is Authenticated) {
            context.read<CompanyCubit>().loadCompanies();
          } else if (state is AuthError) {
            AppSnackbar.error(context, state.message);
          }
        },
        builder: (context, state) {
          final isLoading = state is AuthLoading;

          return SafeArea(
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
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            AuthHeader(
                              title: AppStrings.registerWelcome,
                              subtitle: AppStrings.registerToContinue,
                            ),
                            SizedBox(height: AppSizes.spacingXLarge),
                            AuthTextField(
                              controller: _nameController,
                              label: AppStrings.nameLabel,
                              hintText: AppStrings.nameHint,
                              prefixIcon: Icons.person_outline,
                              enabled: !isLoading,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return AppStrings.nameRequired;
                                }
                                return null;
                              },
                            ),
                            SizedBox(height: AppSizes.spacingMedium),
                            AuthTextField(
                              controller: _emailController,
                              label: AppStrings.emailLabel,
                              hintText: AppStrings.emailHint,
                              prefixIcon: Icons.email_outlined,
                              keyboardType: TextInputType.emailAddress,
                              enabled: !isLoading,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return AppStrings.emailRequired;
                                }
                                if (!value.contains('@')) {
                                  return AppStrings.emailInvalid;
                                }
                                return null;
                              },
                            ),
                            SizedBox(height: AppSizes.spacingMedium),
                            AuthTextField(
                              controller: _passwordController,
                              label: AppStrings.passwordLabel,
                              hintText: AppStrings.passwordHint,
                              prefixIcon: Icons.lock_outline,
                              obscureText: _obscurePassword,
                              enabled: !isLoading,
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _obscurePassword
                                      ? Icons.visibility_off
                                      : Icons.visibility,
                                  color: AppColors.grey,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _obscurePassword = !_obscurePassword;
                                  });
                                },
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return AppStrings.passwordRequired;
                                }
                                if (value.length < 6) {
                                  return AppStrings.passwordMinLength;
                                }
                                return null;
                              },
                            ),
                            SizedBox(height: AppSizes.spacingMedium),
                            AuthTextField(
                              controller: _confirmPasswordController,
                              label: AppStrings.confirmPasswordLabel,
                              hintText: AppStrings.confirmPasswordHint,
                              prefixIcon: Icons.lock_outline,
                              obscureText: _obscureConfirmPassword,
                              enabled: !isLoading,
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _obscureConfirmPassword
                                      ? Icons.visibility_off
                                      : Icons.visibility,
                                  color: AppColors.grey,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _obscureConfirmPassword =
                                        !_obscureConfirmPassword;
                                  });
                                },
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return AppStrings.passwordRequired;
                                }
                                if (value != _passwordController.text) {
                                  return AppStrings.passwordMismatch;
                                }
                                return null;
                              },
                            ),
                            SizedBox(height: AppSizes.spacingXLarge),
                            AuthButton(
                              label: AppStrings.registerButton,
                              isLoading: isLoading,
                              onPressed: _onRegister,
                            ),
                            SizedBox(height: AppSizes.spacingLarge),
                            AuthBottomLink(
                              label: AppStrings.alreadyHaveAccount,
                              actionLabel: AppStrings.loginNow,
                              route: AppRoutes.login,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
