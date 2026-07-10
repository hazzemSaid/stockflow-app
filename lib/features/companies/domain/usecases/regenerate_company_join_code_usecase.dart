import 'package:fpdart/fpdart.dart';
import 'package:stockflow/core/error/failures.dart';
import 'package:stockflow/features/companies/domain/repositories/company_repository.dart';

class RegenerateCompanyJoinCodeUseCase {
  final CompanyRepository _repository;
  RegenerateCompanyJoinCodeUseCase(this._repository);
  Future<Either<Failure, String>> call() => _repository.regenerateCompanyJoinCode();
}
