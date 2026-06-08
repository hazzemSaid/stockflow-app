import 'package:equatable/equatable.dart';

class Customer extends Equatable {
  final String id;
  final String name;
  final String? nameOfficial;
  final String? phone;
  final String? address;
  final double totalDebt;
  final String? imageUrl;
  final DateTime? createdAt;

  const Customer({
    required this.id,
    required this.name,
    this.nameOfficial,
    this.phone,
    this.address,
    this.totalDebt = 0,
    this.imageUrl,
    this.createdAt,
  });

  Customer copyWith({
    String? id,
    String? name,
    String? nameOfficial,
    String? phone,
    String? address,
    double? totalDebt,
    String? imageUrl,
    DateTime? createdAt,
  }) {
    return Customer(
      id: id ?? this.id,
      name: name ?? this.name,
      nameOfficial: nameOfficial ?? this.nameOfficial,
      phone: phone ?? this.phone,
      address: address ?? this.address,
      totalDebt: totalDebt ?? this.totalDebt,
      imageUrl: imageUrl ?? this.imageUrl,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  List<Object?> get props => [
    id,
    name,
    nameOfficial,
    phone,
    address,
    totalDebt,
    imageUrl,
    createdAt,
  ];
}
