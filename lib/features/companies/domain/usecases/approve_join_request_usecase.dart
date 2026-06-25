import 'package:fpdart/fpdart.dart';
import 'package:stockflow/core/error/failures.dart';
import 'package:stockflow/features/companies/domain/repositories/company_repository.dart';

class ApproveJoinRequestUseCase {
  final CompanyRepository _repository;

  ApproveJoinRequestUseCase(this._repository);

  Future<Either<Failure, String>> call(String requestId) {
    return _repository.approveJoinRequest(requestId);
  }
}
