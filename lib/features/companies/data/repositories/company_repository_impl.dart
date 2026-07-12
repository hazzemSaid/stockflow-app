import 'package:fpdart/fpdart.dart';
import 'package:makhzanflow/core/error/failures.dart';
import 'package:makhzanflow/core/error/exceptions.dart';
import 'package:makhzanflow/features/companies/data/datasources/company_remote_data_source.dart';
import 'package:makhzanflow/features/companies/domain/entities/company.dart';
import 'package:makhzanflow/features/companies/domain/entities/company_member.dart';
import 'package:makhzanflow/features/companies/domain/entities/join_request.dart';
import 'package:makhzanflow/features/companies/domain/repositories/company_repository.dart';

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
    Map<String, dynamic> permissions,
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

  // ============ New RPC methods ============

  @override
  Future<Either<Failure, void>> cancelJoinRequest(String requestId) async {
    try {
      await _dataSource.cancelJoinRequest(requestId);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, String>> getCompanyJoinCode() async {
    try {
      final code = await _dataSource.getCompanyJoinCode();
      return Right(code);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, String>> regenerateCompanyJoinCode() async {
    try {
      final code = await _dataSource.regenerateCompanyJoinCode();
      return Right(code);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, void>> deactivateMember(String memberId) async {
    try {
      await _dataSource.deactivateMember(memberId);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, void>> reactivateMember(String memberId) async {
    try {
      await _dataSource.reactivateMember(memberId);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, void>> removeCompanyMemberRpc(String memberId) async {
    try {
      await _dataSource.removeCompanyMemberRpc(memberId);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, void>> promoteMemberToOwner(String memberId) async {
    try {
      await _dataSource.promoteMemberToOwner(memberId);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, void>> demoteOwnerToMember(String memberId, Map<String, dynamic> permissions) async {
    try {
      await _dataSource.demoteOwnerToMember(memberId, permissions);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> getMemberPermissions(String memberId) async {
    try {
      final permissions = await _dataSource.getMemberPermissions(memberId);
      return Right(permissions);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, void>> leaveCompany() async {
    try {
      await _dataSource.leaveCompany();
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, void>> deleteCompany(String companyId) async {
    try {
      await _dataSource.deleteCompany(companyId);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }
}
