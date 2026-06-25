import 'package:fpdart/fpdart.dart';
import 'package:stockflow/core/error/failures.dart';
import 'package:stockflow/features/invoice/data/datasources/invoice_remote_data_source.dart';
import 'package:stockflow/features/invoice/data/models/add_payment_dto.dart';
import 'package:stockflow/features/invoice/data/models/invoice_create_dto.dart';
import 'package:stockflow/features/invoice/domain/entities/invoice.dart';
import 'package:stockflow/features/invoice/domain/repositories/invoice_repository.dart';

class InvoiceRepositoryImpl implements InvoiceRepository {
  final InvoiceRemoteDataSource dataSource;

  InvoiceRepositoryImpl(this.dataSource);

  @override
  Future<Either<Failure, String>> createInvoice({
    required String customerId,
    required List<Map<String, dynamic>> items,
    double paidNow = 0,
    String discountType = 'fixed',
    double discountValue = 0,
  }) async {
    if (items.isEmpty) {
      return Left(ServerFailure('يرجى إضافة منتج واحد على الأقل'));
    }
    final dto = InvoiceCreateDto(
      customerId: customerId,
      items: items,
      paidNow: paidNow,
      discountType: discountType,
      discountValue: discountValue,
    );
    return dataSource.createInvoice(dto);
  }

  @override
  Future<Either<Failure, String>> addPayment({
    required String invoiceId,
    required double amount,
  }) async {
    final dto = AddPaymentDto(
      invoiceId: invoiceId,
      amount: amount,
    );
    return dataSource.addPayment(dto);
  }

  @override
  Future<Either<Failure, Invoice>> getInvoice(String id, String companyId) async {
    final result = await dataSource.getInvoice(id, companyId);
    return result.map((model) => model.toEntity());
  }

  @override
  Future<Either<Failure, List<Invoice>>> getInvoices({
    required String companyId,
    List<String>? statusFilter,
    String? customerId,
    int? limit,
    int? offset,
  }) async {
    final result = await dataSource.getInvoices(
      companyId: companyId,
      statusFilter: statusFilter,
      customerId: customerId,
      limit: limit,
      offset: offset,
    );
    return result.map((models) => models.map((m) => m.toEntity()).toList());
  }
}
