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
    required String companyId,
    String? query,
    int? limit,
    int? offset,
    String? sortColumn,
    bool ascending = false,
  }) {
    return dataSource
        .listProducts(
          companyId: companyId,
          query: query,
          limit: limit,
          offset: offset,
          sortColumn: sortColumn,
          ascending: ascending,
        )
        .map((models) => models.map((m) => m.toEntity()).toList());
  }

  @override
  TaskEither<String, Product> getProduct(String id, String companyId) {
    return dataSource.getProduct(id, companyId).map((model) => model.toEntity());
  }

  @override
  TaskEither<String, Product> createProduct(ProductInput input, String userId, String companyId) {
    final validationError = input.validate();
    if (validationError != null) {
      return TaskEither.left(validationError);
    }
    return dataSource
        .createProduct(input, userId, companyId)
        .map((model) => model.toEntity());
  }

  @override
  TaskEither<String, Product> updateProduct(
    String id,
    ProductInput input,
    String userId,
    String companyId,
  ) {
    final validationError = input.validate();
    if (validationError != null) {
      return TaskEither.left(validationError);
    }
    return dataSource.updateProduct(id, input, userId, companyId).map((model) => model.toEntity());
  }

  @override
  TaskEither<String, void> deleteProduct(String id, String companyId) {
    return dataSource.deleteProduct(id, companyId);
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
    required String companyId,
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
          companyId: companyId,
        )
        .flatMap((_) {
          return dataSource
              .getProduct(productId, companyId)
              .map((model) => model.toEntity());
        });
  }

  @override
  TaskEither<String, List<InventoryMovement>> getMovements(String productId, String companyId) {
    return dataSource
        .getMovements(productId, companyId)
        .map((models) => models.map((m) => m.toEntity()).toList());
  }
}
