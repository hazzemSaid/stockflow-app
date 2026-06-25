import 'package:fpdart/fpdart.dart';
import '../repositories/product_repository.dart';

class DeleteProductUseCase {
  final ProductRepository repository;

  DeleteProductUseCase(this.repository);

  TaskEither<String, void> call(String id, String companyId) {
    return repository.deleteProduct(id, companyId);
  }
}
