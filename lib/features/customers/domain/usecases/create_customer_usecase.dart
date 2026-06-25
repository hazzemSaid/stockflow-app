import 'package:fpdart/fpdart.dart';
import 'package:stockflow/core/error/failures.dart';
import '../entities/customer.dart';
import '../repositories/customer_repository.dart';

class CreateCustomerUseCase {
  final CustomerRepository repository;

  CreateCustomerUseCase(this.repository);

  Future<Either<Failure, Customer>> call({
    required String name,
    String? nameOfficial,
    String? phone,
    String? address,
    double totalDebt = 0,
    String? imageUrl,
    required String companyId,
  }) {
    return repository.createCustomer(
      name: name,
      nameOfficial: nameOfficial,
      phone: phone,
      address: address,
      totalDebt: totalDebt,
      imageUrl: imageUrl,
      companyId: companyId,
    );
  }
}
