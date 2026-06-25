import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/usecases/get_customer_usecase.dart';
import 'customer_details_state.dart';

export 'customer_details_state.dart';

class CustomerDetailsCubit extends Cubit<CustomerDetailsState> {
  final GetCustomerUseCase _getCustomerUseCase;

  CustomerDetailsCubit({
    required GetCustomerUseCase getCustomerUseCase,
  }) : _getCustomerUseCase = getCustomerUseCase,
       super(const CustomerDetailsState());

  Future<void> loadCustomer(String id, String companyId) async {
    emit(state.copyWith(status: CustomerDetailsStatus.loading));

    final result = await _getCustomerUseCase(id, companyId);
    result.fold(
      (failure) => emit(state.copyWith(
        status: CustomerDetailsStatus.error,
        failure: failure,
      )),
      (customer) => emit(state.copyWith(
        status: CustomerDetailsStatus.success,
        customer: customer,
      )),
    );
  }
}
