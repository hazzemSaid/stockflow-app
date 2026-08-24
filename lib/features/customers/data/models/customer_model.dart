import '../../domain/entities/customer.dart';
import '../../domain/entities/customer_transaction.dart';

class CustomerModel {
  final String id;
  final String name;
  final String? nameOfficial;
  final String? phone;
  final String? email;
  final String? address;
  final double openingBalance;
  final double totalDebt;
  final String? imageUrl;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final double totalPurchases;
  final double totalPaid;
  final List<CustomerTransaction> transactions;

  const CustomerModel({
    required this.id,
    required this.name,
    this.nameOfficial,
    this.phone,
    this.email,
    this.address,
    this.openingBalance = 0,
    this.totalDebt = 0,
    this.imageUrl,
    this.createdAt,
    this.updatedAt,
    this.totalPurchases = 0,
    this.totalPaid = 0,
    this.transactions = const [],
  });

  factory CustomerModel.fromJson(Map<String, dynamic> json) {
    final rawInvoices = json['invoices'] as List<dynamic>? ?? [];
    final rawPayments = json['payments'] as List<dynamic>? ?? [];

    double totalPurchases = 0;
    if (json.containsKey('total_purchases')) {
      totalPurchases = (json['total_purchases'] as num?)?.toDouble() ?? 0;
    } else {
      for (final inv in rawInvoices) {
        totalPurchases += (inv['total_amount'] as num?)?.toDouble() ?? 0;
      }
    }

    double totalPaid = 0;
    if (json.containsKey('total_paid')) {
      totalPaid = (json['total_paid'] as num?)?.toDouble() ?? 0;
    } else {
      for (final pay in rawPayments) {
        totalPaid += (pay['amount'] as num?)?.toDouble() ?? 0;
      }
    }

    final transactions = <CustomerTransaction>[];

    for (final inv in rawInvoices) {
      final invId = inv['id'] as String;
      final date = DateTime.parse(inv['created_at'] as String);
      final amount = (inv['total_amount'] as num).toDouble();
      final status = inv['payment_status'] as String? ?? 'debt';
      final isOpening = inv['is_opening_balance'] == true ||
          inv['invoice_type'] == 'opening_balance';

      if (isOpening) {
        transactions.add(CustomerTransaction(
          id: invId,
          type: 'opening_debt',
          amount: amount,
          createdAt: date,
          title: 'رصيد افتتاحي',
          subtitle: 'عند إنشاء الحساب',
          statusLabel: 'معلق',
        ));
      } else {
        String statusLabel = 'آجل';
        if (status == 'paid') statusLabel = 'مدفوع';
        if (status == 'partial') statusLabel = 'مدفوع جزئياً';

        transactions.add(CustomerTransaction(
          id: invId,
          type: 'invoice',
          amount: amount,
          createdAt: date,
          title: 'فاتورة مبيعات #${invId.substring(0, invId.length > 8 ? 8 : invId.length)}',
          subtitle:
              '${(inv['remaining_amount'] as num?)?.toDouble() ?? 0} ج.م متبقي',
          statusLabel: statusLabel,
        ));
      }
    }

    for (final pay in rawPayments) {
      final payId = pay['id'] as String;
      final date = DateTime.parse(pay['created_at'] as String);
      final amount = (pay['amount'] as num).toDouble();

      transactions.add(CustomerTransaction(
        id: payId,
        type: 'payment',
        amount: amount,
        createdAt: date,
        title: 'سداد دفعة نقداً',
        subtitle: 'تم الاستلام بنجاح',
        statusLabel: 'مستلم',
      ));
    }

    final totalDebt =
        (json['current_debt'] as num?)?.toDouble() ??
        (json['computed_debt'] as num?)?.toDouble() ??
        0;
    final createdAtStr = json['created_at'] as String?;
    final updatedAtStr = json['updated_at'] as String?;

    transactions.sort((a, b) => b.createdAt.compareTo(a.createdAt));

    return CustomerModel(
      id: json['id'] as String,
      name: json['name'] as String,
      nameOfficial: json['name_official'] as String?,
      phone: json['phone'] as String?,
      email: json['email'] as String?,
      address: json['address'] as String?,
      openingBalance:
          (json['opening_balance'] as num?)?.toDouble() ?? 0,
      totalDebt: totalDebt,
      imageUrl: json['image_url'] as String?,
      createdAt:
          createdAtStr != null ? DateTime.tryParse(createdAtStr) : null,
      updatedAt:
          updatedAtStr != null ? DateTime.tryParse(updatedAtStr) : null,
      totalPurchases: totalPurchases,
      totalPaid: totalPaid,
      transactions: transactions,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      if (nameOfficial != null) 'name_official': nameOfficial,
      if (phone != null) 'phone': phone,
      if (email != null) 'email': email,
      if (address != null) 'address': address,
      if (imageUrl != null) 'image_url': imageUrl,
      if (createdAt != null) 'created_at': createdAt!.toIso8601String(),
      if (updatedAt != null) 'updated_at': updatedAt!.toIso8601String(),
      if (totalPurchases > 0) 'total_purchases': totalPurchases,
      if (totalPaid > 0) 'total_paid': totalPaid,
    };
  }

  Map<String, dynamic> toInsertJson() {
    return {
      'name': name,
      if (nameOfficial != null) 'name_official': nameOfficial,
      if (phone != null) 'phone': phone,
      if (email != null) 'email': email,
      if (address != null) 'address': address,
      if (imageUrl != null) 'image_url': imageUrl,
    };
  }

  Map<String, dynamic> toUpdateJson() {
    return {
      'name': name,
      if (nameOfficial != null) 'name_official': nameOfficial,
      if (phone != null) 'phone': phone,
      if (email != null) 'email': email,
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
      email: email,
      address: address,
      openingBalance: openingBalance,
      totalDebt: totalDebt,
      imageUrl: imageUrl,
      createdAt: createdAt,
      updatedAt: updatedAt,
      totalPurchases: totalPurchases,
      totalPaid: totalPaid,
      transactions: transactions,
    );
  }

  factory CustomerModel.fromEntity(Customer entity) {
    return CustomerModel(
      id: entity.id,
      name: entity.name,
      nameOfficial: entity.nameOfficial,
      phone: entity.phone,
      email: entity.email,
      address: entity.address,
      openingBalance: entity.openingBalance,
      totalDebt: entity.totalDebt,
      imageUrl: entity.imageUrl,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
      totalPurchases: entity.totalPurchases,
      totalPaid: entity.totalPaid,
      transactions: entity.transactions,
    );
  }
}
