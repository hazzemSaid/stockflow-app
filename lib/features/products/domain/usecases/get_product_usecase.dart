import 'package:fpdart/fpdart.dart';
import '../entities/product.dart';
import '../repositories/product_repository.dart';

class GetProductUseCase {
  final ProductRepository repository;

  GetProductUseCase(this.repository);

  TaskEither<String, Product> call(String id) {
    return repository.getProduct(id);
  }
}
