import 'package:stockflow/features/invoice/domain/entities/Payment.dart';

class PaymentModel {
  final String id;
  final String invoiceId;
  final double amount;
  final DateTime createdAt;

  const PaymentModel({
    required this.id,
    required this.invoiceId,
    required this.amount,
    required this.createdAt,
  });

  factory PaymentModel.fromJson(Map<String, dynamic> json) {
    return PaymentModel(
      id: json['id'] as String,
      invoiceId: json['invoice_id'] as String,
      amount: (json['amount'] as num).toDouble(),
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'invoice_id': invoiceId,
      'amount': amount,
      'created_at': createdAt.toIso8601String(),
    };
  }

  Payment toEntity() {
    return Payment(
      id: id,
      invoiceId: invoiceId,
      amount: amount,
      createdAt: createdAt,
    );
  }

  factory PaymentModel.fromEntity(Payment entity) {
    return PaymentModel(
      id: entity.id,
      invoiceId: entity.invoiceId,
      amount: entity.amount,
      createdAt: entity.createdAt,
    );
  }
}
