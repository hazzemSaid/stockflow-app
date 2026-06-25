import 'package:fpdart/fpdart.dart';
import '../entities/product.dart';
import '../repositories/product_repository.dart';

class UpdateProductQuantityUseCase {
  final ProductRepository repository;

  UpdateProductQuantityUseCase(this.repository);

  TaskEither<String, Product> call({
    required String productId,
    required int delta,
    String? note,
    required String userId,
    required String companyId,
  }) {
    return repository.updateQuantity(
      productId: productId,
      delta: delta,
      note: note,
      userId: userId,
      companyId: companyId,
    );
  }
}
