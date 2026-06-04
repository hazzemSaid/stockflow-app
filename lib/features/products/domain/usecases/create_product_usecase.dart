import 'package:fpdart/fpdart.dart';
import '../entities/product.dart';
import '../entities/product_input.dart';
import '../repositories/product_repository.dart';

class CreateProductUseCase {
  final ProductRepository repository;

  CreateProductUseCase(this.repository);

  TaskEither<String, Product> call(ProductInput input, String userId) {
    return repository.createProduct(input, userId);
  }
}
