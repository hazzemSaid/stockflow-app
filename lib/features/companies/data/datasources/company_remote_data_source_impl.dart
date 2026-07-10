import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:stockflow/core/error/exceptions.dart';
import 'package:stockflow/features/companies/data/datasources/company_remote_data_source.dart';
import 'package:stockflow/features/companies/data/models/company_member_model.dart';
import 'package:stockflow/features/companies/data/models/company_model.dart';
import 'package:stockflow/features/companies/data/models/join_request_model.dart';

class CompanyRemoteDataSourceImpl implements CompanyRemoteDataSource {
  final SupabaseClient _client;

  CompanyRemoteDataSourceImpl(this._client);

  Future<T> _rpc<T>(String name, {Map<String, dynamic>? params}) async {
    try {
      return await _client.rpc(name, params: params) as T;
    } on PostgrestException catch (e) {
      throw ServerException(e.message);
    }
  }

  @override
  Future<List<CompanyModel>> getUserCompanies() async {
    final response = await _rpc<List>('get_user_companies');
    return response.map((e) => CompanyModel.fromJson(e as Map<String, dynamic>)).toList();
  }

  @override
  Future<CompanyModel> createCompany(String name, {String? address, String? phone}) async {
    final params = <String, dynamic>{'p_name': name};
    if (address != null) params['p_address'] = address;
    if (phone != null) params['p_phone'] = phone;
    final companyId = await _rpc<dynamic>('create_company', params: params);
    return getCompany(companyId.toString());
  }

  @override
  Future<CompanyModel> getCompany(String companyId) async {
    try {
      final response = await _client
          .from('companies')
          .select()
          .eq('id', companyId)
          .maybeSingle();
      if (response == null) {
        throw ServerException('الشركة غير موجودة');
      }
      return CompanyModel.fromJson(response);
    } on PostgrestException catch (e) {
      throw ServerException(e.message);
    }
  }

  @override
  Future<void> updateCompany(String companyId, {String? name, String? address, String? phone, String? logoUrl}) async {
    await _rpc<void>('update_company_full', params: {
      'p_company_id': companyId,
      if (name != null) 'p_name': name,
      if (address != null) 'p_address': address,
      if (phone != null) 'p_phone': phone,
      if (logoUrl != null) 'p_logo_url': logoUrl,
    });
  }

  @override
  Future<List<CompanyMemberModel>> getCompanyMembers(String companyId) async {
    final response = await _rpc<List>('get_company_members', params: {
      'p_company_id': companyId,
    });
    return response.map((e) => CompanyMemberModel.fromJson(e as Map<String, dynamic>)).toList();
  }

  @override
  Future<CompanyMemberModel> inviteMember(String companyId, String userEmail) async {
    final memberId = await _rpc<dynamic>('invite_company_member', params: {
      'p_user_email': userEmail,
    });
    final members = await getCompanyMembers(companyId);
    return members.firstWhere((m) => m.id == memberId.toString());
  }

  @override
  Future<void> updateMemberPermissions(String companyId, String memberId, Map<String, dynamic> permissions) async {
    await _rpc<void>('update_member_permissions', params: {
      'p_member_id': memberId,
      'p_permissions': permissions,
    });
  }

  @override
  Future<void> removeMember(String companyId, String memberId) async {
    try {
      await _client
          .from('company_members')
          .delete()
          .eq('id', memberId)
          .eq('company_id', companyId);
    } on PostgrestException catch (e) {
      throw ServerException(e.message);
    }
  }

  @override
  Future<CompanyModel> createCompanyFull({
    required String name,
    String? businessType,
    String? phone,
    String? address,
    String? logoUrl,
  }) async {
    final params = <String, dynamic>{'p_name': name};
    if (businessType != null) params['p_business_type'] = businessType;
    if (phone != null) params['p_phone'] = phone;
    if (address != null) params['p_address'] = address;
    if (logoUrl != null) params['p_logo_url'] = logoUrl;
    final response = await _rpc<Map<String, dynamic>>('create_company_full', params: params);
    return CompanyModel.fromJson(response);
  }

  @override
  Future<Map<String, dynamic>> joinCompanyByCode(String inviteCode) async {
    final response = await _rpc<Map<String, dynamic>>('join_company_by_code', params: {
      'p_invite_code': inviteCode,
    });
    return response;
  }

  @override
  Future<List<JoinRequestModel>> getJoinRequests(String companyId, {String status = 'pending'}) async {
    final response = await _rpc<List>('get_join_requests', params: {
      'p_company_id': companyId,
      'p_status': status,
    });
    return response.map((e) {
      final row = Map<String, dynamic>.from(e as Map);
      row.putIfAbsent('company_id', () => companyId);
      return JoinRequestModel.fromJson(row);
    }).toList();
  }

  @override
  Future<String> approveJoinRequest(String requestId) async {
    final memberId = await _rpc<dynamic>('approve_join_request', params: {
      'p_request_id': requestId,
    });
    return memberId.toString();
  }

  @override
  Future<void> rejectJoinRequest(String requestId) async {
    await _rpc<void>('reject_join_request', params: {
      'p_request_id': requestId,
    });
  }

  @override
  Future<Map<String, dynamic>> getJoinRequestStatus(String requestId) async {
    final response = await _rpc<dynamic>('get_join_request_status', params: {
      'p_request_id': requestId,
    });
    if (response == null) {
      throw const ServerException('Join request not found');
    }
    return Map<String, dynamic>.from(response as Map);
  }

  @override
  Future<void> cancelJoinRequest(String requestId) async {
    await _rpc<void>('cancel_join_request', params: {
      'p_request_id': requestId,
    });
  }

  @override
  Future<String> getCompanyJoinCode() async {
    final response = await _rpc<dynamic>('get_company_join_code');
    return response as String;
  }

  @override
  Future<String> regenerateCompanyJoinCode() async {
    final response = await _rpc<dynamic>('regenerate_company_join_code');
    return response as String;
  }

  @override
  Future<void> deactivateMember(String memberId) async {
    await _rpc<void>('deactivate_company_member', params: {
      'p_member_id': memberId,
    });
  }

  @override
  Future<void> reactivateMember(String memberId) async {
    await _rpc<void>('reactivate_company_member', params: {
      'p_member_id': memberId,
    });
  }

  @override
  Future<void> removeCompanyMemberRpc(String memberId) async {
    await _rpc<void>('remove_company_member', params: {
      'p_member_id': memberId,
    });
  }

  @override
  Future<void> promoteMemberToOwner(String memberId) async {
    await _rpc<void>('promote_member_to_owner', params: {
      'p_member_id': memberId,
    });
  }

  @override
  Future<void> demoteOwnerToMember(String memberId, Map<String, dynamic> permissions) async {
    await _rpc<void>('demote_owner_to_member', params: {
      'p_member_id': memberId,
      'p_permissions': permissions,
    });
  }

  @override
  Future<Map<String, dynamic>> getMemberPermissions(String memberId) async {
    final response = await _rpc<dynamic>('get_member_permissions', params: {
      'p_member_id': memberId,
    });
    if (response == null) return {};
    return Map<String, dynamic>.from(response as Map);
  }

  @override
  Future<void> leaveCompany() async {
    await _rpc<void>('leave_company');
  }

  @override
  Future<void> deleteCompany(String companyId) async {
    await _rpc<void>('delete_company', params: {
      'p_company_id': companyId,
    });
  }
}
