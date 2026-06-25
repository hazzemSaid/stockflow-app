class AddPaymentDto {
  final String invoiceId;
  final double amount;

  const AddPaymentDto({
    required this.invoiceId,
    required this.amount,
  });

  Map<String, dynamic> toJson() {
    return {
      'p_invoice_id': invoiceId,
      'p_amount': amount,
    };
  }
}
