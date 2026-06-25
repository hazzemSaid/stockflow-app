import 'package:fpdart/fpdart.dart';
import 'package:stockflow/core/error/failures.dart';
import 'package:stockflow/features/companies/domain/entities/join_request.dart';
import 'package:stockflow/features/companies/domain/repositories/company_repository.dart';

class GetJoinRequestsUseCase {
  final CompanyRepository _repository;

  GetJoinRequestsUseCase(this._repository);

  Future<Either<Failure, List<JoinRequest>>> call(String companyId, {String status = 'pending'}) {
    return _repository.getJoinRequests(companyId, status: status);
  }
}
