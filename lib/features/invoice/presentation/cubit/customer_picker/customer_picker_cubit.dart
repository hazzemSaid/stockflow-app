import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stockflow/features/customers/domain/usecases/get_customers_usecase.dart';
import 'customer_picker_state.dart';

export 'customer_picker_state.dart';

class CustomerPickerCubit extends Cubit<CustomerPickerState> {
  final GetCustomersUseCase _getCustomersUseCase;
  final String _companyId;
  Timer? _debounce;

  CustomerPickerCubit({
    required GetCustomersUseCase getCustomersUseCase,
    required String companyId,
  })  : _getCustomersUseCase = getCustomersUseCase,
        _companyId = companyId,
        super(const CustomerPickerState());

  Future<void> loadCustomers() async {
    emit(state.copyWith(status: CustomerPickerStatus.loading, clearFailure: true));

    final result = await _getCustomersUseCase(
      query: state.query.isNotEmpty ? state.query : null,
      companyId: _companyId,
    );

    result.fold(
      (failure) {
        emit(state.copyWith(
          status: CustomerPickerStatus.error,
          failure: failure,
        ));
      },
      (customers) {
        emit(
          state.copyWith(
            status: customers.isEmpty
                ? CustomerPickerStatus.empty
                : CustomerPickerStatus.success,
            customers: customers,
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
