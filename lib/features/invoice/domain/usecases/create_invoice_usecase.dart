import 'package:fpdart/fpdart.dart';
import 'package:stockflow/core/error/failures.dart';
import 'package:stockflow/features/invoice/domain/repositories/invoice_repository.dart';

class CreateInvoiceUseCase {
  final InvoiceRepository repository;

  CreateInvoiceUseCase(this.repository);

  Future<Either<Failure, String>> call({
    required String customerId,
    required String createdBy,
    required List<Map<String, dynamic>> items,
    double paidNow = 0,
    String discountType = 'fixed',
    double discountValue = 0,
  }) {
    return repository.createInvoice(
      customerId: customerId,
      createdBy: createdBy,
      items: items,
      paidNow: paidNow,
      discountType: discountType,
      discountValue: discountValue,
    );
  }
}
