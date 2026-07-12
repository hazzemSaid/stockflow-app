import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:makhzanflow/core/error/failures.dart';
import 'package:makhzanflow/features/invoice/domain/usecases/add_payment_usecase.dart';
import 'package:makhzanflow/features/invoice/domain/usecases/get_invoices_usecase.dart';
import 'add_payment_state.dart';

export 'add_payment_state.dart';

class AddPaymentCubit extends Cubit<AddPaymentState> {
  final GetInvoicesUseCase _getInvoicesUseCase;
  final AddPaymentUseCase _addPaymentUseCase;

  AddPaymentCubit({
    required GetInvoicesUseCase getInvoicesUseCase,
    required AddPaymentUseCase addPaymentUseCase,
  })  : _getInvoicesUseCase = getInvoicesUseCase,
        _addPaymentUseCase = addPaymentUseCase,
        super(AddPaymentInitial());

  Future<void> loadUnpaidInvoices({
    required String customerId,
    required String customerName,
    required String companyId,
  }) async {
    emit(AddPaymentLoading());

    final result = await _getInvoicesUseCase(
      companyId: companyId,
      statusFilter: ['debt', 'partial'],
      customerId: customerId,
    );

    result.fold(
      (failure) => emit(AddPaymentError(failure: failure)),
      (invoices) => emit(
        AddPaymentLoaded(
          invoices: invoices,
          customerName: customerName,
        ),
      ),
    );
  }

  void selectInvoice(String invoiceId) {
    final current = state;
    if (current is! AddPaymentLoaded) return;

    final invoice = current.invoices.where((i) => i.id == invoiceId).firstOrNull;
    final maxAmount = invoice?.remainingAmount;

    String? error;
    final parsed = double.tryParse(current.amount);
    if (parsed != null && maxAmount != null && parsed > maxAmount) {
      error = 'المبلغ يتجاوز المبلغ المتبقي (${_formatAmount(maxAmount)})';
    }

    emit(current.copyWith(
      selectedInvoiceId: invoiceId,
      maxAmount: maxAmount,
      amountError: error,
    ));
  }

  void updateAmount(String amount) {
    final current = state;
    if (current is! AddPaymentLoaded) return;

    String? error;
    final parsed = double.tryParse(amount);
    if (parsed != null && current.maxAmount != null && parsed > current.maxAmount!) {
      error = 'المبلغ يتجاوز المبلغ المتبقي (${_formatAmount(current.maxAmount!)})';
    }

    emit(current.copyWith(amount: amount, amountError: error));
  }

  bool get canSubmit {
    final current = state;
    if (current is! AddPaymentLoaded) return false;
    final parsed = double.tryParse(current.amount);
    return parsed != null &&
        parsed > 0 &&
        current.selectedInvoiceId != null &&
        current.amountError == null;
  }

  Future<void> submit() async {
    final current = state;
    if (current is! AddPaymentLoaded) return;

    final parsed = double.tryParse(current.amount);
    if (parsed == null || parsed <= 0) {
      emit(AddPaymentError(
        failure: const ServerFailure('يرجى إدخال مبلغ صحيح'),
      ));
      return;
    }

    if (current.selectedInvoiceId == null) {
      emit(AddPaymentError(
        failure: const ServerFailure('يرجى اختيار فاتورة'),
      ));
      return;
    }

    if (current.amountError != null) {
      emit(AddPaymentError(
        failure: ServerFailure(current.amountError!),
      ));
      return;
    }

    emit(AddPaymentSubmitting());

    final result = await _addPaymentUseCase(
      invoiceId: current.selectedInvoiceId!,
      amount: parsed,
    );

    result.fold(
      (failure) => emit(AddPaymentError(failure: failure)),
      (_) => emit(AddPaymentSuccess(invoiceId: current.selectedInvoiceId!)),
    );
  }

  String _formatAmount(double amount) {
    if (amount == amount.truncateToDouble()) {
      return amount.toInt().toString();
    }
    return amount.toStringAsFixed(2);
  }
}
