class Company {
  final String id;
  final String name;
  final String? address;
  final String? phone;
  final String subscriptionPlan;
  final String status;
  final String? businessType;
  final String? logoUrl;
  final String? inviteCode;
  final DateTime createdAt;
  final DateTime? updatedAt;

  const Company({
    required this.id,
    required this.name,
    this.address,
    this.phone,
    this.subscriptionPlan = 'free',
    this.status = 'active',
    this.businessType,
    this.logoUrl,
    this.inviteCode,
    required this.createdAt,
    this.updatedAt,
  });
}
