import 'package:equatable/equatable.dart';
import '../../../domain/entities/product.dart';
import '../../../domain/entities/inventory_movement.dart';

enum ProductDetailsStatus { initial, loading, success, error }

enum QuantityAction { set, add, subtract }

class ProductDetailsState extends Equatable {
  final ProductDetailsStatus status;
  final Product? product;
  final List<InventoryMovement> recentMovements;
  final String? errorMessage;
  final bool isDeleting;
  final bool isUpdatingQuantity;

  const ProductDetailsState({
    this.status = ProductDetailsStatus.initial,
    this.product,
    this.recentMovements = const [],
    this.errorMessage,
    this.isDeleting = false,
    this.isUpdatingQuantity = false,
  });

  ProductDetailsState copyWith({
    ProductDetailsStatus? status,
    Product? product,
    List<InventoryMovement>? recentMovements,
    String? errorMessage,
    bool? isDeleting,
    bool? isUpdatingQuantity,
  }) {
    return ProductDetailsState(
      status: status ?? this.status,
      product: product ?? this.product,
      recentMovements: recentMovements ?? this.recentMovements,
      errorMessage: errorMessage ?? this.errorMessage,
      isDeleting: isDeleting ?? this.isDeleting,
      isUpdatingQuantity: isUpdatingQuantity ?? this.isUpdatingQuantity,
    );
  }

  @override
  List<Object?> get props => [
    status,
    product,
    recentMovements,
    errorMessage,
    isDeleting,
    isUpdatingQuantity,
  ];
}
