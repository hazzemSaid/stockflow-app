import 'package:fpdart/fpdart.dart';
import 'package:stockflow/core/error/failures.dart';
import 'package:stockflow/features/invoice/domain/entities/Invoice.dart';
import 'package:stockflow/features/invoice/domain/repositories/invoice_repository.dart';

class GetInvoicesUseCase {
  final InvoiceRepository repository;

  GetInvoicesUseCase(this.repository);

  Future<Either<Failure, List<Invoice>>> call({
    List<String>? statusFilter,
    String? customerId,
  }) {
    return repository.getInvoices(
      statusFilter: statusFilter,
      customerId: customerId,
    );
  }
}
