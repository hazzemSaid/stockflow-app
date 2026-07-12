import 'package:makhzanflow/features/companies/domain/entities/join_request.dart';

class JoinRequestModel extends JoinRequest {
  const JoinRequestModel({
    required super.id,
    required super.companyId,
    required super.userId,
    required super.userName,
    required super.userEmail,
    required super.status,
    required super.createdAt,
  });

  factory JoinRequestModel.fromJson(Map<String, dynamic> json) {
    return JoinRequestModel(
      id: json['id'] as String,
      companyId: json['company_id'] as String,
      userId: json['user_id'] as String,
      userName: json['user_name'] as String? ?? '',
      userEmail: json['user_email'] as String? ?? '',
      status: json['status'] as String? ?? 'pending',
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'company_id': companyId,
    'user_id': userId,
    'user_name': userName,
    'user_email': userEmail,
    'status': status,
    'created_at': createdAt.toIso8601String(),
  };
}
