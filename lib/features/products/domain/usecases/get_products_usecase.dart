import 'package:fpdart/fpdart.dart';
import '../entities/product.dart';
import '../repositories/product_repository.dart';

class GetProductsUseCase {
  final ProductRepository repository;

  GetProductsUseCase(this.repository);

  TaskEither<String, List<Product>> call({
    String? query,
    int? limit,
    int? offset,
    String? sortColumn,
    bool ascending = false,
  }) {
    return repository.listProducts(
      query: query,
      limit: limit,
      offset: offset,
      sortColumn: sortColumn,
      ascending: ascending,
    );
  }
}
