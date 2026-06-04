import 'package:equatable/equatable.dart';

class ProductInput extends Equatable {
  final String name;
  final double price;
  final int quantity;
  final String? imageUrl;
  final DateTime? expirationDate;

  const ProductInput({
    required this.name,
    required this.price,
    required this.quantity,
    this.imageUrl,
    this.expirationDate,
  });

  String? validate() {
    if (name.trim().isEmpty) return 'يرجى إدخال اسم المنتج';
    if (price < 0) return 'السعر غير صالح';
    if (quantity < 0) return 'الكمية غير صالحة';
    return null;
  }

  @override
  List<Object?> get props => [
    name,
    price,
    quantity,
    imageUrl,
    expirationDate,
  ];
}
