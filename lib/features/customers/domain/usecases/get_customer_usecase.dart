import 'package:fpdart/fpdart.dart';
import 'package:makhzanflow/core/error/failures.dart';
import '../entities/customer.dart';
import '../repositories/customer_repository.dart';

class GetCustomerUseCase {
  final CustomerRepository repository;

  GetCustomerUseCase(this.repository);

  Future<Either<Failure, Customer>> call(String id, String companyId) {
    return repository.getCustomer(id, companyId);
  }
}
