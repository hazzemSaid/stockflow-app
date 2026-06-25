import 'package:fpdart/fpdart.dart';
import 'package:stockflow/core/error/failures.dart';
import 'package:stockflow/features/companies/domain/entities/company_member.dart';
import 'package:stockflow/features/companies/domain/repositories/company_repository.dart';

class GetCompanyMembersUseCase {
  final CompanyRepository _repository;

  GetCompanyMembersUseCase(this._repository);

  Future<Either<Failure, List<CompanyMember>>> call(String companyId) {
    return _repository.getCompanyMembers(companyId);
  }
}
