import 'package:makhzanflow/core/error/failures.dart';
import 'package:makhzanflow/features/products/domain/entities/product.dart';

sealed class ProductPickerState {}

class ProductPickerInitial extends ProductPickerState {}

class ProductPickerLoading extends ProductPickerState {}

class ProductPickerLoaded extends ProductPickerState {
  final List<Product> products;
  final Set<String> selectedProductIds;
  final String searchQuery;
  final String selectedCategory;

  ProductPickerLoaded({
    required this.products,
    this.selectedProductIds = const {},
    this.searchQuery = '',
    this.selectedCategory = '',
  });

  ProductPickerLoaded copyWith({
    List<Product>? products,
    Set<String>? selectedProductIds,
    String? searchQuery,
    String? selectedCategory,
  }) {
    return ProductPickerLoaded(
      products: products ?? this.products,
      selectedProductIds: selectedProductIds ?? this.selectedProductIds,
      searchQuery: searchQuery ?? this.searchQuery,
      selectedCategory: selectedCategory ?? this.selectedCategory,
    );
  }
}

class ProductPickerError extends ProductPickerState {
  final Failure failure;
  ProductPickerError({required this.failure});
}
