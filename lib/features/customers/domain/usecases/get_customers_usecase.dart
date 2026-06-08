import 'package:fpdart/fpdart.dart';
import 'package:stockflow/core/error/failures.dart';
import '../entities/customer.dart';
import '../repositories/customer_repository.dart';

class GetCustomersUseCase {
  final CustomerRepository repository;

  GetCustomersUseCase(this.repository);

  Future<Either<Failure, List<Customer>>> call({
    String? query,
    int? limit,
    int? offset,
  }) {
    return repository.listCustomers(
      query: query,
      limit: limit,
      offset: offset,
    );
  }
}
