class InvoiceCreateDto {
  final String customerId;
  final String createdBy;
  final List<Map<String, dynamic>> items;
  final double paidNow;
  final String discountType;
  final double discountValue;

  const InvoiceCreateDto({
    required this.customerId,
    required this.createdBy,
    required this.items,
    this.paidNow = 0,
    this.discountType = 'fixed',
    this.discountValue = 0,
  });

  Map<String, dynamic> toJson() {
    return {
      'p_customer_id': customerId,
      'p_created_by': createdBy,
      'p_items': items,
      'p_paid_now': paidNow,
      'p_discount_type': discountType,
      'p_discount_value': discountValue,
    };
  }
}
