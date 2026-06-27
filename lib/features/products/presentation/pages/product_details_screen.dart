import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:stockflow/core/company/company_aware_state.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/di/service_locator.dart';
import '../../../../core/widgets/app_snackbar.dart';
import '../cubit/product_details/product_details_cubit.dart';
import '../widgets/inventory_movement_list.dart';
import '../widgets/product_delete_dialog.dart';
import '../widgets/product_details_sections.dart';
import '../widgets/product_error_view.dart';
import '../widgets/product_loading_view.dart';

class ProductDetailsScreen extends StatefulWidget {
  final String productId;

  const ProductDetailsScreen({super.key, required this.productId});

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen>
    with CompanyAwareState<ProductDetailsScreen> {
  late final ProductDetailsCubit _cubit;

  @override
  void initState() {
    super.initState();
    _cubit = sl<ProductDetailsCubit>();
    _cubit.loadProduct(widget.productId, companyId);
  }

  @override
  void onCompanyChanged(String companyId) {
    _cubit.loadProduct(widget.productId, companyId);
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
        appBar: AppBar(title: const Text(AppStrings.productDetails)),
        body: BlocConsumer<ProductDetailsCubit, ProductDetailsState>(
          listener: (context, state) {
            if (state.status == ProductDetailsStatus.error &&
                state.errorMessage != null) {
              AppSnackbar.error(context, state.errorMessage!);
            }
          },
          builder: (context, state) {
            switch (state.status) {
              case ProductDetailsStatus.initial:
              case ProductDetailsStatus.loading:
                return const ProductLoadingView();
              case ProductDetailsStatus.error:
                return ProductErrorView(
                  message: state.errorMessage ?? AppStrings.productLoadError,
                  onRetry: () => _cubit.loadProduct(widget.productId, companyId),
                );
              case ProductDetailsStatus.success:
                final product = state.product!;
                return RefreshIndicator(
                  onRefresh: () => _cubit.loadProduct(widget.productId, companyId),
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: EdgeInsets.all(AppSizes.spacingMedium),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ProductDetailsImage(imageUrl: product.imageUrl),
                        SizedBox(height: AppSizes.spacingLarge),
                        ProductInfoSection(product: product),
                        SizedBox(height: AppSizes.spacingLarge),
                        ProductActionButtons(
                          onEdit: () async {
                            final updated = await context.push<bool>(
                              '/products/${product.id}/edit',
                            );
                            if (updated == true && mounted) {
                              _cubit.loadProduct(widget.productId, companyId);
                            }
                          },
                          onDelete: () => _confirmDelete(context, product.id),
                          isDeleting: state.isDeleting,
                        ),
                        InventoryMovementList(movements: state.recentMovements),
                      ],
                    ),
                  ),
                );
            }
          },
        ),
      ),
    );
  }

  Future<void> _confirmDelete(BuildContext context, String id) async {
    final confirmed = await DeleteConfirmationDialog.show(context);
    if (confirmed == true && mounted) {
      final success = await _cubit.deleteProduct(id, companyId);
      if (success && mounted) {
        AppSnackbar.success(context, AppStrings.productDeleted);
        context.pop();
      }
    }
  }
}
