import 'package:fpdart/fpdart.dart';
import 'package:stockflow/core/error/failures.dart';
import 'package:stockflow/features/companies/domain/repositories/company_repository.dart';

class JoinCompanyByCodeUseCase {
  final CompanyRepository _repository;

  JoinCompanyByCodeUseCase(this._repository);

  Future<Either<Failure, Map<String, dynamic>>> call(String inviteCode) {
    return _repository.joinCompanyByCode(inviteCode);
  }
}
