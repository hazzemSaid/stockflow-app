class CompanyMember {
  final String id;
  final String companyId;
  final String userId;
  final bool isOwner;
  final Map<String, bool> permissions;
  final DateTime joinedAt;
  final String? userName;
  final String? userEmail;

  const CompanyMember({
    required this.id,
    required this.companyId,
    required this.userId,
    required this.isOwner,
    required this.permissions,
    required this.joinedAt,
    this.userName,
    this.userEmail,
  });
}
