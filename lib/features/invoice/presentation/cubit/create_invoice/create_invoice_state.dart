import 'package:stockflow/core/error/failures.dart';

sealed class CreateInvoiceState {}

class CreateInvoiceInitial extends CreateInvoiceState {}

class CreateInvoiceLoading extends CreateInvoiceState {}

class CreateInvoiceSuccess extends CreateInvoiceState {
  final String invoiceId;
  CreateInvoiceSuccess({required this.invoiceId});
}

class CreateInvoiceError extends CreateInvoiceState {
  final Failure failure;
  CreateInvoiceError({required this.failure});
}

class CreateInvoiceFormUpdate extends CreateInvoiceState {}

class SelectedProduct {
  final String productId;
  final String productName;
  final double unitPrice;
  final int quantity;

  const SelectedProduct({
    required this.productId,
    required this.productName,
    required this.unitPrice,
    required this.quantity,
  });

  SelectedProduct copyWith({int? quantity}) {
    return SelectedProduct(
      productId: productId,
      productName: productName,
      unitPrice: unitPrice,
      quantity: quantity ?? this.quantity,
    );
  }

  double get total => quantity * unitPrice;
}
