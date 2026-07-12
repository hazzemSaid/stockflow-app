import 'package:fpdart/fpdart.dart';
import 'package:makhzanflow/core/error/failures.dart';
import 'package:makhzanflow/features/companies/domain/entities/company.dart';
import 'package:makhzanflow/features/companies/domain/repositories/company_repository.dart';

class CreateCompanyFullUseCase {
  final CompanyRepository _repository;

  CreateCompanyFullUseCase(this._repository);

  Future<Either<Failure, Company>> call({
    required String name,
    String? businessType,
    String? phone,
    String? address,
    String? logoUrl,
  }) {
    return _repository.createCompanyFull(
      name: name,
      businessType: businessType,
      phone: phone,
      address: address,
      logoUrl: logoUrl,
    );
  }
}
