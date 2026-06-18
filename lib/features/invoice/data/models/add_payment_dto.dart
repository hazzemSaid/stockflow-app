class AddPaymentDto {
  final String invoiceId;
  final double amount;
  final String? createdBy;

  const AddPaymentDto({
    required this.invoiceId,
    required this.amount,
    this.createdBy,
  });

  Map<String, dynamic> toJson() {
    return {
      'p_invoice_id': invoiceId,
      'p_amount': amount,
      if (createdBy != null) 'p_created_by': createdBy,
    };
  }
}
