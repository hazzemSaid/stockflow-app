import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failures.dart';
import '../entities/user.dart';
import '../repositories/auth_repository.dart';

class SignUpUseCase {
  final AuthRepository _repository;

  SignUpUseCase(this._repository);

  Future<Either<Failure, UserEntity>> call(String email, String password, String name) {
    return _repository.signUp(email, password, name);
  }
}
