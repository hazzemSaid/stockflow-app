import 'package:fpdart/fpdart.dart';
import 'package:makhzanflow/core/error/failures.dart';
import 'package:makhzanflow/features/companies/domain/entities/company.dart';
import 'package:makhzanflow/features/companies/domain/repositories/company_repository.dart';

class GetUserCompaniesUseCase {
  final CompanyRepository _repository;

  GetUserCompaniesUseCase(this._repository);

  Future<Either<Failure, List<Company>>> call() {
    return _repository.getUserCompanies();
  }
}
