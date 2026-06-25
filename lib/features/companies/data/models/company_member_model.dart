import 'package:stockflow/features/companies/domain/entities/company_member.dart';

class CompanyMemberModel extends CompanyMember {
  const CompanyMemberModel({
    required super.id,
    required super.companyId,
    required super.userId,
    required super.isOwner,
    required super.permissions,
    required super.joinedAt,
    super.userName,
    super.userEmail,
  });

  factory CompanyMemberModel.fromJson(Map<String, dynamic> json) {
    return CompanyMemberModel(
      id: json['id'] as String,
      companyId: json['company_id'] as String,
      userId: json['user_id'] as String,
      isOwner: json['is_owner'] as bool? ?? false,
      permissions: json['permissions'] != null
          ? Map<String, bool>.from(json['permissions'] as Map)
          : const {},
      joinedAt: DateTime.parse(json['joined_at'] as String),
      userName: json['user_name'] as String?,
      userEmail: json['user_email'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'company_id': companyId,
    'user_id': userId,
    'is_owner': isOwner,
    'permissions': permissions,
    'joined_at': joinedAt.toIso8601String(),
  };
}
