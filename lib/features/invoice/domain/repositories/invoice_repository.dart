import 'package:fpdart/fpdart.dart';
import 'package:stockflow/core/error/failures.dart';
import 'package:stockflow/features/invoice/domain/entities/invoice.dart';

abstract class InvoiceRepository {
  Future<Either<Failure, String>> createInvoice({
    required String customerId,
    required List<Map<String, dynamic>> items,
    double paidNow = 0,
    String discountType = 'fixed',
    double discountValue = 0,
  });

  Future<Either<Failure, String>> addPayment({
    required String invoiceId,
    required double amount,
  });

  Future<Either<Failure, Invoice>> getInvoice(
    String id,
    String companyId,
  );

  Future<Either<Failure, List<Invoice>>> getInvoices({
    required String companyId,
    List<String>? statusFilter,
    String? customerId,
    int? limit,
    int? offset,
  });
}
