class InvoiceCreateDto {
  final String customerId;
  final List<Map<String, dynamic>> items;
  final double paidNow;
  final String discountType;
  final double discountValue;

  const InvoiceCreateDto({
    required this.customerId,
    required this.items,
    this.paidNow = 0,
    this.discountType = 'fixed',
    this.discountValue = 0,
  });

  Map<String, dynamic> toJson() {
    return {
      'p_customer_id': customerId,
      'p_items': items,
      'p_paid_now': paidNow,
      'p_discount_type': discountType,
      'p_discount_value': discountValue,
    };
  }
}
