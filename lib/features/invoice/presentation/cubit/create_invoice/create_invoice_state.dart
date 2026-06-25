import 'package:stockflow/core/error/failures.dart';
import 'package:stockflow/features/customers/domain/entities/customer.dart';

sealed class CreateInvoiceState {}

class CreateInvoiceInitial extends CreateInvoiceState {}

sealed class CreateInvoiceFormState extends CreateInvoiceState {
  final Customer? selectedCustomer;
  final List<SelectedProduct> products;
  final String discountType;
  final double discountValue;
  final String paymentMethod;
  final double paidNow;

  CreateInvoiceFormState({
    this.selectedCustomer,
    this.products = const [],
    this.discountType = 'fixed',
    this.discountValue = 0,
    this.paymentMethod = 'full',
    this.paidNow = 0,
  });

  double get subtotal => products.fold(0.0, (sum, p) => sum + p.total);

  double get discountAmount {
    if (discountValue <= 0) return 0;
    if (discountType == 'percentage') {
      return subtotal * (discountValue / 100);
    }
    return discountValue;
  }

  double get totalAfterDiscount => subtotal - discountAmount;

  double get remainingDebt {
    if (paymentMethod == 'full') return 0;
    if (paymentMethod == 'deferred') return totalAfterDiscount;
    return totalAfterDiscount - paidNow;
  }
}

class CreateInvoiceLoading extends CreateInvoiceFormState {
  CreateInvoiceLoading({
    super.selectedCustomer,
    super.products,
    super.discountType,
    super.discountValue,
    super.paymentMethod,
    super.paidNow,
  });
}

class CreateInvoiceLoaded extends CreateInvoiceFormState {
  CreateInvoiceLoaded({
    super.selectedCustomer,
    super.products,
    super.discountType,
    super.discountValue,
    super.paymentMethod,
    super.paidNow,
  });

  CreateInvoiceLoaded copyWith({
    Customer? selectedCustomer,
    List<SelectedProduct>? products,
    String? discountType,
    double? discountValue,
    String? paymentMethod,
    double? paidNow,
    bool clearCustomer = false,
  }) {
    return CreateInvoiceLoaded(
      selectedCustomer: clearCustomer
          ? null
          : selectedCustomer ?? this.selectedCustomer,
      products: products ?? this.products,
      discountType: discountType ?? this.discountType,
      discountValue: discountValue ?? this.discountValue,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      paidNow: paidNow ?? this.paidNow,
    );
  }
}

class CreateInvoiceError extends CreateInvoiceFormState {
  final Failure failure;

  CreateInvoiceError({
    required this.failure,
    super.selectedCustomer,
    super.products,
    super.discountType,
    super.discountValue,
    super.paymentMethod,
    super.paidNow,
  });
}

class CreateInvoiceSuccess extends CreateInvoiceState {
  final String invoiceId;
  CreateInvoiceSuccess({required this.invoiceId});
}

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
