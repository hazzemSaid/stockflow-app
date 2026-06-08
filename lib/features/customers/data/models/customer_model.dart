import '../../domain/entities/customer.dart';

class CustomerModel {
  final String id;
  final String name;
  final String? nameOfficial;
  final String? phone;
  final String? address;
  final double totalDebt;
  final String? imageUrl;
  final DateTime? createdAt;

  const CustomerModel({
    required this.id,
    required this.name,
    this.nameOfficial,
    this.phone,
    this.address,
    this.totalDebt = 0,
    this.imageUrl,
    this.createdAt,
  });

  factory CustomerModel.fromJson(Map<String, dynamic> json) {
    return CustomerModel(
      id: json['id'] as String,
      name: json['name'] as String,
      nameOfficial: json['name_official'] as String?,
      phone: json['phone'] as String?,
      address: json['address'] as String?,
      totalDebt: (json['total_debt'] as num?)?.toDouble() ?? 0,
      imageUrl: json['image_url'] as String?,
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      if (nameOfficial != null) 'name_official': nameOfficial,
      if (phone != null) 'phone': phone,
      if (address != null) 'address': address,
      if (totalDebt > 0) 'total_debt': totalDebt,
      if (imageUrl != null) 'image_url': imageUrl,
      if (createdAt != null) 'created_at': createdAt!.toIso8601String(),
    };
  }

  Map<String, dynamic> toInsertJson() {
    return {
      'name': name,
      if (nameOfficial != null) 'name_official': nameOfficial,
      if (phone != null) 'phone': phone,
      if (address != null) 'address': address,
      if (totalDebt > 0) 'total_debt': totalDebt,
      if (imageUrl != null) 'image_url': imageUrl,
    };
  }

  Map<String, dynamic> toUpdateJson() {
    return {
      'name': name,
      if (nameOfficial != null) 'name_official': nameOfficial,
      if (phone != null) 'phone': phone,
      if (address != null) 'address': address,
      'image_url': imageUrl,
    };
  }

  Customer toEntity() {
    return Customer(
      id: id,
      name: name,
      nameOfficial: nameOfficial,
      phone: phone,
      address: address,
      totalDebt: totalDebt,
      imageUrl: imageUrl,
      createdAt: createdAt,
    );
  }

  factory CustomerModel.fromEntity(Customer entity) {
    return CustomerModel(
      id: entity.id,
      name: entity.name,
      nameOfficial: entity.nameOfficial,
      phone: entity.phone,
      address: entity.address,
      totalDebt: entity.totalDebt,
      imageUrl: entity.imageUrl,
      createdAt: entity.createdAt,
    );
  }
}
