import 'dart:io';
import 'package:fpdart/fpdart.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/error/error_handler.dart';
import '../../domain/entities/product_input.dart';
import '../models/product_model.dart';
import '../models/inventory_movement_model.dart';
import 'product_remote_data_source.dart';

class ProductRemoteDataSourceImpl implements ProductRemoteDataSource {
  final SupabaseClient _client;

  ProductRemoteDataSourceImpl(this._client);

  TaskEither<String, T> _rpc<T>(String name, {Map<String, dynamic>? params}) {
    return TaskEither.tryCatch(
      () async => await _client.rpc(name, params: params) as T,
      (error, stackTrace) => handleError(error, stackTrace),
    );
  }

  @override
  TaskEither<String, List<ProductModel>> listProducts({
    required String companyId,
    String? query,
    int? limit,
    int? offset,
    String? sortColumn,
    bool ascending = false,
  }) {
    return _rpc<List>(
      'list_products',
      params: {
        'p_company_id': companyId,
        if (query != null && query.trim().isNotEmpty) 'p_query': query,
        if (limit != null) 'p_limit': limit,
        if (offset != null) 'p_offset': offset,
        if (sortColumn != null) 'p_sort_column': sortColumn,
        'p_ascending': ascending,
      },
    ).map(
      (data) => data
          .map((json) => ProductModel.fromJson(json as Map<String, dynamic>))
          .toList(),
    );
  }

  @override
  TaskEither<String, ProductModel> getProduct(String id, String companyId) {
    return _rpc<Map<String, dynamic>>(
      'get_product',
      params: {'p_product_id': id, 'p_company_id': companyId},
    ).map((json) => ProductModel.fromJson(json));
  }

  @override
  TaskEither<String, ProductModel> createProduct(
    ProductInput input,
    String userId,
    String companyId,
  ) {
    final expDate = input.expirationDate;
    return _rpc<Map<String, dynamic>>(
      'create_product',
      params: {
        'p_name': input.name,
        if (input.imageUrl != null) 'p_image_url': input.imageUrl,
        'p_quantity': input.quantity,
        'p_price': input.price,
        if (expDate != null) 'p_expiration_date': expDate.toIso8601String(),
        'p_company_id': companyId,
      },
    ).map((json) => ProductModel.fromJson(json));
  }

  @override
  TaskEither<String, ProductModel> updateProduct(
    String id,
    ProductInput input,
    String userId,
    String companyId,
  ) {
    final expDate = input.expirationDate;
    return _rpc<Map<String, dynamic>>(
      'update_product',
      params: {
        'p_product_id': id,
        'p_name': input.name,
        if (input.imageUrl != null) 'p_image_url': input.imageUrl,
        'p_quantity': input.quantity,
        'p_price': input.price,
        if (expDate != null) 'p_expiration_date': expDate.toIso8601String(),
        'p_company_id': companyId,
      },
    ).map((json) => ProductModel.fromJson(json));
  }

  @override
  TaskEither<String, void> deleteProduct(String id, String companyId) {
    return _rpc<void>(
      'delete_product',
      params: {'p_product_id': id, 'p_company_id': companyId},
    );
  }

  @override
  TaskEither<String, String> uploadImage(String filePath) {
    return TaskEither.tryCatch(() async {
      final fileName =
          '${DateTime.now().millisecondsSinceEpoch}_${filePath.split(Platform.pathSeparator).last}';
      final file = File(filePath);
      await _client.storage
          .from('product-images')
          .upload(
            fileName,
            file,
            fileOptions: const FileOptions(
              contentType: 'image/jpeg',
              upsert: true,
            ),
          );
      final publicUrl = _client.storage
          .from('product-images')
          .getPublicUrl(fileName);
      return publicUrl;
    }, (error, stackTrace) => handleError(error, stackTrace));
  }

  @override
  TaskEither<String, Map<String, dynamic>> updateQuantityTransaction({
    required String productId,
    required int newQuantity,
    required String type,
    required int delta,
    String? note,
    required String userId,
    required String companyId,
  }) {
    return _rpc<Map<String, dynamic>>(
      'update_product_quantity',
      params: {
        'p_product_id': productId,
        'p_type': type,
        'p_delta': delta,
        if (note != null) 'p_note': note,
        'p_company_id': companyId,
      },
    );
  }

  @override
  TaskEither<String, List<InventoryMovementModel>> getMovements(
    String productId,
    String companyId,
  ) {
    return _rpc<List>(
      'get_product_movements',
      params: {'p_product_id': productId, 'p_company_id': companyId},
    ).map(
      (data) => data
          .map(
            (json) =>
                InventoryMovementModel.fromJson(json as Map<String, dynamic>),
          )
          .toList(),
    );
  }
}
