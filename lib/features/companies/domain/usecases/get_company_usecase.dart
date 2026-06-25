import 'package:fpdart/fpdart.dart';
import 'package:stockflow/core/error/failures.dart';
import 'package:stockflow/features/companies/domain/entities/company.dart';
import 'package:stockflow/features/companies/domain/repositories/company_repository.dart';

class GetCompanyUseCase {
  final CompanyRepository _repository;

  GetCompanyUseCase(this._repository);

  Future<Either<Failure, Company>> call(String companyId) {
    return _repository.getCompany(companyId);
  }
}
