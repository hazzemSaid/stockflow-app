import '../../domain/entities/inventory_movement.dart';

class InventoryMovementModel {
  final String id;
  final String productId;
  final String type;
  final int quantity;
  final String? note;
  final String createdBy;
  final DateTime? createdAt;

  const InventoryMovementModel({
    required this.id,
    required this.productId,
    required this.type,
    required this.quantity,
    this.note,
    required this.createdBy,
    this.createdAt,
  });

  factory InventoryMovementModel.fromJson(Map<String, dynamic> json) {
    return InventoryMovementModel(
      id: json['id'] as String,
      productId: json['product_id'] as String,
      type: json['type'] as String,
      quantity: json['quantity'] as int,
      note: json['note'] as String?,
      createdBy: json['created_by'] as String,
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'product_id': productId,
      'type': type,
      'quantity': quantity,
      'note': note,
      'created_by': createdBy,
      'created_at': createdAt?.toIso8601String(),
    };
  }

  Map<String, dynamic> toInsertJson() {
    return {
      'product_id': productId,
      'type': type,
      'quantity': quantity,
      if (note != null) 'note': note,
      'created_by': createdBy,
    };
  }

  InventoryMovement toEntity() {
    return InventoryMovement(
      id: id,
      productId: productId,
      type: type,
      quantity: quantity,
      note: note,
      createdBy: createdBy,
      createdAt: createdAt,
    );
  }

  factory InventoryMovementModel.fromEntity(InventoryMovement entity) {
    return InventoryMovementModel(
      id: entity.id,
      productId: entity.productId,
      type: entity.type,
      quantity: entity.quantity,
      note: entity.note,
      createdBy: entity.createdBy,
      createdAt: entity.createdAt,
    );
  }
}
