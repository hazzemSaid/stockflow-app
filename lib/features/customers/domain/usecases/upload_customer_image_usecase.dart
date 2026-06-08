import 'package:fpdart/fpdart.dart';
import 'package:stockflow/core/error/failures.dart';
import '../repositories/customer_repository.dart';

class UploadCustomerImageUseCase {
  final CustomerRepository repository;

  UploadCustomerImageUseCase(this.repository);

  Future<Either<Failure, String>> call(String filePath) {
    return repository.uploadCustomerImage(filePath);
  }
}
