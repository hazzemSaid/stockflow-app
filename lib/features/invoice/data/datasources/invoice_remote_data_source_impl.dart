import 'package:flutter/foundation.dart';
import 'package:fpdart/fpdart.dart';
import 'package:makhzanflow/core/error/failures.dart';
import 'package:makhzanflow/features/invoice/data/datasources/invoice_remote_data_source.dart';
import 'package:makhzanflow/features/invoice/data/models/add_payment_dto.dart';
import 'package:makhzanflow/features/invoice/data/models/invoice_create_dto.dart';
import 'package:makhzanflow/features/invoice/data/models/invoice_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as supabase;

class InvoiceRemoteDataSourceImpl implements InvoiceRemoteDataSource {
  final supabase.SupabaseClient _supabaseClient;

  InvoiceRemoteDataSourceImpl({required supabase.SupabaseClient supabaseClient})
    : _supabaseClient = supabaseClient;

  @override
  Future<Either<Failure, String>> createInvoice(
    InvoiceCreateDto inputDto,
  ) async {
    try {
      final params = inputDto.toJson();
      final response = await _supabaseClient.rpc(
        'create_invoice_full',
        params: params,
      );
      final invoiceId = response?.toString();
      if (invoiceId == null || invoiceId.isEmpty) {
        return Left(ServerFailure('لم يتم استلام معرف الفاتورة من الخادم'));
      }
      return Right(invoiceId);
    } on supabase.PostgrestException catch (error) {
      final items = inputDto.items;
      return Left(ServerFailure(_translateError(error.message, items)));
    } catch (e) {
      return Left(ServerFailure('حدث خطأ غير متوقع: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, String>> addPayment(AddPaymentDto inputDto) async {
    try {
      final params = inputDto.toJson();
      final response = await _supabaseClient.rpc('add_payment', params: params);
      final paymentId = response?.toString();
      if (paymentId == null || paymentId.isEmpty) {
        return Left(ServerFailure('لم يتم استلام معرف الدفعة من الخادم'));
      }
      return Right(paymentId);
    } on supabase.PostgrestException catch (error) {
      debugPrint('[addPayment] PostgrestException: ${error.message}');
      return Left(ServerFailure(_translatePaymentError(error.message)));
    } catch (e, stack) {
      debugPrint('[addPayment] Unexpected error: $e\n$stack');
      return Left(ServerFailure('حدث خطأ غير متوقع: ${e.toString()}'));
    }
  }

  String _translatePaymentError(String message) {
    if (message.contains('Permission denied') ||
        message.contains('Access denied') ||
        message.contains('row-level security')) {
      return 'ليس لديك صلاحية تنفيذ هذا الإجراء';
    }
    if (message.contains('No active company selected')) {
      return 'لم يتم تحديد شركة';
    }
    if (message.contains('Payment amount must be greater than 0')) {
      return 'يجب أن يكون مبلغ الدفعة أكبر من 0';
    }
    if (message.contains('Invoice not found')) {
      return 'الفاتورة غير موجودة';
    }
    if (message.contains('Payment exceeds remaining amount')) {
      return 'المبلغ يتجاوز المبلغ المتبقي';
    }
    if (message.contains('duplicate key')) {
      return 'بيانات مكررة';
    }
    if (message.contains('foreign key constraint')) {
      return 'العامل أو العميل المحدد غير موجود';
    }
    return 'حدث خطأ غير متوقع';
  }

  String _translateError(String message, [List<Map<String, dynamic>>? items]) {
    if (message.contains('Permission denied') ||
        message.contains('Access denied') ||
        message.contains('row-level security')) {
      return 'ليس لديك صلاحية تنفيذ هذا الإجراء';
    }
    if (message.contains('No active company selected')) {
      return 'لم يتم تحديد شركة';
    }
    if (message.contains('Customer not found')) {
      return 'العميل غير موجود في هذه الشركة';
    }
    if (message.contains('Invoice must contain at least one item')) {
      return 'يجب أن تحتوي الفاتورة على عنصر واحد على الأقل';
    }
    if (message.contains('Paid amount cannot be negative')) {
      return 'المبلغ المدفوع لا يمكن أن يكون سالباً';
    }
    if (message.contains('Payment cannot exceed invoice total')) {
      return 'المبلغ المدفوع لا يمكن أن يتجاوز إجمالي الفاتورة';
    }
    if (message.contains('Discount cannot exceed')) {
      return 'الخصم لا يمكن أن يتجاوز إجمالي قيمة المنتجات';
    }
    if (message.contains('Insufficient stock')) {
      final productId = _extractUuid(message);
      final name = _productNameById(productId, items);
      return 'المخزون غير كافٍ للمنتج${name != null ? ' ($name)' : ''}';
    }
    if (message.contains('duplicate key')) {
      return 'بيانات مكررة — هذا العنصر موجود بالفعل';
    }
    if (message.contains('foreign key constraint')) {
      return 'العميل أو المنتج المحدد غير موجود';
    }
    if (message.contains('violates')) {
      return 'عملية غير مصرح بها';
    }
    if (message.contains('Could not find')) {
      return 'المورد المطلوب غير موجود';
    }
    return 'حدث خطأ غير متوقع';
  }

  String? _extractUuid(String message) {
    final regex = RegExp(
      r'[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}',
      caseSensitive: false,
    );
    final match = regex.firstMatch(message);
    return match?.group(0);
  }

  String? _productNameById(
    String? productId,
    List<Map<String, dynamic>>? items,
  ) {
    if (productId == null || items == null) return null;
    for (final item in items) {
      if (item['product_id'] == productId) {
        return item['product_name'] as String?;
      }
    }
    return null;
  }

  @override
  Future<Either<Failure, InvoiceModel>> getInvoice(
    String id,
    String companyId,
  ) async {
    try {
      final response = await _supabaseClient.rpc(
        'get_invoice_by_id',
        params: {'p_invoice_id': id},
      );
      return Right(InvoiceModel.fromJson(response as Map<String, dynamic>));
    } on supabase.PostgrestException catch (error) {
      if (error.message.contains('Invoice not found')) {
        return Left(ServerFailure('الفاتورة غير موجودة'));
      }
      return Left(ServerFailure(error.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<InvoiceModel>>> getInvoices({
    required String companyId,
    List<String>? statusFilter,
    String? customerId,
    int? limit,
    int? offset,
  }) async {
    debugPrint(
      '[getInvoices] statusFilter: $statusFilter, customerId: $customerId, limit: $limit, offset: $offset',
    );
    try {
      dynamic query = _supabaseClient
          .from('invoices')
          .select('''
          *,
          customers!inner(name)
        ''')
          .eq('company_id', companyId);

      if (statusFilter != null && statusFilter.isNotEmpty) {
        query = query.inFilter('payment_status', statusFilter);
      }

      if (customerId != null && customerId.isNotEmpty) {
        query = query.eq('customer_id', customerId);
      }

      query = query.order('created_at', ascending: false);

      if (limit != null && offset != null) {
        query = query.range(offset, offset + limit - 1);
      }

      final response = await query;
      final list = (response as List<dynamic>)
          .map((e) => InvoiceModel.fromJson(e as Map<String, dynamic>))
          .toList();
      debugPrint('[getInvoices] response count: ${list.length}');
      return Right(list);
    } on supabase.PostgrestException catch (error) {
      debugPrint('[getInvoices] PostgrestException: ${error.message}');
      return Left(ServerFailure(error.message));
    } catch (e) {
      debugPrint('[getInvoices] error: $e');
      return Left(ServerFailure(e.toString()));
    }
  }
}
