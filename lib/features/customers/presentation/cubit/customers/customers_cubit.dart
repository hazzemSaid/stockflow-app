import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/usecases/get_customers_usecase.dart';
import 'customers_state.dart';

export 'customers_state.dart';

const int _pageSize = 20;

class CustomersCubit extends Cubit<CustomersState> {
  final GetCustomersUseCase _getCustomersUseCase;
  Timer? _debounce;
  int _currentPage = 0;

  CustomersCubit({required GetCustomersUseCase getCustomersUseCase})
    : _getCustomersUseCase = getCustomersUseCase,
      super(const CustomersState());

  Future<void> loadCustomers() async {
    _currentPage = 0;
    emit(state.copyWith(status: CustomersStatus.loading, isLoadingMore: false));

    final result = await _getCustomersUseCase(
      query: state.query.isNotEmpty ? state.query : null,
      limit: _pageSize,
      offset: 0,
    );

    result.fold(
      (failure) {
        emit(state.copyWith(status: CustomersStatus.error, failure: failure));
      },
      (customers) {
        emit(
          state.copyWith(
            status: customers.isEmpty
                ? CustomersStatus.empty
                : CustomersStatus.success,
            customers: customers,
            totalCount: customers.length,
            hasMore: customers.length == _pageSize,
          ),
        );
      },
    );
  }

  Future<void> loadMore() async {
    if (state.isLoadingMore || !state.hasMore) return;
    emit(state.copyWith(isLoadingMore: true));

    final nextPage = _currentPage + 1;
    final nextOffset = nextPage * _pageSize;

    final result = await _getCustomersUseCase(
      query: state.query.isNotEmpty ? state.query : null,
      limit: _pageSize,
      offset: nextOffset,
    );

    result.fold(
      (_) {
        emit(state.copyWith(isLoadingMore: false));
      },
      (newCustomers) {
        _currentPage = nextPage;
        final allCustomers = [...state.customers, ...newCustomers];
        emit(
          state.copyWith(
            status: CustomersStatus.success,
            customers: allCustomers,
            totalCount: allCustomers.length,
            hasMore: newCustomers.length == _pageSize,
            isLoadingMore: false,
          ),
        );
      },
    );
  }

  void updateSearchQuery(String query) {
    emit(state.copyWith(query: query));
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 400), () {
      loadCustomers();
    });
  }

  Future<void> refresh() async {
    await loadCustomers();
  }

  @override
  Future<void> close() {
    _debounce?.cancel();
    return super.close();
  }
}
