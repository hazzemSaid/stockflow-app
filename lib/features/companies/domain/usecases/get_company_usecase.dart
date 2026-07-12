import 'package:fpdart/fpdart.dart';
import 'package:makhzanflow/core/error/failures.dart';
import 'package:makhzanflow/features/companies/domain/entities/company.dart';
import 'package:makhzanflow/features/companies/domain/repositories/company_repository.dart';

class GetCompanyUseCase {
  final CompanyRepository _repository;

  GetCompanyUseCase(this._repository);

  Future<Either<Failure, Company>> call(String companyId) {
    return _repository.getCompany(companyId);
  }
}
