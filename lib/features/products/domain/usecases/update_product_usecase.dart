import 'package:fpdart/fpdart.dart';
import '../entities/product.dart';
import '../entities/product_input.dart';
import '../repositories/product_repository.dart';

class UpdateProductUseCase {
  final ProductRepository repository;

  UpdateProductUseCase(this.repository);

  TaskEither<String, Product> call(
    String id,
    ProductInput input,
    String userId,
  ) {
    return repository.updateProduct(id, input, userId);
  }
}
