import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:stockflow/core/error/exceptions.dart';
import 'package:stockflow/features/companies/data/datasources/company_remote_data_source.dart';
import 'package:stockflow/features/companies/data/models/company_member_model.dart';
import 'package:stockflow/features/companies/data/models/company_model.dart';
import 'package:stockflow/features/companies/data/models/join_request_model.dart';

class CompanyRemoteDataSourceImpl implements CompanyRemoteDataSource {
  final SupabaseClient _client;

  CompanyRemoteDataSourceImpl(this._client);

  @override
  Future<List<CompanyModel>> getUserCompanies() async {
    final response = await _client.rpc('get_user_companies');
    final list = (response as List).map((e) => CompanyModel.fromJson(e as Map<String, dynamic>)).toList();
    return list;
  }

  @override
  Future<CompanyModel> createCompany(String name, {String? address, String? phone}) async {
    final params = <String, dynamic>{'p_name': name};
    if (address != null) params['p_address'] = address;
    if (phone != null) params['p_phone'] = phone;
    final companyId = await _client.rpc('create_company', params: params);
    return getCompany(companyId.toString());
  }

  @override
  Future<CompanyModel> getCompany(String companyId) async {
    final response = await _client
        .from('companies')
        .select()
        .eq('id', companyId)
        .single();
    return CompanyModel.fromJson(response);
  }

  @override
  Future<void> updateCompany(String companyId, {String? name, String? address, String? phone, String? logoUrl}) async {
    final updates = <String, dynamic>{
      'updated_at': DateTime.now().toIso8601String(),
    };
    if (name != null) updates['name'] = name;
    if (address != null) updates['address'] = address;
    if (phone != null) updates['phone'] = phone;
    if (logoUrl != null) updates['logo_url'] = logoUrl;
    await _client.from('companies').update(updates).eq('id', companyId);
  }

  @override
  Future<List<CompanyMemberModel>> getCompanyMembers(String companyId) async {
    final response = await _client.rpc('get_company_members', params: {
      'p_company_id': companyId,
    });
    final list = (response as List).map((e) => CompanyMemberModel.fromJson(e as Map<String, dynamic>)).toList();
    return list;
  }

  @override
  Future<CompanyMemberModel> inviteMember(String companyId, String userEmail) async {
    final memberId = await _client.rpc('invite_company_member', params: {
      'p_user_email': userEmail,
    });
    final members = await getCompanyMembers(companyId);
    return members.firstWhere((m) => m.id == memberId.toString());
  }

  @override
  Future<void> updateMemberPermissions(String companyId, String memberId, Map<String, bool> permissions) async {
    await _client.rpc('update_member_permissions', params: {
      'p_member_id': memberId,
      'p_permissions': permissions,
    });
  }

  @override
  Future<void> removeMember(String companyId, String memberId) async {
    await _client
        .from('company_members')
        .delete()
        .eq('id', memberId)
        .eq('company_id', companyId);
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
    final response = await _client.rpc('create_company_full', params: params);
    return CompanyModel.fromJson(response as Map<String, dynamic>);
  }

  @override
  Future<Map<String, dynamic>> joinCompanyByCode(String inviteCode) async {
    final response = await _client.rpc('join_company_by_code', params: {
      'p_invite_code': inviteCode,
    });
    return response as Map<String, dynamic>;
  }

  @override
  Future<List<JoinRequestModel>> getJoinRequests(String companyId, {String status = 'pending'}) async {
    final response = await _client.rpc('get_join_requests', params: {
      'p_company_id': companyId,
      'p_status': status,
    });
    final list = (response as List).map((e) {
      final row = Map<String, dynamic>.from(e as Map);
      row.putIfAbsent('company_id', () => companyId);
      return JoinRequestModel.fromJson(row);
    }).toList();
    return list;
  }

  @override
  Future<String> approveJoinRequest(String requestId) async {
    final memberId = await _client.rpc('approve_join_request', params: {
      'p_request_id': requestId,
    });
    return memberId.toString();
  }

  @override
  Future<void> rejectJoinRequest(String requestId) async {
    await _client.rpc('reject_join_request', params: {
      'p_request_id': requestId,
    });
  }

  @override
  Future<Map<String, dynamic>> getJoinRequestStatus(String requestId) async {
    final response = await _client
        .from('join_requests')
        .select('id, status, company_id')
        .eq('id', requestId)
        .maybeSingle();
    if (response == null) {
      throw const ServerException('Join request not found');
    }
    return response;
  }
}
