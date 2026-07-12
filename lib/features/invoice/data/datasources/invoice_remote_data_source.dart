import 'package:fpdart/fpdart.dart';
import 'package:makhzanflow/core/error/failures.dart';
import 'package:makhzanflow/features/invoice/data/models/add_payment_dto.dart';
import 'package:makhzanflow/features/invoice/data/models/invoice_create_dto.dart';
import 'package:makhzanflow/features/invoice/data/models/invoice_model.dart';

abstract class InvoiceRemoteDataSource {
  Future<Either<Failure, String>> createInvoice(
    InvoiceCreateDto inputDto,
  );

  Future<Either<Failure, String>> addPayment(
    AddPaymentDto inputDto,
  );

  Future<Either<Failure, InvoiceModel>> getInvoice(
    String id,
    String companyId,
  );

  Future<Either<Failure, List<InvoiceModel>>> getInvoices({
    required String companyId,
    List<String>? statusFilter,
    String? customerId,
    int? limit,
    int? offset,
  });
}
