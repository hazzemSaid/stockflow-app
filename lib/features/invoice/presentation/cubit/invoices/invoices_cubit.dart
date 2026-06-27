import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stockflow/features/customers/domain/usecases/get_customers_usecase.dart';
import 'package:stockflow/features/invoice/domain/entities/invoice_status.dart';
import 'package:stockflow/features/invoice/domain/usecases/get_invoices_usecase.dart';
import 'invoices_state.dart';

export 'invoices_state.dart';

const int _pageSize = 20;

class InvoicesCubit extends Cubit<InvoicesState> {
  final GetInvoicesUseCase _getInvoicesUseCase;
  final GetCustomersUseCase _getCustomersUseCase;

  InvoicesCubit({
    required GetInvoicesUseCase getInvoicesUseCase,
    required GetCustomersUseCase getCustomersUseCase,
  })  : _getInvoicesUseCase = getInvoicesUseCase,
        _getCustomersUseCase = getCustomersUseCase,
        super(const InvoicesState());

  Future<void> loadInvoices(String companyId) async {
    emit(state.copyWith(status: InvoicesStatus.loading, clearFailure: true));

    final statusFilterNames = state.statusFilter != null
        ? [state.statusFilter!.name]
        : null;

    final result = await _getInvoicesUseCase(
      companyId: companyId,
      statusFilter: statusFilterNames,
      customerId: state.customerId,
      limit: _pageSize,
      offset: 0,
    );

    result.fold(
      (failure) {
        emit(state.copyWith(status: InvoicesStatus.error, failure: failure));
      },
      (invoices) {
        emit(
          state.copyWith(
            status: invoices.isEmpty
                ? InvoicesStatus.empty
                : InvoicesStatus.success,
            invoices: invoices,
          ),
        );
      },
    );
  }

  void setFilter({
    required String companyId,
    InvoiceStatus? statusFilter,
    String? customerId,
  }) {
    emit(state.copyWith(
      statusFilter: statusFilter,
      customerId: customerId,
    ));
    loadInvoices(companyId);
  }

  void clearFilters(String companyId) {
    emit(state.copyWith(
      statusFilter: null,
      customerId: null,
    ));
    loadInvoices(companyId);
  }

  Future<void> refresh(String companyId) async {
    await loadInvoices(companyId);
  }

  Future<void> loadCustomers(String companyId) async {
    final result = await _getCustomersUseCase(companyId: companyId);
    result.fold(
      (_) => emit(state.copyWith(customers: const [])),
      (customers) => emit(state.copyWith(customers: customers)),
    );
  }
}
