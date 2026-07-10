class CompanyMember {
  final String id;
  final String companyId;
  final String userId;
  final bool isOwner;
  final Map<String, dynamic> permissions;
  final DateTime joinedAt;
  final String? userName;
  final String? userEmail;
  final String status;
  final DateTime? deactivatedAt;
  final String? deactivatedBy;
  final DateTime? removedAt;
  final String? removedBy;

  const CompanyMember({
    required this.id,
    required this.companyId,
    required this.userId,
    required this.isOwner,
    required this.permissions,
    required this.joinedAt,
    this.userName,
    this.userEmail,
    this.status = 'active',
    this.deactivatedAt,
    this.deactivatedBy,
    this.removedAt,
    this.removedBy,
  });

  bool get isActive => status == 'active';
}
