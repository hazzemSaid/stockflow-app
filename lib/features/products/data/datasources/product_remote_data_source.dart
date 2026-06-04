import 'package:fpdart/fpdart.dart';
import '../../domain/entities/product_input.dart';
import '../models/product_model.dart';
import '../models/inventory_movement_model.dart';

abstract class ProductRemoteDataSource {
  TaskEither<String, List<ProductModel>> listProducts({
    String? query,
    int? limit,
    int? offset,
    String? sortColumn,
    bool ascending = false,
  });

  TaskEither<String, ProductModel> getProduct(String id);

  TaskEither<String, ProductModel> createProduct(
    ProductInput input,
    String userId,
  );

  TaskEither<String, ProductModel> updateProduct(
    String id,
    ProductInput input,
    String userId,
  );

  TaskEither<String, void> deleteProduct(String id);

  TaskEither<String, String> uploadImage(String filePath);

  TaskEither<String, Map<String, dynamic>> updateQuantityTransaction({
    required String productId,
    required int newQuantity,
    required String type,
    required int delta,
    String? note,
    required String userId,
  });

  TaskEither<String, List<InventoryMovementModel>> getMovements(
    String productId,
  );
}
