import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:makhzanflow/features/invoice/domain/usecases/get_invoices_usecase.dart';
import 'customer_invoices_state.dart';

export 'customer_invoices_state.dart';

const int _pageSize = 20;

class CustomerInvoicesCubit extends Cubit<CustomerInvoicesState> {
  final GetInvoicesUseCase _getInvoicesUseCase;
  final String _customerId;
  final String _companyId;
  int _currentPage = 0;

  CustomerInvoicesCubit({
    required GetInvoicesUseCase getInvoicesUseCase,
    required String customerId,
    required String companyId,
    String customerName = '',
  })  : _getInvoicesUseCase = getInvoicesUseCase,
        _customerId = customerId,
        _companyId = companyId,
        super(CustomerInvoicesState(customerName: customerName));

  Future<void> loadInvoices() async {
    _currentPage = 0;
    emit(state.copyWith(status: CustomerInvoicesStatus.loading));

    final result = await _getInvoicesUseCase(
      companyId: _companyId,
      customerId: _customerId,
      limit: _pageSize,
      offset: 0,
    );

    result.fold(
      (failure) => emit(state.copyWith(
        status: CustomerInvoicesStatus.error,
        failure: failure,
      )),
      (invoices) => emit(state.copyWith(
        status: invoices.isEmpty
            ? CustomerInvoicesStatus.empty
            : CustomerInvoicesStatus.success,
        invoices: invoices,
        hasMore: invoices.length == _pageSize,
      )),
    );
  }

  Future<void> loadMore() async {
    if (isLoadingMore || !state.hasMore) return;
    emit(state.copyWith(status: CustomerInvoicesStatus.loadingMore));

    final nextPage = _currentPage + 1;
    final nextOffset = nextPage * _pageSize;

    final result = await _getInvoicesUseCase(
      companyId: _companyId,
      customerId: _customerId,
      limit: _pageSize,
      offset: nextOffset,
    );

    result.fold(
      (_) => emit(state.copyWith(status: CustomerInvoicesStatus.success)),
      (newInvoices) {
        _currentPage = nextPage;
        final all = [...state.invoices, ...newInvoices];
        emit(state.copyWith(
          status: CustomerInvoicesStatus.success,
          invoices: all,
          hasMore: newInvoices.length == _pageSize,
        ));
      },
    );
  }

  bool get isLoadingMore => state.status == CustomerInvoicesStatus.loadingMore;
}
