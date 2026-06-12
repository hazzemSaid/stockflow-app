import 'package:equatable/equatable.dart';

class InvoiceItem extends Equatable {
  final String productId;
  final int quantity;
  final double unitPrice;
  final String productName;
  final String? productImageUrl;
  double get total => quantity * unitPrice;

  const InvoiceItem({
    required this.productId,
    required this.quantity,
    required this.unitPrice,
    required this.productName,
    this.productImageUrl,
  });

  @override
  List<Object?> get props => [
    productId,
    quantity,
    unitPrice,
    productName,
    productImageUrl,
  ];
}
