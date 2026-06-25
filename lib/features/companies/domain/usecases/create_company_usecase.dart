import 'package:fpdart/fpdart.dart';
import 'package:stockflow/core/error/failures.dart';
import 'package:stockflow/features/companies/domain/entities/company.dart';
import 'package:stockflow/features/companies/domain/repositories/company_repository.dart';

class CreateCompanyUseCase {
  final CompanyRepository _repository;

  CreateCompanyUseCase(this._repository);

  Future<Either<Failure, Company>> call(String name, {String? address, String? phone}) {
    return _repository.createCompany(name, address: address, phone: phone);
  }
}
