import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:stockflow/core/company/company_cubit.dart';
import 'package:stockflow/core/company/company_state.dart';
import 'package:stockflow/core/constants/app_colors.dart';
import 'package:stockflow/core/constants/app_sizes.dart';
import 'package:stockflow/core/constants/app_strings.dart';
import 'package:stockflow/core/di/service_locator.dart';
import 'package:stockflow/core/widgets/app_snackbar.dart';
import '../../../../features/auth/presentation/cubit/auth_cubit.dart';
import '../../../../features/auth/presentation/cubit/auth_state.dart';
import '../cubit/add_edit_product/add_edit_product_cubit.dart';
import '../widgets/product_form_fields.dart';
import '../widgets/product_image_picker_field.dart';
import '../widgets/product_save_button.dart';

class AddEditProductScreen extends StatefulWidget {
  final String? productId;

  const AddEditProductScreen({super.key, this.productId});

  @override
  State<AddEditProductScreen> createState() => _AddEditProductScreenState();
}

class _AddEditProductScreenState extends State<AddEditProductScreen> {
  late final AddEditProductCubit _cubit;
  late final String _companyId;

  bool get _isEditMode => widget.productId != null;

  @override
  void initState() {
    super.initState();
    _companyId = (context.read<CompanyCubit>().state as CompanySelected).companyId;
    _cubit = sl<AddEditProductCubit>();
    if (widget.productId != null) {
      _cubit.loadForEdit(widget.productId!, _companyId);
    }
  }

  @override
  void dispose() {
    _cubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _cubit,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            _isEditMode ? AppStrings.productEdit : AppStrings.productsAdd,
          ),
          actions: [
            TextButton(
              onPressed: () => _save(),
              child: Text(
                AppStrings.productSave,
                style: TextStyle(
                  fontFamily: 'Cairo',
                  color: AppColors.white,
                  fontSize: AppSizes.fontLarge,
                ),
              ),
            ),
          ],
        ),
        body: BlocConsumer<AddEditProductCubit, AddEditProductState>(
          listener: (context, state) {
            if (state.status == AddEditProductStatus.success) {
              AppSnackbar.success(context,
                  state.successMessage ?? AppStrings.productSaved);
              context.pop(true);
            }
            if (state.status == AddEditProductStatus.error &&
                state.errorMessage != null) {
              AppSnackbar.error(context, state.errorMessage!);
              _cubit.resetStatus();
            }
          },
          builder: (context, state) {
            if (state.status == AddEditProductStatus.loading && _isEditMode) {
              return const Center(child: CircularProgressIndicator());
            }
            return SingleChildScrollView(
              padding: EdgeInsets.all(AppSizes.spacingMedium),
              child: Column(
                children: [
                  ProductImagePickerField(
                    imageLocalPath: state.imageLocalPath,
                    imageUploadUrl: state.imageUploadUrl,
                    isUploading: state.isImageUploading,
                    onImagePicked: (path) => _cubit.setImagePath(path),
                    onRemove: () => _cubit.removeImage(),
                  ),
                  SizedBox(height: AppSizes.spacingLarge),
                  ProductFormFields(
                    name: state.input.name,
                    price: state.priceText,
                    quantity: state.quantityText,
                    expirationDate: state.expirationDate,
                    onNameChanged: _cubit.updateName,
                    onPriceChanged: _cubit.updatePrice,
                    onQuantityChanged: _cubit.updateQuantity,
                    onExpirationDateChanged: _cubit.updateExpirationDate,
                  ),
                  SizedBox(height: AppSizes.spacingLarge),
                  ProductSaveButton(
                    isLoading: state.status == AddEditProductStatus.loading,
                    isEditMode: state.isEditMode,
                    onPressed: () => _save(),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Future<void> _save() async {
    final authState = context.read<AuthCubit>().state;
    final userId = authState is Authenticated ? authState.user.id : '';
    if (userId.isEmpty) return;
    await _cubit.save(userId, _companyId);
  }
}
