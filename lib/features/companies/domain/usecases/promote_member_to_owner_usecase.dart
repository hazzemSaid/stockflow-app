import 'package:fpdart/fpdart.dart';
import 'package:stockflow/core/error/failures.dart';
import 'package:stockflow/features/companies/domain/repositories/company_repository.dart';

class PromoteMemberToOwnerUseCase {
  final CompanyRepository _repository;
  PromoteMemberToOwnerUseCase(this._repository);
  Future<Either<Failure, void>> call(String memberId) => _repository.promoteMemberToOwner(memberId);
}
