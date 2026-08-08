import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:makhzanflow/core/company/company_cubit.dart';
import 'package:makhzanflow/core/constants/app_colors.dart';
import 'package:makhzanflow/core/constants/app_sizes.dart';
import 'package:makhzanflow/core/constants/app_routes.dart';
import 'package:makhzanflow/core/constants/app_strings.dart';
import 'package:makhzanflow/core/di/service_locator.dart';
import 'package:makhzanflow/core/widgets/app_snackbar.dart';
import 'package:makhzanflow/features/companies/domain/usecases/create_company_full_usecase.dart';

class CreateBusinessScreen extends StatefulWidget {
  const CreateBusinessScreen({super.key});

  @override
  State<CreateBusinessScreen> createState() => _CreateBusinessScreenState();
}

class _CreateBusinessScreenState extends State<CreateBusinessScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();

  bool _isLoading = false;
  String? _selectedType;
  final List<String> _businessTypes = [
    AppStrings.businessTypeWholesale,
    AppStrings.businessTypeRetail,
    AppStrings.businessTypePharmacy,
    AppStrings.businessTypeSupermarket,
    AppStrings.businessTypeRestaurant,
    AppStrings.businessTypeOther,
  ];

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  Future<void> _createCompany() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    final useCase = sl<CreateCompanyFullUseCase>();
    final result = await useCase.call(
      name: _nameController.text.trim(),
      businessType: _selectedType,
      phone: _phoneController.text.trim().isEmpty
          ? null
          : _phoneController.text.trim(),
      address: _addressController.text.trim().isEmpty
          ? null
          : _addressController.text.trim(),
    );

    if (!mounted) return;

    result.fold((failure) {
      setState(() => _isLoading = false);
      AppSnackbar.error(context, failure.message);
    }, (_) {});

    final company = result.getRight().toNullable();
    if (company != null) {
      try {
        await context.read<CompanyCubit>().switchCompany(company);
        if (!mounted) return;
        context.go(AppRoutes.dashboard);
      } catch (e) {
        if (!mounted) return;
        setState(() => _isLoading = false);
        AppSnackbar.error(context, e.toString());
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.appBackground,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.white,
        title: Text(AppStrings.createCompany),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(AppSizes.spacingLarge),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: AppSizes.spacingLarge),
              Center(
                child: GestureDetector(
                  onTap: () {},
                  child: CircleAvatar(
                    radius: AppSizes.iconXLarge * 1.25,
                    backgroundColor: AppColors.primary.withValues(alpha: 0.1),
                    child: Icon(
                      Icons.add_a_photo_outlined,
                      size: AppSizes.iconLarge,
                      color: AppColors.primary,
                    ),
                  ),
                ),
              ),
              SizedBox(height: AppSizes.spacingLarge),
              Center(
                child: Text(
                  AppStrings.logoPickerHint,
                  style: TextStyle(
                    fontSize: AppSizes.fontSmall,
                    color: AppColors.textSecondary,
                  ),
                ),
              ),
              SizedBox(height: AppSizes.spacingXLarge),
              Text(
                AppStrings.businessType,
                style: TextStyle(
                  fontSize: AppSizes.fontMedium,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
              SizedBox(height: AppSizes.spacingSmall),
              DropdownButtonFormField<String>(
                initialValue: _selectedType,
                decoration: InputDecoration(
                  hintText: AppStrings.businessTypeHint,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(
                      AppSizes.radiusMedium,
                    ),
                  ),
                ),
                items: _businessTypes.map((t) {
                  return DropdownMenuItem(
                    value: t,
                    child: Text(t),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() => _selectedType = value);
                },
              ),
              SizedBox(height: AppSizes.spacingLarge),
              Text(
                AppStrings.companyName,
                style: TextStyle(
                  fontSize: AppSizes.fontMedium,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
              SizedBox(height: AppSizes.spacingSmall),
              TextFormField(
                controller: _nameController,
                enabled: !_isLoading,
                decoration: InputDecoration(
                  hintText: AppStrings.companyNameHint,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return AppStrings.companyNameRequired;
                  }
                  return null;
                },
              ),
              SizedBox(height: AppSizes.spacingLarge),
              Text(
                AppStrings.phone,
                style: TextStyle(
                  fontSize: AppSizes.fontMedium,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
              SizedBox(height: AppSizes.spacingSmall),
              TextFormField(
                controller: _phoneController,
                enabled: !_isLoading,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                  hintText: AppStrings.phoneHint,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
                  ),
                ),
              ),
              SizedBox(height: AppSizes.spacingLarge),
              Text(
                AppStrings.address,
                style: TextStyle(
                  fontSize: AppSizes.fontMedium,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
              SizedBox(height: AppSizes.spacingSmall),
              TextFormField(
                controller: _addressController,
                enabled: !_isLoading,
                decoration: InputDecoration(
                  hintText: AppStrings.addressHint,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
                  ),
                ),
              ),
              SizedBox(height: AppSizes.spacingXLarge * 2),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _createCompany,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: AppColors.white,
                    padding: EdgeInsets.all(AppSizes.spacingMedium),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppSizes.radiusLarge),
                    ),
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
                          AppStrings.createCompanyButton,
                          style: TextStyle(fontSize: AppSizes.fontLarge),
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
