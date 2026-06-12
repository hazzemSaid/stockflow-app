import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stockflow/core/error/failures.dart' show ServerFailure;
import 'package:stockflow/features/products/domain/entities/product.dart';
import 'package:stockflow/features/products/domain/usecases/get_products_usecase.dart';
import 'product_picker_state.dart';

export 'product_picker_state.dart';

class ProductPickerCubit extends Cubit<ProductPickerState> {
  final GetProductsUseCase _getProductsUseCase;
  String _searchQuery = '';
  String _selectedCategory = '';

  ProductPickerCubit({
    required GetProductsUseCase getProductsUseCase,
  }) : _getProductsUseCase = getProductsUseCase,
       super(ProductPickerInitial());

  Future<void> loadProducts() async {
    emit(ProductPickerLoading());

    final result = await _getProductsUseCase(
      query: _searchQuery.isNotEmpty ? _searchQuery : null,
      limit: 50,
      offset: 0,
    ).run();

    result.fold(
      (error) => emit(ProductPickerError(failure: ServerFailure(error))),
      (products) => emit(
        ProductPickerLoaded(
          products: products,
          selectedProductIds: state is ProductPickerLoaded
              ? (state as ProductPickerLoaded).selectedProductIds
              : {},
          searchQuery: _searchQuery,
          selectedCategory: _selectedCategory,
        ),
      ),
    );
  }

  void search(String query) {
    _searchQuery = query;
    loadProducts();
  }

  void selectCategory(String category) {
    _selectedCategory = _selectedCategory == category ? '' : category;
    if (_selectedCategory.isNotEmpty) {
      _searchQuery = _selectedCategory;
    } else {
      _searchQuery = '';
    }
    loadProducts();
  }

  void toggleProduct(String productId) {
    if (state is! ProductPickerLoaded) return;
    final loaded = state as ProductPickerLoaded;
    final selected = Set<String>.from(loaded.selectedProductIds);
    if (selected.contains(productId)) {
      selected.remove(productId);
    } else {
      selected.add(productId);
    }
    emit(loaded.copyWith(selectedProductIds: selected));
  }

  List<Product> getSelectedProducts() {
    if (state is! ProductPickerLoaded) return [];
    final loaded = state as ProductPickerLoaded;
    return loaded.products
        .where((p) => loaded.selectedProductIds.contains(p.id))
        .toList();
  }
}
