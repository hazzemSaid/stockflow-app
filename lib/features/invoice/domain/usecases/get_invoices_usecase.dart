import 'package:fpdart/fpdart.dart';
import 'package:stockflow/core/error/failures.dart';
import 'package:stockflow/features/invoice/domain/entities/invoice.dart';
import 'package:stockflow/features/invoice/domain/repositories/invoice_repository.dart';

class GetInvoicesUseCase {
  final InvoiceRepository repository;

  GetInvoicesUseCase(this.repository);

  Future<Either<Failure, List<Invoice>>> call({
    required String companyId,
    List<String>? statusFilter,
    String? customerId,
    int? limit,
    int? offset,
  }) {
    return repository.getInvoices(
      companyId: companyId,
      statusFilter: statusFilter,
      customerId: customerId,
      limit: limit,
      offset: offset,
    );
  }
}
