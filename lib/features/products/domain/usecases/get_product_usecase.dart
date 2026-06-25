import 'package:fpdart/fpdart.dart';
import '../entities/product.dart';
import '../repositories/product_repository.dart';

class GetProductUseCase {
  final ProductRepository repository;

  GetProductUseCase(this.repository);

  TaskEither<String, Product> call(String id, String companyId) {
    return repository.getProduct(id, companyId);
  }
}
