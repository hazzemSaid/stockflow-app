import 'package:fpdart/fpdart.dart';
import 'package:makhzanflow/core/error/failures.dart';
import '../entities/customer.dart';
import '../repositories/customer_repository.dart';

class GetCustomersUseCase {
  final CustomerRepository repository;

  GetCustomersUseCase(this.repository);

  Future<Either<Failure, List<Customer>>> call({
    String? query,
    String? filter,
    int? limit,
    int? offset,
    required String companyId,
  }) {
    return repository.listCustomers(
      query: query,
      filter: filter,
      limit: limit,
      offset: offset,
      companyId: companyId,
    );
  }
}
