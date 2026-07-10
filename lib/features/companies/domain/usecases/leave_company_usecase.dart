import 'package:fpdart/fpdart.dart';
import 'package:stockflow/core/error/failures.dart';
import 'package:stockflow/features/companies/domain/repositories/company_repository.dart';

class LeaveCompanyUseCase {
  final CompanyRepository _repository;
  LeaveCompanyUseCase(this._repository);
  Future<Either<Failure, void>> call() => _repository.leaveCompany();
}
