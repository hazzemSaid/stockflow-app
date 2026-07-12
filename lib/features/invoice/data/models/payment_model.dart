import 'package:makhzanflow/features/invoice/domain/entities/payment.dart';

class PaymentModel {
  final String id;
  final String invoiceId;
  final double amount;
  final String? createdBy;
  final DateTime createdAt;

  const PaymentModel({
    required this.id,
    required this.invoiceId,
    required this.amount,
    this.createdBy,
    required this.createdAt,
  });

  factory PaymentModel.fromJson(Map<String, dynamic> json) {
    return PaymentModel(
      id: json['id'] as String,
      invoiceId: json['invoice_id'] as String,
      amount: (json['amount'] as num).toDouble(),
      createdBy: json['created_by'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'invoice_id': invoiceId,
      'amount': amount,
      if (createdBy != null) 'created_by': createdBy,
      'created_at': createdAt.toIso8601String(),
    };
  }

  Payment toEntity() {
    return Payment(
      id: id,
      invoiceId: invoiceId,
      amount: amount,
      createdBy: createdBy,
      createdAt: createdAt,
    );
  }

  factory PaymentModel.fromEntity(Payment entity) {
    return PaymentModel(
      createdBy: entity.createdBy,
      id: entity.id,
      invoiceId: entity.invoiceId,
      amount: entity.amount,
      createdAt: entity.createdAt,
    );
  }
}
