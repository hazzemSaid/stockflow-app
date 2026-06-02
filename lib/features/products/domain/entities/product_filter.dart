import 'package:equatable/equatable.dart';

enum ProductSortBy { name, price, quantity, expirationDate, createdAt }

class ProductFilter extends Equatable {
  final String query;
  final ProductSortBy sortBy;
  final bool ascending;

  const ProductFilter({
    this.query = '',
    this.sortBy = ProductSortBy.createdAt,
    this.ascending = false,
  });

  bool get hasQuery => query.trim().isNotEmpty;

  ProductFilter copyWith({
    String? query,
    ProductSortBy? sortBy,
    bool? ascending,
  }) {
    return ProductFilter(
      query: query ?? this.query,
      sortBy: sortBy ?? this.sortBy,
      ascending: ascending ?? this.ascending,
    );
  }

  String get sortColumn {
    return switch (sortBy) {
      ProductSortBy.name => 'name',
      ProductSortBy.price => 'price',
      ProductSortBy.quantity => 'quantity',
      ProductSortBy.expirationDate => 'expiration_date',
      ProductSortBy.createdAt => 'created_at',
    };
  }

  @override
  List<Object?> get props => [query, sortBy, ascending];
}
