import 'package:fpdart/fpdart.dart';
import 'package:stockflow/core/error/failures.dart';
import 'package:stockflow/features/companies/domain/repositories/company_repository.dart';

class DemoteOwnerToMemberUseCase {
  final CompanyRepository _repository;
  DemoteOwnerToMemberUseCase(this._repository);
  Future<Either<Failure, void>> call(String memberId, Map<String, dynamic> permissions) =>
      _repository.demoteOwnerToMember(memberId, permissions);
}
