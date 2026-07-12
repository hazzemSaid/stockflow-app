import 'package:fpdart/fpdart.dart';
import 'package:makhzanflow/core/error/failures.dart';
import 'package:makhzanflow/features/companies/domain/repositories/company_repository.dart';

class CancelJoinRequestUseCase {
  final CompanyRepository _repository;
  CancelJoinRequestUseCase(this._repository);
  Future<Either<Failure, void>> call(String requestId) => _repository.cancelJoinRequest(requestId);
}
