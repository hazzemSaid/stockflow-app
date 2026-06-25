import 'package:fpdart/fpdart.dart';
import 'package:stockflow/core/error/failures.dart';
import 'package:stockflow/features/companies/domain/repositories/company_repository.dart';

class RemoveMemberUseCase {
  final CompanyRepository _repository;

  RemoveMemberUseCase(this._repository);

  Future<Either<Failure, void>> call(String companyId, String memberId) {
    return _repository.removeMember(companyId, memberId);
  }
}
