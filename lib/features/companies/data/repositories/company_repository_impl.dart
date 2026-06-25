import 'package:fpdart/fpdart.dart';
import 'package:stockflow/core/error/failures.dart';
import 'package:stockflow/core/error/exceptions.dart';
import 'package:stockflow/features/companies/data/datasources/company_remote_data_source.dart';
import 'package:stockflow/features/companies/domain/entities/company.dart';
import 'package:stockflow/features/companies/domain/entities/company_member.dart';
import 'package:stockflow/features/companies/domain/entities/join_request.dart';
import 'package:stockflow/features/companies/domain/repositories/company_repository.dart';

class CompanyRepositoryImpl implements CompanyRepository {
  final CompanyRemoteDataSource _dataSource;

  CompanyRepositoryImpl(this._dataSource);

  @override
  Future<Either<Failure, List<Company>>> getUserCompanies() async {
    try {
      final models = await _dataSource.getUserCompanies();
      return Right(models);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, Company>> createCompany(
    String name, {
    String? address,
    String? phone,
  }) async {
    try {
      final model = await _dataSource.createCompany(
        name,
        address: address,
        phone: phone,
      );
      return Right(model);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, Company>> getCompany(String companyId) async {
    try {
      final model = await _dataSource.getCompany(companyId);
      return Right(model);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, void>> updateCompany(
    String companyId, {
    String? name,
    String? address,
    String? phone,
    String? logoUrl,
  }) async {
    try {
      await _dataSource.updateCompany(
        companyId,
        name: name,
        address: address,
        phone: phone,
        logoUrl: logoUrl,
      );
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, List<CompanyMember>>> getCompanyMembers(
    String companyId,
  ) async {
    try {
      final models = await _dataSource.getCompanyMembers(companyId);
      return Right(models);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, CompanyMember>> inviteMember(
    String companyId,
    String userEmail,
  ) async {
    try {
      final model = await _dataSource.inviteMember(companyId, userEmail);
      return Right(model);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, void>> updateMemberPermissions(
    String companyId,
    String memberId,
    Map<String, bool> permissions,
  ) async {
    try {
      await _dataSource.updateMemberPermissions(companyId, memberId, permissions);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, void>> removeMember(
    String companyId,
    String memberId,
  ) async {
    try {
      await _dataSource.removeMember(companyId, memberId);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, Company>> createCompanyFull({
    required String name,
    String? businessType,
    String? phone,
    String? address,
    String? logoUrl,
  }) async {
    try {
      final model = await _dataSource.createCompanyFull(
        name: name,
        businessType: businessType,
        phone: phone,
        address: address,
        logoUrl: logoUrl,
      );
      return Right(model);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> joinCompanyByCode(
    String inviteCode,
  ) async {
    try {
      final result = await _dataSource.joinCompanyByCode(inviteCode);
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, List<JoinRequest>>> getJoinRequests(
    String companyId, {
    String status = 'pending',
  }) async {
    try {
      final models = await _dataSource.getJoinRequests(
        companyId,
        status: status,
      );
      return Right(models);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, String>> approveJoinRequest(String requestId) async {
    try {
      final memberId = await _dataSource.approveJoinRequest(requestId);
      return Right(memberId);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, void>> rejectJoinRequest(String requestId) async {
    try {
      await _dataSource.rejectJoinRequest(requestId);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> getJoinRequestStatus(
    String requestId,
  ) async {
    try {
      final result = await _dataSource.getJoinRequestStatus(requestId);
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }
}
