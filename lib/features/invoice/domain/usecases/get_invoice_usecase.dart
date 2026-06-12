import 'package:fpdart/fpdart.dart';
import 'package:stockflow/core/error/failures.dart';
import 'package:stockflow/features/invoice/domain/entities/invoice.dart';
import 'package:stockflow/features/invoice/domain/repositories/invoice_repository.dart';

class GetInvoiceUseCase {
  final InvoiceRepository repository;

  GetInvoiceUseCase(this.repository);

  Future<Either<Failure, Invoice>> call(String id) {
    return repository.getInvoice(id);
  }
}
