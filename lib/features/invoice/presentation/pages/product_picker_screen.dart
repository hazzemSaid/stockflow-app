import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:stockflow/core/constants/app_colors.dart';
import 'package:stockflow/core/constants/app_sizes.dart';
import 'package:stockflow/core/constants/app_strings.dart';
import 'package:stockflow/features/invoice/presentation/cubit/create_invoice/create_invoice_cubit.dart';
import 'package:stockflow/features/invoice/presentation/cubit/product_picker/product_picker_cubit.dart';
import 'package:stockflow/features/invoice/presentation/widgets/product_picker_body.dart';

class ProductPickerScreen extends StatefulWidget {
  final CreateInvoiceCubit createCubit;

  const ProductPickerScreen({super.key, required this.createCubit});

  @override
  State<ProductPickerScreen> createState() => _ProductPickerScreenState();
}

class _ProductPickerScreenState extends State<ProductPickerScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.appBackground,
      appBar: AppBar(
        backgroundColor: AppColors.appBackground,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: AppColors.textDark,
            size: AppSizes.iconMedium,
          ),
          onPressed: () => context.pop(),
        ),
        title: Text(
          AppStrings.productPickerTitle,
          style: TextStyle(
            fontSize: AppSizes.fontXLarge,
            fontWeight: FontWeight.w600,
            color: AppColors.textDark,
          ),
        ),
      ),
      body: const ProductPickerBody(),
      bottomNavigationBar: BlocBuilder<ProductPickerCubit, ProductPickerState>(
        builder: (context, state) {
          final count = state is ProductPickerLoaded
              ? state.selectedProductIds.length
              : 0;
          if (count == 0) return const SizedBox.shrink();
          return Container(
            padding: EdgeInsets.all(AppSizes.spacingMedium),
            decoration: BoxDecoration(
              color: AppColors.surface,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 10,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: SafeArea(
              top: false,
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      '$count ${AppStrings.productsAvailable}',
                      style: TextStyle(
                        fontSize: AppSizes.fontLarge,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textDark,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: AppSizes.buttonHeight,
                    child: ElevatedButton(
                      onPressed: () {
                        _confirmSelection(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: AppColors.surface,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                            AppSizes.radiusSmall,
                          ),
                        ),
                        padding: EdgeInsets.symmetric(
                          horizontal: AppSizes.spacingLarge,
                        ),
                      ),
                      child: Text(
                        '${AppStrings.done} ($count)',
                        style: TextStyle(
                          fontSize: AppSizes.fontLarge,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  void _confirmSelection(BuildContext context) {
    final pickerCubit = context.read<ProductPickerCubit>();
    final selected = pickerCubit.getSelectedProducts();

    for (final product in selected) {
      widget.createCubit.addProduct(
        SelectedProduct(
          productId: product.id,
          productName: product.name,
          unitPrice: product.price,
          quantity: 1,
        ),
      );
    }

    context.pop();
  }
}
