import 'package:fpdart/fpdart.dart';
import '../repositories/product_repository.dart';

class DeleteProductUseCase {
  final ProductRepository repository;

  DeleteProductUseCase(this.repository);

  TaskEither<String, void> call(String id) {
    return repository.deleteProduct(id);
  }
}
