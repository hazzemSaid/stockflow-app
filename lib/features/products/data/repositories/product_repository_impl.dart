import 'package:fpdart/fpdart.dart';
import '../../domain/entities/product.dart';
import '../../domain/entities/inventory_movement.dart';
import '../../domain/entities/product_input.dart';
import '../../domain/repositories/product_repository.dart';
import '../datasources/product_remote_data_source.dart';

class ProductRepositoryImpl implements ProductRepository {
  final ProductRemoteDataSource dataSource;

  ProductRepositoryImpl(this.dataSource);

  @override
  TaskEither<String, List<Product>> listProducts({
    String? query,
    int? limit,
    int? offset,
    String? sortColumn,
    bool ascending = false,
  }) {
    return dataSource
        .listProducts(
          query: query,
          limit: limit,
          offset: offset,
          sortColumn: sortColumn,
          ascending: ascending,
        )
        .map((models) => models.map((m) => m.toEntity()).toList());
  }

  @override
  TaskEither<String, Product> getProduct(String id) {
    return dataSource.getProduct(id).map((model) => model.toEntity());
  }

  @override
  TaskEither<String, Product> createProduct(ProductInput input, String userId) {
    final validationError = input.validate();
    if (validationError != null) {
      return TaskEither.left(validationError);
    }
    return dataSource
        .createProduct(input, userId)
        .map((model) => model.toEntity());
  }

  @override
  TaskEither<String, Product> updateProduct(
    String id,
    ProductInput input,
    String userId,
  ) {
    final validationError = input.validate();
    if (validationError != null) {
      return TaskEither.left(validationError);
    }
    return dataSource.updateProduct(id, input, userId).map((model) => model.toEntity());
  }

  @override
  TaskEither<String, void> deleteProduct(String id) {
    return dataSource.deleteProduct(id);
  }

  @override
  TaskEither<String, String> uploadProductImage(String filePath) {
    return dataSource.uploadImage(filePath);
  }

  @override
  TaskEither<String, Product> updateQuantity({
    required String productId,
    required int delta,
    String? note,
    required String userId,
  }) {
    final type = delta > 0 ? 'in' : 'out';
    final absDelta = delta.abs();

    return dataSource
        .updateQuantityTransaction(
          productId: productId,
          newQuantity: 0,
          type: type,
          delta: absDelta,
          note: note,
          userId: userId,
        )
        .flatMap((_) {
          return dataSource
              .getProduct(productId)
              .map((model) => model.toEntity());
        });
  }

  @override
  TaskEither<String, List<InventoryMovement>> getMovements(String productId) {
    return dataSource
        .getMovements(productId)
        .map((models) => models.map((m) => m.toEntity()).toList());
  }
}
