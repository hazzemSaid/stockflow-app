import 'package:fpdart/fpdart.dart';
import 'package:makhzanflow/core/error/failures.dart';
import 'package:makhzanflow/features/companies/domain/repositories/company_repository.dart';

class ReactivateMemberUseCase {
  final CompanyRepository _repository;
  ReactivateMemberUseCase(this._repository);
  Future<Either<Failure, void>> call(String memberId) => _repository.reactivateMember(memberId);
}
