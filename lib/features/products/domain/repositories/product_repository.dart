import 'package:fpdart/fpdart.dart';
import '../entities/product.dart';
import '../entities/inventory_movement.dart';
import '../entities/product_input.dart';

abstract class ProductRepository {
  TaskEither<String, List<Product>> listProducts({
    String? query,
    int? limit,
    int? offset,
    String? sortColumn,
    bool ascending = false,
  });

  TaskEither<String, Product> getProduct(String id);

  TaskEither<String, Product> createProduct(ProductInput input, String userId);

  TaskEither<String, Product> updateProduct(
    String id,
    ProductInput input,
    String userId,
  );

  TaskEither<String, void> deleteProduct(String id);

  TaskEither<String, String> uploadProductImage(String filePath);

  TaskEither<String, Product> updateQuantity({
    required String productId,
    required int delta,
    String? note,
    required String userId,
  });

  TaskEither<String, List<InventoryMovement>> getMovements(String productId);
}
