import 'package:fpdart/fpdart.dart';
import 'package:makhzanflow/core/error/failures.dart';
import 'package:makhzanflow/features/companies/domain/repositories/company_repository.dart';

class UpdateCompanyUseCase {
  final CompanyRepository _repository;

  UpdateCompanyUseCase(this._repository);

  Future<Either<Failure, void>> call(String companyId, {String? name, String? address, String? phone, String? logoUrl}) {
    return _repository.updateCompany(companyId, name: name, address: address, phone: phone, logoUrl: logoUrl);
  }
}
