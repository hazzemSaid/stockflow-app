import 'package:fpdart/fpdart.dart';
import 'package:stockflow/core/error/failures.dart';
import 'package:stockflow/features/companies/domain/entities/company_member.dart';
import 'package:stockflow/features/companies/domain/repositories/company_repository.dart';

class InviteMemberUseCase {
  final CompanyRepository _repository;

  InviteMemberUseCase(this._repository);

  Future<Either<Failure, CompanyMember>> call(String companyId, String userEmail) {
    return _repository.inviteMember(companyId, userEmail);
  }
}
