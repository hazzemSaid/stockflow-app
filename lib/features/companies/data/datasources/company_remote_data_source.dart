import 'package:stockflow/features/companies/data/models/company_member_model.dart';
import 'package:stockflow/features/companies/data/models/company_model.dart';
import 'package:stockflow/features/companies/data/models/join_request_model.dart';

abstract class CompanyRemoteDataSource {
  Future<List<CompanyModel>> getUserCompanies();
  Future<CompanyModel> createCompany(String name, {String? address, String? phone});
  Future<CompanyModel> getCompany(String companyId);
  Future<void> updateCompany(String companyId, {String? name, String? address, String? phone, String? logoUrl});
  Future<List<CompanyMemberModel>> getCompanyMembers(String companyId);
  Future<CompanyMemberModel> inviteMember(String companyId, String userEmail);
  Future<void> updateMemberPermissions(String companyId, String memberId, Map<String, bool> permissions);
  Future<void> removeMember(String companyId, String memberId);

  Future<CompanyModel> createCompanyFull({
    required String name,
    String? businessType,
    String? phone,
    String? address,
    String? logoUrl,
  });
  Future<Map<String, dynamic>> joinCompanyByCode(String inviteCode);
  Future<List<JoinRequestModel>> getJoinRequests(String companyId, {String status = 'pending'});
  Future<String> approveJoinRequest(String requestId);
  Future<void> rejectJoinRequest(String requestId);
  Future<Map<String, dynamic>> getJoinRequestStatus(String requestId);
}
