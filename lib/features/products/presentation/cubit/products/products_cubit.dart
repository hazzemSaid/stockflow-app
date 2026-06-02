import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/usecases/get_products_usecase.dart';
import 'products_state.dart';

export 'products_state.dart';

const int _pageSize = 20;

class ProductsCubit extends Cubit<ProductsState> {
  final GetProductsUseCase _getProductsUseCase;
  Timer? _debounce;
  int _currentPage = 0;

  ProductsCubit({required GetProductsUseCase getProductsUseCase})
    : _getProductsUseCase = getProductsUseCase,
      super(const ProductsState());

  Future<void> loadProducts() async {
    _currentPage = 0;
    emit(state.copyWith(status: ProductsStatus.loading, isLoadingMore: false));

    final result = await _getProductsUseCase(
      query: state.filter.hasQuery ? state.filter.query : null,
      limit: _pageSize,
      offset: 0,
      sortColumn: state.filter.sortColumn,
      ascending: state.filter.ascending,
    ).run();

    result.fold(
      (error) {
        emit(state.copyWith(status: ProductsStatus.error, errorMessage: error));
      },
      (products) {
        emit(
          state.copyWith(
            status: products.isEmpty
                ? ProductsStatus.empty
                : ProductsStatus.success,
            products: products,
            totalCount: products.length,
            hasMore: products.length == _pageSize,
          ),
        );
      },
    );
  }

  Future<void> loadMore() async {
    if (state.isLoadingMore || !state.hasMore) return;
    emit(state.copyWith(isLoadingMore: true));

    final nextPage = _currentPage + 1;
    final nextOffset = nextPage * _pageSize;

    final result = await _getProductsUseCase(
      query: state.filter.hasQuery ? state.filter.query : null,
      limit: _pageSize,
      offset: nextOffset,
      sortColumn: state.filter.sortColumn,
      ascending: state.filter.ascending,
    ).run();

    result.fold(
      (_) {
        emit(state.copyWith(isLoadingMore: false));
      },
      (newProducts) {
        _currentPage = nextPage;
        final allProducts = [...state.products, ...newProducts];
        emit(
          state.copyWith(
            status: ProductsStatus.success,
            products: allProducts,
            totalCount: allProducts.length,
            hasMore: newProducts.length == _pageSize,
            isLoadingMore: false,
          ),
        );
      },
    );
  }

  void updateSearchQuery(String query) {
    emit(state.copyWith(filter: state.filter.copyWith(query: query)));
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 400), () {
      loadProducts();
    });
  }

  Future<void> refresh() async {
    await loadProducts();
  }

  @override
  Future<void> close() {
    _debounce?.cancel();
    return super.close();
  }
}
