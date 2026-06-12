import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stockflow/core/error/failures.dart';
import 'package:stockflow/features/customers/domain/entities/customer.dart';
import 'package:stockflow/features/invoice/domain/usecases/create_invoice_usecase.dart';
import 'create_invoice_state.dart';

export 'create_invoice_state.dart';

class CreateInvoiceCubit extends Cubit<CreateInvoiceState> {
  final CreateInvoiceUseCase _createInvoiceUseCase;

  Customer? selectedCustomer;
  List<SelectedProduct> products = [];
  String discountType = 'fixed';
  double discountValue = 0;
  String paymentMethod = 'full';
  double paidNow = 0;

  CreateInvoiceCubit({
    required CreateInvoiceUseCase createInvoiceUseCase,
  }) : _createInvoiceUseCase = createInvoiceUseCase,
       super(CreateInvoiceInitial());

  double get subtotal =>
      products.fold(0.0, (sum, p) => sum + p.total);

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

  void selectCustomer(Customer customer) {
    selectedCustomer = customer;
    emit(CreateInvoiceFormUpdate());
  }

  void addProduct(SelectedProduct product) {
    final index = products.indexWhere((p) => p.productId == product.productId);
    if (index >= 0) {
      final existing = products[index];
      products[index] = existing.copyWith(
        quantity: existing.quantity + product.quantity,
      );
    } else {
      products.add(product);
    }
    emit(CreateInvoiceFormUpdate());
  }

  void updateProductQuantity(String productId, int quantity) {
    final index = products.indexWhere((p) => p.productId == productId);
    if (index < 0) return;
    if (quantity <= 0) {
      products.removeAt(index);
    } else {
      products[index] = products[index].copyWith(quantity: quantity);
    }
    emit(CreateInvoiceFormUpdate());
  }

  void removeProduct(String productId) {
    products.removeWhere((p) => p.productId == productId);
    emit(CreateInvoiceFormUpdate());
  }

  void setDiscountType(String type) {
    discountType = type;
    emit(CreateInvoiceFormUpdate());
  }

  void setDiscountValue(double value) {
    discountValue = value;
    emit(CreateInvoiceFormUpdate());
  }

  void setPaymentMethod(String method) {
    paymentMethod = method;
    emit(CreateInvoiceFormUpdate());
  }

  void setPaidNow(double value) {
    paidNow = value;
    emit(CreateInvoiceFormUpdate());
  }

  Future<void> submit(String createdBy) async {
    if (selectedCustomer == null) {
      emit(CreateInvoiceError(
        failure: const ServerFailure('الرجاء اختيار عميل'),
      ));
      return;
    }
    if (products.isEmpty) {
      emit(CreateInvoiceError(
        failure: const ServerFailure('الرجاء إضافة منتج واحد على الأقل'),
      ));
      return;
    }

    emit(CreateInvoiceLoading());

    final items = products
        .map((p) => {
              'product_id': p.productId,
              'product_name': p.productName,
              'quantity': p.quantity,
              'unit_price': p.unitPrice,
              'total_price': p.total,
            })
        .toList();

    final effectivePaidNow = switch (paymentMethod) {
      'full' => totalAfterDiscount,
      'deferred' => 0.0,
      _ => paidNow,
    };
    final result = await _createInvoiceUseCase(
      customerId: selectedCustomer!.id,
      createdBy: createdBy,
      items: items,
      paidNow: effectivePaidNow,
      discountType: discountValue > 0 ? discountType : 'fixed',
      discountValue: discountValue,
    );

    result.fold(
      (failure) => emit(CreateInvoiceError(failure: failure)),
      (invoiceId) => emit(CreateInvoiceSuccess(invoiceId: invoiceId)),
    );
  }

  void reset() {
    selectedCustomer = null;
    products = [];
    discountType = 'fixed';
    discountValue = 0;
    paymentMethod = 'full';
    paidNow = 0;
    emit(CreateInvoiceInitial());
  }
}
