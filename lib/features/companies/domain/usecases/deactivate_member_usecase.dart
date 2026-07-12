import 'package:fpdart/fpdart.dart';
import 'package:makhzanflow/core/error/failures.dart';
import 'package:makhzanflow/features/companies/domain/repositories/company_repository.dart';

class DeactivateMemberUseCase {
  final CompanyRepository _repository;
  DeactivateMemberUseCase(this._repository);
  Future<Either<Failure, void>> call(String memberId) => _repository.deactivateMember(memberId);
}
