import 'package:fpdart/fpdart.dart';
import 'package:makhzanflow/core/error/failures.dart';
import 'package:makhzanflow/features/companies/domain/repositories/company_repository.dart';

class DeleteCompanyUseCase {
  final CompanyRepository _repository;
  DeleteCompanyUseCase(this._repository);
  Future<Either<Failure, void>> call(String companyId) => _repository.deleteCompany(companyId);
}
