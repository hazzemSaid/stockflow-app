import 'package:fpdart/fpdart.dart';
import '../repositories/product_repository.dart';

class UploadProductImageUseCase {
  final ProductRepository repository;

  UploadProductImageUseCase(this.repository);

  TaskEither<String, String> call(String filePath) {
    return repository.uploadProductImage(filePath);
  }
}
