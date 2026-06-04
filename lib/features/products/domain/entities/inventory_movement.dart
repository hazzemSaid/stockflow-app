import 'package:equatable/equatable.dart';

class InventoryMovement extends Equatable {
  final String id;
  final String productId;
  final String type;
  final int quantity;
  final String? note;
  final String createdBy;
  final DateTime? createdAt;

  const InventoryMovement({
    required this.id,
    required this.productId,
    required this.type,
    required this.quantity,
    this.note,
    required this.createdBy,
    this.createdAt,
  });

  bool get isIn => type == 'in';
  bool get isOut => type == 'out';

  @override
  List<Object?> get props => [
    id,
    productId,
    type,
    quantity,
    note,
    createdBy,
    createdAt,
  ];
}
