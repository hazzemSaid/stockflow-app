import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:makhzanflow/features/invoice/domain/usecases/get_invoice_usecase.dart';
import 'invoice_details_state.dart';

export 'invoice_details_state.dart';

class InvoiceDetailsCubit extends Cubit<InvoiceDetailsState> {
  final GetInvoiceUseCase _getInvoiceUseCase;

  InvoiceDetailsCubit({
    required GetInvoiceUseCase getInvoiceUseCase,
  }) : _getInvoiceUseCase = getInvoiceUseCase,
       super(InvoiceDetailsInitial());

  Future<void> loadInvoice(String id, String companyId) async {
    emit(InvoiceDetailsLoading());

    final result = await _getInvoiceUseCase(id, companyId);

    result.fold(
      (failure) => emit(InvoiceDetailsError(failure: failure)),
      (invoice) => emit(InvoiceDetailsLoaded(invoice: invoice)),
    );
  }
}
