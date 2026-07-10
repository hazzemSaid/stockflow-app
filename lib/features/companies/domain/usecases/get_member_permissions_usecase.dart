import 'package:fpdart/fpdart.dart';
import 'package:stockflow/core/error/failures.dart';
import 'package:stockflow/features/companies/domain/repositories/company_repository.dart';

class GetMemberPermissionsUseCase {
  final CompanyRepository _repository;
  GetMemberPermissionsUseCase(this._repository);
  Future<Either<Failure, Map<String, dynamic>>> call(String memberId) => _repository.getMemberPermissions(memberId);
}
