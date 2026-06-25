import 'package:fpdart/fpdart.dart';
import 'package:stockflow/core/error/failures.dart';
import 'package:stockflow/features/companies/domain/entities/company.dart';
import 'package:stockflow/features/companies/domain/repositories/company_repository.dart';

class GetUserCompaniesUseCase {
  final CompanyRepository _repository;

  GetUserCompaniesUseCase(this._repository);

  Future<Either<Failure, List<Company>>> call() {
    return _repository.getUserCompanies();
  }
}
