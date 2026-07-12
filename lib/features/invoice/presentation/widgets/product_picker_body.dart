import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:makhzanflow/core/constants/app_colors.dart';
import 'package:makhzanflow/core/constants/app_sizes.dart';
import 'package:makhzanflow/core/constants/app_strings.dart';
import 'package:makhzanflow/features/invoice/presentation/cubit/product_picker/product_picker_cubit.dart';
import 'package:makhzanflow/features/invoice/presentation/widgets/product_tile.dart';
import 'package:makhzanflow/features/invoice/presentation/widgets/product_picker_loading.dart';
import 'package:makhzanflow/features/invoice/presentation/widgets/product_picker_error.dart';
import 'package:makhzanflow/features/invoice/presentation/widgets/product_picker_empty.dart';

class ProductPickerBody extends StatefulWidget {
  const ProductPickerBody({super.key});

  @override
  State<ProductPickerBody> createState() => _ProductPickerBodyState();
}

class _ProductPickerBodyState extends State<ProductPickerBody> {
  late TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ProductPickerCubit>().loadProducts();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: AppSizes.spacingMedium),
          child: TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: AppStrings.searchProduct,
              prefixIcon: Icon(Icons.search, color: AppColors.textSecondary),
              filled: true,
              fillColor: AppColors.searchBg,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppSizes.radiusSmall),
                borderSide: BorderSide.none,
              ),
              contentPadding: EdgeInsets.symmetric(
                vertical: AppSizes.spacingSmall,
              ),
            ),
            onChanged: (value) {
              context.read<ProductPickerCubit>().search(value);
            },
          ),
        ),
        SizedBox(height: AppSizes.spacingSmall),
        Expanded(
          child: BlocBuilder<ProductPickerCubit, ProductPickerState>(
            builder: (context, state) {
              if (state is ProductPickerLoading) {
                return const ProductPickerLoadingState();
              }
              if (state is ProductPickerError) {
                return ProductPickerErrorState(
                  message: state.failure.message,
                );
              }
              if (state is ProductPickerLoaded) {
                if (state.products.isEmpty) {
                  return const ProductPickerEmptyState();
                }
                return ListView.separated(
                  padding: EdgeInsets.all(AppSizes.spacingMedium),
                  itemCount: state.products.length,
                  separatorBuilder: (_, __) =>
                      SizedBox(height: AppSizes.spacingSmall),
                  itemBuilder: (context, index) {
                    final product = state.products[index];
                    final isSelected = state.selectedProductIds.contains(
                      product.id,
                    );
                    return ProductTile(
                      product: product,
                      isSelected: isSelected,
                      onToggle: () {
                        context.read<ProductPickerCubit>().toggleProduct(
                          product.id,
                        );
                      },
                    );
                  },
                );
              }
              return const SizedBox.shrink();
            },
          ),
        ),
      ],
    );
  }
}
