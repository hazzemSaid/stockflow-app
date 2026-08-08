import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:makhzanflow/core/constants/app_colors.dart';
import 'package:makhzanflow/core/constants/app_sizes.dart';
import 'package:makhzanflow/core/constants/app_routes.dart';
import 'package:makhzanflow/core/constants/app_strings.dart';
import 'package:makhzanflow/core/widgets/app_snackbar.dart';
import 'package:makhzanflow/features/companies/presentation/cubit/join_company_cubit.dart';

class JoinBusinessScreen extends StatefulWidget {
  const JoinBusinessScreen({super.key});

  @override
  State<JoinBusinessScreen> createState() => _JoinBusinessScreenState();
}

class _JoinBusinessScreenState extends State<JoinBusinessScreen> {
  late final JoinCompanyCubit _cubit;
  final _inviteCodeController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _initialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_initialized) {
      _cubit = context.read<JoinCompanyCubit>();
      _initialized = true;
    }
  }

  @override
  void dispose() {
    _inviteCodeController.dispose();
    super.dispose();
  }

  Future<void> _joinByCode() async {
    if (!_formKey.currentState!.validate()) return;
    _cubit.joinByCode(_inviteCodeController.text.trim());
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<JoinCompanyCubit, JoinCompanyState>(
      listener: (context, state) {
        if (state is JoinCompanyCodeSent) {
          context.go(
            AppRoutes.welcomePending,
            extra: {
              'requestId': state.requestId,
              'companyId': state.companyId,
              'companyName': state.companyName,
              'companyLogo': state.companyLogo,
            },
          );
        } else if (state is JoinCompanyError) {
          AppSnackbar.error(context, state.message);
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.appBackground,
        appBar: AppBar(
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.white,
          title: Text(AppStrings.joinCompany),
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.all(AppSizes.spacingXLarge),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: AppSizes.spacingLarge),
                Icon(
                  Icons.vpn_key_outlined,
                  size: AppSizes.iconXLarge * 1.6,
                  color: AppColors.primary,
                ),
                SizedBox(height: AppSizes.spacingLarge),
                Text(
                  AppStrings.inviteCodeTitle,
                  style: TextStyle(
                    fontSize: AppSizes.fontXLarge,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                SizedBox(height: AppSizes.spacingSmall),
                Text(
                  AppStrings.inviteCodeSubtitle,
                  style: TextStyle(
                    fontSize: AppSizes.fontMedium,
                    color: AppColors.textSecondary,
                  ),
                ),
                SizedBox(height: AppSizes.spacingLarge),
                TextFormField(
                  controller: _inviteCodeController,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: AppSizes.fontXLarge,
                    letterSpacing: 4,
                    fontWeight: FontWeight.bold,
                  ),
                  decoration: InputDecoration(
                    hintText: AppStrings.inviteCodeHint,
                    hintStyle: TextStyle(
                      letterSpacing: 4,
                      color: AppColors.textSecondary,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(
                        AppSizes.radiusMedium,
                      ),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return AppStrings.inviteCodeRequired;
                    }
                    return null;
                  },
                ),
                SizedBox(height: AppSizes.spacingXLarge),
                BlocBuilder<JoinCompanyCubit, JoinCompanyState>(
                  builder: (context, state) {
                    final isLoading = state is JoinCompanyLoading;
                    return SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: isLoading ? null : _joinByCode,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: AppColors.white,
                          padding: EdgeInsets.all(AppSizes.spacingMedium),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                              AppSizes.radiusLarge,
                            ),
                          ),
                        ),
                        child: isLoading
                            ? SizedBox(
                                height: AppSizes.iconMedium,
                                width: AppSizes.iconMedium,
                                child: CircularProgressIndicator(
                                  strokeWidth: AppSizes.strokeWidthMedium,
                                  color: AppColors.white,
                                ),
                              )
                            : Text(
                                AppStrings.joinButton,
                                style: TextStyle(fontSize: AppSizes.fontLarge),
                              ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
