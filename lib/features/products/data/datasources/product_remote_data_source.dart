import 'package:fpdart/fpdart.dart';
import '../../domain/entities/product_input.dart';
import '../models/product_model.dart';
import '../models/inventory_movement_model.dart';

abstract class ProductRemoteDataSource {
  TaskEither<String, List<ProductModel>> listProducts({
    required String companyId,
    String? query,
    int? limit,
    int? offset,
    String? sortColumn,
    bool ascending = false,
  });

  TaskEither<String, ProductModel> getProduct(
    String id,
    String companyId,
  );

  TaskEither<String, ProductModel> createProduct(
    ProductInput input,
    String userId,
    String companyId,
  );

  TaskEither<String, ProductModel> updateProduct(
    String id,
    ProductInput input,
    String userId,
    String companyId,
  );

  TaskEither<String, void> deleteProduct(
    String id,
    String companyId,
  );

  TaskEither<String, String> uploadImage(String filePath, String productId);

  TaskEither<String, Map<String, dynamic>> updateQuantityTransaction({
    required String productId,
    required int newQuantity,
    required String type,
    required int delta,
    String? note,
    required String userId,
    required String companyId,
  });

  TaskEither<String, List<InventoryMovementModel>> getMovements(
    String productId,
    String companyId,
  );
}
