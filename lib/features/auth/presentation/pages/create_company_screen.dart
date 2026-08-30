import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:makhzanflow/core/constants/app_colors.dart';
import 'package:makhzanflow/core/constants/app_sizes.dart';
import 'package:makhzanflow/core/constants/app_routes.dart';
import 'package:makhzanflow/core/constants/app_strings.dart';
import 'package:makhzanflow/core/widgets/app_snackbar.dart';
import 'package:makhzanflow/features/auth/presentation/cubit/create_company_cubit.dart';
import 'package:makhzanflow/features/auth/presentation/widgets/logo_picker.dart';

class CreateCompanyScreen extends StatefulWidget {
  const CreateCompanyScreen({super.key});

  @override
  State<CreateCompanyScreen> createState() => _CreateCompanyScreenState();
}

class _CreateCompanyScreenState extends State<CreateCompanyScreen>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();
  String? _selectedType;
  final List<String> _businessTypes = [
    AppStrings.businessTypeWholesale,
    AppStrings.businessTypeRetail,
    AppStrings.businessTypePharmacy,
    AppStrings.businessTypeSupermarket,
    AppStrings.businessTypeRestaurant,
    AppStrings.businessTypeOther,
  ];

  late final AnimationController _animController;
  late final Animation<double> _contentFade;
  late final Animation<double> _contentSlide;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _contentFade = CurvedAnimation(
      parent: _animController,
      curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
    );
    _contentSlide = CurvedAnimation(
      parent: _animController,
      curve: const Interval(0.0, 0.6, curve: Curves.easeOutCubic),
    );
    _animController.forward();
  }

  @override
  void dispose() {
    _animController.dispose();
    _nameController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      body: BlocConsumer<CreateCompanyCubit, CreateCompanyState>(
        listener: (context, state) {
          if (state.status == CreateCompanyStatus.success) {
            context.go(AppRoutes.dashboard);
          } else if (state.status == CreateCompanyStatus.error &&
              state.errorMessage != null) {
            AppSnackbar.error(context, state.errorMessage!);
          }
        },
        builder: (context, state) {
          return SafeArea(
            child: Column(
              children: [
                _buildHeader(context),
                Expanded(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.fromLTRB(
                      AppSizes.spacingMedium,
                      AppSizes.spacingSmall,
                      AppSizes.spacingMedium,
                      AppSizes.spacingMedium,
                    ),
                    child: AnimatedBuilder(
                      animation: _contentSlide,
                      builder: (context, child) => Opacity(
                        opacity: _contentFade.value,
                        child: Transform.translate(
                          offset: Offset(
                            0,
                            AppSizes.spacingLarge * (1 - _contentSlide.value),
                          ),
                          child: child,
                        ),
                      ),
                      child: Form(
                        key: _formKey,
                        child: _buildFormContent(context, state),
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

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
        AppSizes.spacingMedium,
        AppSizes.spacingTiny,
        AppSizes.spacingMedium,
        AppSizes.spacingSmall,
      ),
      child: Row(
        children: [
          Container(
            width: AppSizes.backButtonSize,
            height: AppSizes.backButtonSize,
            decoration: const BoxDecoration(
              color: AppColors.chipBg,
              shape: BoxShape.circle,
            ),
            child: IconButton(
              icon: Icon(
                Icons.arrow_back_rounded,
                size: AppSizes.backButtonSize / 2,
                color: AppColors.textDark,
              ),
              onPressed: () => context.pop(),
              padding: EdgeInsets.zero,
            ),
          ),
          SizedBox(width: AppSizes.spacingSmall),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                AppStrings.createBusiness,
                style: TextStyle(
                  fontFamily: 'Cairo',
                  fontSize: AppSizes.fontXLarge,
                  fontWeight: FontWeight.w400,
                  color: AppColors.secondary,
                ),
              ),
              Text(
                AppStrings.createBusinessSubtitle,
                style: TextStyle(
                  fontFamily: 'Cairo',
                  fontSize: AppSizes.fontMedium,
                  fontWeight: FontWeight.w400,
                  color: AppColors.amountGrey,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFormContent(BuildContext context, CreateCompanyState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Center(
          child: LogoPicker(
            imagePath: state.imagePath,
            onPickFromGallery: () =>
                context.read<CreateCompanyCubit>().pickImageFromGallery(),
            onPickFromCamera: () =>
                context.read<CreateCompanyCubit>().pickImageFromCamera(),
            onClear: () => context.read<CreateCompanyCubit>().clearImage(),
          ),
        ),
        SizedBox(height: AppSizes.formFieldTopPadding),
        _buildFormField(
          label: AppStrings.businessNameLabel,
          hint: AppStrings.businessNameHint,
          icon: Icons.store_outlined,
          controller: _nameController,
          enabled: state.status != CreateCompanyStatus.loading,
          validator: (v) => v == null || v.trim().isEmpty
              ? AppStrings.businessNameRequired
              : null,
        ),
        _buildTypeLabel(),
        SizedBox(height: AppSizes.spacingTiny),
        _buildTypeChips(context),
        _buildFormField(
          label: AppStrings.phone,
          hint: '01XXXXXXXXX',
          icon: Icons.phone_outlined,
          controller: _phoneController,
          enabled: state.status != CreateCompanyStatus.loading,
          keyboardType: TextInputType.phone,
        ),
        _buildFormField(
          label: AppStrings.address,
          hint: 'مثال: ١٥ شارع التحرير، القاهرة',
          icon: Icons.location_on_outlined,
          controller: _addressController,
          enabled: state.status != CreateCompanyStatus.loading,
          maxLines: 2,
        ),
        SizedBox(height: AppSizes.spacingLarge),
        _buildBottomButtons(context, state),
      ],
    );
  }

  Widget _buildFormField({
    required String label,
    required String hint,
    required IconData icon,
    required TextEditingController controller,
    bool enabled = true,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
    int maxLines = 1,
  }) {
    return Padding(
      padding: EdgeInsets.only(top: AppSizes.spacingLarge),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontFamily: 'Cairo',
              fontSize: AppSizes.fontMedium,
              fontWeight: FontWeight.w500,
              color: AppColors.darkGrey,
            ),
          ),
          SizedBox(height: AppSizes.spacingSmall),
          Container(
            constraints: BoxConstraints(minHeight: AppSizes.fieldHeight),
            decoration: BoxDecoration(
              color: AppColors.inputBackground,
              border: Border.all(
                color: AppColors.inputBorder,
                width: AppSizes.borderWidthThin,
              ),
              borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
            ),
            child: TextFormField(
              controller: controller,
              enabled: enabled,
              keyboardType: keyboardType,
              maxLines: maxLines,
              validator: validator,
              decoration: InputDecoration(
                hintText: hint,
                hintStyle: TextStyle(
                  fontFamily: 'Cairo',
                  fontSize: AppSizes.fontLarge,
                  color: AppColors.hintText,
                ),
                prefixIcon: Icon(
                  icon,
                  size: AppSizes.fieldIconSize,
                  color: AppColors.hintText,
                ),
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(
                  horizontal: AppSizes.spacingSmall,
                  vertical: maxLines > 1 ? AppSizes.spacingSmall : 0,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTypeLabel() {
    return Padding(
      padding: EdgeInsets.only(top: AppSizes.spacingLarge),
      child: Text(
        AppStrings.businessTypeLabel,
        style: TextStyle(
          fontFamily: 'Cairo',
          fontSize: AppSizes.fontMedium,
          fontWeight: FontWeight.w500,
          color: AppColors.darkGrey,
        ),
      ),
    );
  }

  Widget _buildTypeChips(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: AppSizes.spacingTiny),
      child: Wrap(
        spacing: AppSizes.spacingTiny,
        runSpacing: AppSizes.spacingTiny,
        children: _businessTypes.map((type) {
          final isSelected = _selectedType == type;
          return GestureDetector(
            onTap: () => setState(() => _selectedType = type),
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: AppSizes.spacingSmall + 2,
                vertical: AppSizes.spacingTiny / 2,
              ),
              decoration: BoxDecoration(
                color: isSelected ? AppColors.lightGreen : AppColors.chipBg,
                border: isSelected
                    ? Border.all(
                        color: AppColors.primary.withValues(alpha: 0.19),
                        width: AppSizes.borderWidthThin,
                      )
                    : null,
                borderRadius: BorderRadius.circular(AppSizes.radiusXXLarge),
              ),
              child: Text(
                type,
                style: TextStyle(
                  fontFamily: 'Cairo',
                  fontSize: AppSizes.chipFontSize,
                  color: isSelected ? AppColors.primary : AppColors.amountGrey,
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildBottomButtons(BuildContext context, CreateCompanyState state) {
    final isLoading = state.status == CreateCompanyStatus.loading;

    return Row(
      children: [
        Expanded(
          child: SizedBox(
            height: AppSizes.buttonBottomHeight,
            child: OutlinedButton(
              onPressed: isLoading ? null : () => context.pop(),
              style: OutlinedButton.styleFrom(
                side: BorderSide(
                  color: AppColors.inputBorder,
                  width: AppSizes.borderWidthThin,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
                ),
              ),
              child: Text(
                AppStrings.cancelButton,
                style: TextStyle(
                  fontFamily: 'Cairo',
                  fontSize: AppSizes.fontLarge,
                  fontWeight: FontWeight.w500,
                  color: AppColors.darkGrey,
                ),
              ),
            ),
          ),
        ),
        SizedBox(width: AppSizes.spacingSmall),
        Expanded(
          child: SizedBox(
            height: AppSizes.buttonBottomHeight,
            child: ElevatedButton(
              onPressed: isLoading ? null : () => _submitForm(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: AppColors.white,
                shadowColor: AppColors.primary.withValues(alpha: 0.25),
                elevation: 8,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
                ),
              ),
              child: isLoading
                  ? SizedBox(
                      width: AppSizes.iconMedium,
                      height: AppSizes.iconMedium,
                      child: CircularProgressIndicator(
                        strokeWidth: AppSizes.strokeWidthMedium,
                        color: AppColors.white,
                      ),
                    )
                  : Text(
                      AppStrings.createBusinessButton,
                      style: TextStyle(
                        fontFamily: 'Cairo',
                        fontSize: AppSizes.fontLarge,
                        fontWeight: FontWeight.w500,
                        color: AppColors.white,
                      ),
                    ),
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _submitForm(BuildContext context) async {
    if (!_formKey.currentState!.validate()) return;
    context.read<CreateCompanyCubit>().createCompany(
      name: _nameController.text,
      businessType: _selectedType,
      phone: _phoneController.text,
      address: _addressController.text,
    );
  }
}
