import 'package:fpdart/fpdart.dart';
import 'package:makhzanflow/core/error/failures.dart';
import 'package:makhzanflow/features/companies/domain/repositories/company_repository.dart';

class UpdateMemberPermissionsUseCase {
  final CompanyRepository _repository;

  UpdateMemberPermissionsUseCase(this._repository);

  Future<Either<Failure, void>> call(
    String companyId,
    String memberId,
    Map<String, dynamic> permissions,
  ) {
    return _repository.updateMemberPermissions(companyId, memberId, permissions);
  }
}
