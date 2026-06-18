import 'package:fpdart/fpdart.dart';
import 'package:stockflow/core/error/failures.dart';
import 'package:stockflow/features/invoice/domain/repositories/invoice_repository.dart';

class AddPaymentUseCase {
  final InvoiceRepository repository;

  AddPaymentUseCase(this.repository);

  Future<Either<Failure, String>> call({
    required String invoiceId,
    required double amount,
    String? createdBy,
  }) {
    return repository.addPayment(
      invoiceId: invoiceId,
      amount: amount,
      createdBy: createdBy,
    );
  }
}
