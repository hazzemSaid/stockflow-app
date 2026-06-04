import '../../domain/entities/product.dart';

class ProductModel {
  final String id;
  final String name;
  final String? imageUrl;
  final int quantity;
  final double price;
  final String createdBy;
  final DateTime? expirationDate;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const ProductModel({
    required this.id,
    required this.name,
    this.imageUrl,
    required this.quantity,
    required this.price,
    required this.createdBy,
    this.expirationDate,
    this.createdAt,
    this.updatedAt,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'] as String,
      name: json['name'] as String,
      imageUrl: json['image_url'] as String?,
      quantity: json['quantity'] as int,
      price: (json['price'] as num).toDouble(),
      createdBy: json['created_by'] as String,
      expirationDate: json['expiration_date'] != null
          ? DateTime.tryParse(json['expiration_date'] as String)
          : null,
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'] as String)
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.tryParse(json['updated_at'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'image_url': imageUrl,
      'quantity': quantity,
      'price': price,
      'created_by': createdBy,
      'expiration_date': expirationDate?.toIso8601String(),
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }

  Map<String, dynamic> toInsertJson() {
    return {
      'name': name,
      if (imageUrl != null) 'image_url': imageUrl,
      'quantity': quantity,
      'price': price,
      'created_by': createdBy,
      if (expirationDate != null)
        'expiration_date': expirationDate!.toIso8601String(),
    };
  }

  Map<String, dynamic> toUpdateJson() {
    final data = <String, dynamic>{
      'name': name,
      'price': price,
      'quantity': quantity,
    };
    if (imageUrl != null) data['image_url'] = imageUrl;
    if (expirationDate != null) {
      data['expiration_date'] = expirationDate!.toIso8601String();
    } else {
      data['expiration_date'] = null;
    }
    return data;
  }

  Product toEntity() {
    return Product(
      id: id,
      name: name,
      imageUrl: imageUrl,
      quantity: quantity,
      price: price,
      createdBy: createdBy,
      expirationDate: expirationDate,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  factory ProductModel.fromEntity(Product entity) {
    return ProductModel(
      id: entity.id,
      name: entity.name,
      imageUrl: entity.imageUrl,
      quantity: entity.quantity,
      price: entity.price,
      createdBy: entity.createdBy,
      expirationDate: entity.expirationDate,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
    );
  }
}
