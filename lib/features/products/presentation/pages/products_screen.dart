import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:stockflow/core/company/company_aware_state.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_routes.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/di/service_locator.dart';
import '../../../../core/permissions/permission_constants.dart';
import '../../../../core/permissions/permission_gate.dart';
import '../../../../shared/widgets/stockflow_search_field.dart';
import '../cubit/products/products_cubit.dart';
import '../widgets/product_card.dart';
import '../widgets/product_screen_header.dart';
import '../widgets/product_empty_view.dart';
import '../widgets/product_error_view.dart';
import '../widgets/product_loading_view.dart';

class ProductsScreen extends StatefulWidget {
  const ProductsScreen({super.key});

  @override
  State<ProductsScreen> createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen>
    with CompanyAwareState<ProductsScreen> {
  late final ProductsCubit _cubit;
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _cubit = sl<ProductsCubit>();
    _cubit.refresh(companyId: companyId);
    _scrollController.addListener(_onScroll);
  }

  @override
  void onCompanyChanged(String companyId) {
    _cubit.refresh(companyId: companyId);
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      _cubit.loadMore(companyId: companyId);
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    _searchController.dispose();
    _cubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _cubit,
      child: Scaffold(
        backgroundColor: AppColors.appBackground,
        body: SafeArea(
          child: RefreshIndicator(
            onRefresh: () => _cubit.refresh(companyId: companyId),
            child: CustomScrollView(
              controller: _scrollController,
              physics: const AlwaysScrollableScrollPhysics(),
              slivers: [
                SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.only(top: AppSizes.spacingMedium),
                    child: BlocBuilder<ProductsCubit, ProductsState>(
                      builder: (context, state) {
                        return ProductScreenHeader(
                          totalCount: state.totalCount,
                        );
                      },
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      vertical: AppSizes.spacingSmall,
                      horizontal: AppSizes.spacingMedium,
                    ),
                    child: StockFlowSearchField(
                      controller: _searchController,
                      hintText: AppStrings.productsSearchHint,
                      onChanged: (query) =>
                          _cubit.updateSearchQuery(query, companyId: companyId),
                      onClear: () {
                        _searchController.clear();
                        _cubit.updateSearchQuery('', companyId: companyId);
                      },
                    ),
                  ),
                ),
                BlocBuilder<ProductsCubit, ProductsState>(
                  builder: (context, state) {
                    return switch (state.status) {
                      ProductsStatus.initial || ProductsStatus.loading =>
                        const SliverFillRemaining(child: ProductLoadingView()),
                      ProductsStatus.error => SliverFillRemaining(
                        child: ProductErrorView(
                          message:
                              state.errorMessage ?? AppStrings.productLoadError,
                          onRetry: () => _cubit.loadProducts(companyId: companyId),
                        ),
                      ),
                      ProductsStatus.empty => SliverFillRemaining(
                        child: ProductEmptyView(
                          message: state.filter.hasQuery
                              ? AppStrings.productEmptySearch
                              : AppStrings.emptyProducts,
                        ),
                      ),
                      ProductsStatus.success => SliverPadding(
                        padding: EdgeInsets.symmetric(
                          horizontal: AppSizes.spacingMedium,
                        ),
                        sliver: SliverGrid(
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                crossAxisSpacing: 10.w,
                                mainAxisSpacing: 10.h,
                                childAspectRatio: 0.75,
                              ),
                          delegate: SliverChildBuilderDelegate((
                            context,
                            index,
                          ) {
                            final product = state.products[index];
                            return ProductCard(
                              product: product,
                              onTap: () => context.push(
                                AppRoutes.productDetailsPath(product.id),
                              ),
                            );
                          }, childCount: state.products.length),
                        ),
                      ),
                    };
                  },
                ),
                BlocBuilder<ProductsCubit, ProductsState>(
                  builder: (context, state) {
                    if (!state.isLoadingMore) return const SliverToBoxAdapter();
                    return SliverToBoxAdapter(
                      child: Padding(
                        padding: EdgeInsets.all(AppSizes.spacingMedium),
                        child: const Center(child: CircularProgressIndicator()),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
        floatingActionButton: PermissionGate(
          permission: PermissionKeys.productsCreate,
          child: FloatingActionButton(
            heroTag: 'products_fab',
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(32.r),
            ),
            backgroundColor: AppColors.accent,
            onPressed: () => context.push(AppRoutes.productNew),
            child: const Icon(Icons.add, color: AppColors.white),
          ),
        ),
      ),
    );
  }
}
