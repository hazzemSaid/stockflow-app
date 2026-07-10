import 'package:fpdart/fpdart.dart';
import 'package:stockflow/core/error/failures.dart';
import 'package:stockflow/features/companies/domain/repositories/company_repository.dart';

class GetCompanyJoinCodeUseCase {
  final CompanyRepository _repository;
  GetCompanyJoinCodeUseCase(this._repository);
  Future<Either<Failure, String>> call() => _repository.getCompanyJoinCode();
}
