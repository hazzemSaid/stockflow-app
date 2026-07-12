import 'package:fpdart/fpdart.dart';
import 'package:makhzanflow/core/error/failures.dart';
import 'package:makhzanflow/features/companies/domain/repositories/company_repository.dart';

class CheckJoinRequestStatusUseCase {
  final CompanyRepository _repository;

  CheckJoinRequestStatusUseCase(this._repository);

  Future<Either<Failure, Map<String, dynamic>>> call(String requestId) {
    return _repository.getJoinRequestStatus(requestId);
  }
}
