import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/constants/app_routes.dart';
import '../cubit/auth_cubit.dart';
import '../cubit/auth_state.dart';
import '../widgets/auth_text_field.dart';
import '../widgets/auth_header.dart';
import '../widgets/auth_button.dart';
import '../widgets/auth_bottom_link.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _rememberMe = true;
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _onLogin() {
    if (_formKey.currentState!.validate()) {
      context.read<AuthCubit>().signIn(
        _emailController.text.trim(),
        _passwordController.text,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: BlocConsumer<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state is Authenticated) {
            context.go(AppRoutes.dashboard);
          } else if (state is AuthError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  state.message,
                  style: const TextStyle(fontFamily: 'Cairo'),
                ),
              ),
            );
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
                              title: AppStrings.welcomeBack,
                              subtitle: AppStrings.loginToContinue,
                            ),
                            SizedBox(height: AppSizes.spacingXLarge),
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
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    SizedBox(
                                      width: AppSizes.iconMedium,
                                      height: AppSizes.iconMedium,
                                      child: Checkbox(
                                        value: _rememberMe,
                                        activeColor: AppColors.primary,
                                        onChanged: isLoading
                                            ? null
                                            : (value) {
                                                setState(() {
                                                  _rememberMe = value ?? true;
                                                });
                                              },
                                      ),
                                    ),
                                    SizedBox(width: AppSizes.spacingSmall),
                                    Text(
                                      AppStrings.rememberMe,
                                      style: TextStyle(
                                        fontFamily: 'Cairo',
                                        fontSize: AppSizes.fontLarge,
                                        fontWeight: FontWeight.w500,
                                        color: AppColors.textPrimary,
                                      ),
                                    ),
                                  ],
                                ),
                                TextButton(
                                  onPressed: isLoading ? null : () {},
                                  child: Text(
                                    AppStrings.forgotPassword,
                                    style: TextStyle(
                                      fontFamily: 'Cairo',
                                      fontSize: AppSizes.fontMedium,
                                      color: AppColors.accent,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: AppSizes.spacingXLarge),
                            AuthButton(
                              label: AppStrings.loginButton,
                              isLoading: isLoading,
                              onPressed: _onLogin,
                            ),
                            SizedBox(height: AppSizes.spacingLarge),
                            AuthBottomLink(
                              label: AppStrings.dontHaveAccount,
                              actionLabel: AppStrings.registerNow,
                              route: AppRoutes.register,
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
