import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:makhzanflow/features/customers/domain/usecases/get_customers_usecase.dart';
import 'package:makhzanflow/features/invoice/domain/entities/invoice_status.dart';
import 'package:makhzanflow/features/invoice/domain/usecases/get_invoices_usecase.dart';
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

  Future<void> _loadWithParams({
    required String companyId,
    InvoiceStatus? statusFilter,
    String? customerId,
  }) async {
    emit(state.copyWith(status: InvoicesStatus.loading, clearFailure: true));

    final statusFilterNames =
        statusFilter != null ? [statusFilter.name] : null;

    final result = await _getInvoicesUseCase(
      companyId: companyId,
      statusFilter: statusFilterNames,
      customerId: customerId,
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

  Future<void> loadInvoices(String companyId) async {
    await _loadWithParams(
      companyId: companyId,
      statusFilter: state.statusFilter,
      customerId: state.customerId,
    );
  }

  void setFilter({
    required String companyId,
    InvoiceStatus? statusFilter,
    String? customerId,
  }) {
    emit(state.copyWith(statusFilter: statusFilter, customerId: customerId));
    _loadWithParams(
      companyId: companyId,
      statusFilter: statusFilter,
      customerId: customerId,
    );
  }

  void clearFilters(String companyId) {
    emit(state.copyWith(statusFilter: null, customerId: null));
    _loadWithParams(
      companyId: companyId,
      statusFilter: null,
      customerId: null,
    );
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