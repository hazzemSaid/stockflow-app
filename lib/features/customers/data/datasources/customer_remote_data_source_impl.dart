import 'dart:io';
import 'package:fpdart/fpdart.dart';
import 'package:stockflow/core/error/failures.dart';
import 'package:stockflow/features/customers/data/datasources/customer_remote_data_source.dart';
import 'package:stockflow/features/customers/data/models/customer_model.dart';
import 'package:stockflow/features/customers/data/models/customer_filter_counts_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as supabase;

class CustomerRemoteDataSourceImpl implements CustomerRemoteDataSource {
  final supabase.SupabaseClient _supabaseClient;

  CustomerRemoteDataSourceImpl({
    required supabase.SupabaseClient supabaseClient,
  }) : _supabaseClient = supabaseClient;

  @override
  Future<Either<Failure, CustomerModel>> createCustomer({
    required String name,
    String? nameOfficial,
    String? phone,
    String? address,
    double totalDebt = 0,
    String? imageUrl,
    required String companyId,
  }) async {
    try {
      final customerId = await _supabaseClient.rpc(
        'create_customer_full',
        params: {
          'p_name': name,
          'p_name_official': nameOfficial,
          'p_phone': phone,
          'p_address': address,
          'p_total_debt': totalDebt,
          'p_image_url': imageUrl,
        },
      ) as String;
      return getCustomer(customerId, companyId);
    } on supabase.PostgrestException catch (error) {
      if (error.code == '23505') {
        return Left(ServerFailure('هذا الاسم موجود مسبقاً'));
      }
      return Left(ServerFailure(error.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, CustomerModel>> getCustomer(String id, String companyId) async {
    try {
      final response = await _supabaseClient
          .from('customers')
          .select('*, invoices(*), payments(*)')
          .filter('id', 'eq', id)
          .filter('company_id', 'eq', companyId)
          .single();
      return Right(CustomerModel.fromJson(response));
    } on supabase.PostgrestException catch (error) {
      if (error.code == 'PGRST116') {
        return Left(ServerFailure('العميل غير موجود'));
      }
      return Left(ServerFailure(error.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<CustomerModel>>> listCustomers({
    String? query,
    String? filter,
    int? limit,
    int? offset,
    required String companyId,
  }) async {
    try {
      final response =
          await _supabaseClient.rpc(
                'get_customers_with_aggregates',
                params: {
                  'search_query': query,
                  'filter_type': filter ?? 'all',
                  'page_limit': limit ?? 20,
                  'page_offset': offset ?? 0,
                },
              )
              as List<dynamic>;
      final customers = response
          .map((json) => CustomerModel.fromJson(json as Map<String, dynamic>))
          .toList();
      return Right(customers);
    } on supabase.PostgrestException catch (error) {
      return Left(ServerFailure(error.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, CustomerFilterCountsModel>> getFilterCounts({
    String? query,
    required String companyId,
  }) async {
    try {
      final response =
          await _supabaseClient.rpc(
                'get_customer_filter_counts',
                params: {
                  'search_query': query,
                },
              )
              as List<dynamic>;

      if (response.isEmpty) {
        return const Right(
          CustomerFilterCountsModel(
            totalCount: 0,
            paidCount: 0,
            partialCount: 0,
            deferredCount: 0,
            totalDebtSum: 0,
          ),
        );
      }

      final counts = CustomerFilterCountsModel.fromJson(
        response.first as Map<String, dynamic>,
      );
      return Right(counts);
    } on supabase.PostgrestException catch (error) {
      return Left(ServerFailure(error.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, CustomerModel>> updateCustomer({
    required String id,
    required String name,
    String? nameOfficial,
    String? phone,
    String? address,
    String? imageUrl,
    required String companyId,
  }) async {
    try {
      final body = <String, dynamic>{'name': name};
      if (nameOfficial != null) body['name_official'] = nameOfficial;
      if (phone != null) body['phone'] = phone;
      if (address != null) body['address'] = address;
      body['image_url'] = imageUrl;

      final response = await _supabaseClient
          .from('customers')
          .update(body)
          .filter('id', 'eq', id)
          .filter('company_id', 'eq', companyId)
          .select('*, invoices(*), payments(*)')
          .single();
      return Right(CustomerModel.fromJson(response));
    } on supabase.PostgrestException catch (error) {
      if (error.code == 'PGRST116') {
        return Left(ServerFailure('العميل غير موجود'));
      }
      return Left(ServerFailure(error.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, String>> uploadImage(String filePath) async {
    try {
      final fileName =
          '${DateTime.now().millisecondsSinceEpoch}_${filePath.split(Platform.pathSeparator).last}';
      final file = File(filePath);
      await _supabaseClient.storage
          .from('customer-images')
          .upload(
            fileName,
            file,
            fileOptions: const supabase.FileOptions(
              contentType: 'image/jpeg',
              upsert: true,
            ),
          );
      final publicUrl = _supabaseClient.storage
          .from('customer-images')
          .getPublicUrl(fileName);
      return Right(publicUrl);
    } on supabase.StorageException catch (error) {
      if (error.statusCode == '409') {
        return Left(ServerFailure('الصورة موجودة مسبقاً'));
      }
      return Left(ServerFailure(error.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
