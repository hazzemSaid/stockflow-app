import 'package:fpdart/fpdart.dart';
import 'package:stockflow/core/error/failures.dart';
import 'package:stockflow/features/companies/domain/repositories/company_repository.dart';

class DeleteCompanyUseCase {
  final CompanyRepository _repository;
  DeleteCompanyUseCase(this._repository);
  Future<Either<Failure, void>> call(String companyId) => _repository.deleteCompany(companyId);
}
