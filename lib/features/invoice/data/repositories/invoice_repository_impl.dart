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
    required String createdBy,
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
      createdBy: createdBy,
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
    String? createdBy,
  }) async {
    final dto = AddPaymentDto(
      invoiceId: invoiceId,
      amount: amount,
      createdBy: createdBy,
    );
    return dataSource.addPayment(dto);
  }

  @override
  Future<Either<Failure, Invoice>> getInvoice(String id) async {
    final result = await dataSource.getInvoice(id);
    return result.map((model) => model.toEntity());
  }

  @override
  Future<Either<Failure, List<Invoice>>> getInvoices({
    List<String>? statusFilter,
    String? customerId,
  }) async {
    final result = await dataSource.getInvoices(
      statusFilter: statusFilter,
      customerId: customerId,
    );
    return result.map((models) => models.map((m) => m.toEntity()).toList());
  }
}
