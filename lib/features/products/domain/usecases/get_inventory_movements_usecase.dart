import 'package:fpdart/fpdart.dart';
import '../entities/inventory_movement.dart';
import '../repositories/product_repository.dart';

class GetInventoryMovementsUseCase {
  final ProductRepository repository;

  GetInventoryMovementsUseCase(this.repository);

  TaskEither<String, List<InventoryMovement>> call(String productId, String companyId) {
    return repository.getMovements(productId, companyId);
  }
}
