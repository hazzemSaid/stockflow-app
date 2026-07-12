import 'package:fpdart/fpdart.dart';
import 'package:makhzanflow/core/error/failures.dart';
import 'package:makhzanflow/features/companies/domain/repositories/company_repository.dart';

class RemoveMemberUseCase {
  final CompanyRepository _repository;

  RemoveMemberUseCase(this._repository);

  Future<Either<Failure, void>> call(String companyId, String memberId) {
    return _repository.removeMember(companyId, memberId);
  }
}
