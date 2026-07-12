import 'package:makhzanflow/features/invoice/data/models/invoice_item_model.dart';
import 'package:makhzanflow/features/invoice/data/models/payment_model.dart';
import 'package:makhzanflow/features/invoice/domain/entities/invoice.dart';
import 'package:makhzanflow/features/invoice/domain/entities/invoice_status.dart';

class InvoiceModel {
  final String id;
  final String customerId;
  final String? customerName;
  final String? createdBy;
  final String? createdByName;
  final List<InvoiceItemModel> items;
  final List<PaymentModel> payments;
  final double subtotal;
  final String? discountType;
  final double discountValue;
  final double discountAmount;
  final double totalAmount;
  final double remainingAmount;
  final String paymentStatus;
  final DateTime? createdAt;

  const InvoiceModel({
    required this.id,
    required this.customerId,
    this.customerName,
    this.createdBy,
    this.createdByName,
    this.items = const [],
    this.payments = const [],
    required this.subtotal,
    this.discountType,
    this.discountValue = 0,
    this.discountAmount = 0,
    required this.totalAmount,
    this.remainingAmount = 0,
    this.paymentStatus = 'debt',
    this.createdAt,
  });

  factory InvoiceModel.fromJson(Map<String, dynamic> json) {
    final customer = json['customer'] as Map<String, dynamic>?;
    return InvoiceModel(
      id: json['id'] as String,
      customerId: customer?['id'] as String? ?? json['customer_id'] as String,
      customerName: customer?['name'] as String?,
      createdBy: json['created_by'] as String? ?? "",
      createdByName: json['created_by_name'] as String?,
      items:
          (json['invoice_items'] as List<dynamic>?)
              ?.map((e) => InvoiceItemModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      payments:
          (json['payments'] as List<dynamic>?)
              ?.map((e) => PaymentModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      subtotal:
          (json['subtotal'] as num?)?.toDouble() ??
          (json['total_amount'] as num).toDouble(),
      discountType: json['discount_type'] as String?,
      discountValue: (json['discount_value'] as num?)?.toDouble() ?? 0,
      discountAmount: (json['discount_amount'] as num?)?.toDouble() ?? 0,
      totalAmount: (json['total_amount'] as num).toDouble(),
      remainingAmount: (json['remaining_amount'] as num?)?.toDouble() ?? 0,
      paymentStatus: _resolvePaymentStatus(json),
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'] as String)
          : null,
    );
  }

  static String _resolvePaymentStatus(Map<String, dynamic> json) {
    final status =
        (json['payment_status'] as String?) ?? (json['status'] as String?);
    if (status == 'paid' || status == 'partial' || status == 'debt') {
      return status ?? 'debt';
    }
    final remaining = (json['remaining_amount'] as num?)?.toDouble() ?? 0;
    final total = (json['total_amount'] as num?)?.toDouble() ?? 0;
    if (remaining <= 0) return 'paid';
    if (remaining < total) return 'partial';
    return 'debt';
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'customer_id': customerId,
      if (customerName != null) 'customer_name': customerName,
      if (createdBy != null) 'created_by': createdBy,
      if (createdByName != null) 'created_by_name': createdByName,
      'subtotal': subtotal,
      if (discountType != null) 'discount_type': discountType,
      'payments': payments.map((e) => e.toJson()).toList(),
      'discount_value': discountValue,
      'discount_amount': discountAmount,
      'total_amount': totalAmount,
      'remaining_amount': remainingAmount,
      'payment_status': paymentStatus,
      if (createdAt != null) 'created_at': createdAt!.toIso8601String(),
    };
  }

  Invoice toEntity() {
    return Invoice(
      id: id,
      customerId: customerId,
      customerName: customerName,
      createdBy: createdBy,
      createdByName: createdByName,
      items: items.map((e) => e.toEntity()).toList(),
      payments: payments.map((e) => e.toEntity()).toList(),
      subtotal: subtotal,
      discountType: discountType,
      discountValue: discountValue,
      discountAmount: discountAmount,
      totalAmount: totalAmount,
      remainingAmount: remainingAmount,
      paymentStatus: _parseStatus(paymentStatus),
      createdAt: createdAt,
    );
  }

  static InvoiceStatus _parseStatus(String status) {
    switch (status) {
      case 'paid':
        return InvoiceStatus.paid;
      case 'partial':
        return InvoiceStatus.partial;
      default:
        return InvoiceStatus.debt;
    }
  }

  factory InvoiceModel.fromEntity(Invoice entity) {
    return InvoiceModel(
      id: entity.id,
      customerId: entity.customerId,
      customerName: entity.customerName,
      createdBy: entity.createdBy,
      createdByName: entity.createdByName,
      items: entity.items.map((e) => InvoiceItemModel.fromEntity(e)).toList(),
      payments: entity.payments.map((e) => PaymentModel.fromEntity(e)).toList(),
      subtotal: entity.subtotal,
      discountType: entity.discountType,
      discountValue: entity.discountValue,
      discountAmount: entity.discountAmount,
      totalAmount: entity.totalAmount,
      remainingAmount: entity.remainingAmount,
      paymentStatus: entity.paymentStatus.name,
      createdAt: entity.createdAt,
    );
  }
}
