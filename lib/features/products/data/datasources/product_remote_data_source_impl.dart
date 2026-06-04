import 'dart:io';
import 'package:fpdart/fpdart.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../domain/entities/product_input.dart';
import '../models/product_model.dart';
import '../models/inventory_movement_model.dart';
import 'product_remote_data_source.dart';

class ProductRemoteDataSourceImpl implements ProductRemoteDataSource {
  final SupabaseClient _client;

  ProductRemoteDataSourceImpl(this._client);

  @override
  TaskEither<String, List<ProductModel>> listProducts({
    String? query,
    int? limit,
    int? offset,
    String? sortColumn,
    bool ascending = false,
  }) {
    return TaskEither.tryCatch(() async {
      var request = _client.from('products').select();

      if (query != null && query.trim().isNotEmpty) {
        request = request.ilike('name', '%$query%');
      }

      final orderColumn = sortColumn ?? 'created_at';
      var orderedRequest = request.order(orderColumn, ascending: ascending);

      if (limit != null && offset != null) {
        orderedRequest = orderedRequest.range(offset, offset + limit - 1);
      }

      final data = await orderedRequest as List<dynamic>;
      return data
          .map((json) => ProductModel.fromJson(json as Map<String, dynamic>))
          .toList();
    }, (error, stackTrace) => error.toString());
  }

  @override
  TaskEither<String, ProductModel> getProduct(String id) {
    return TaskEither.tryCatch(() async {
      final data = await _client
          .from('products')
          .select()
          .filter('id', 'eq', id)
          .single();
      return ProductModel.fromJson(data);
    }, (error, stackTrace) => error.toString());
  }

  @override
  TaskEither<String, ProductModel> createProduct(
    ProductInput input,
    String userId,
  ) {
    return TaskEither.tryCatch(() async {
      final model = ProductModel(
        id: '',
        name: input.name,
        imageUrl: input.imageUrl,
        quantity: input.quantity,
        price: input.price,
        createdBy: userId,
        expirationDate: input.expirationDate,
      );
      final data = model.toInsertJson();
      data.remove('id');
      final response = await _client
          .from('products')
          .insert(data)
          .select()
          .single();

      if (input.quantity > 0) {
        await _client.from('inventory_logs').insert({
          'product_id': response['id'],
          'type': 'in',
          'quantity': input.quantity,
          'created_by': userId,
        });
      }

      return ProductModel.fromJson(response);
    }, (error, stackTrace) => error.toString());
  }

  @override
  TaskEither<String, ProductModel> updateProduct(
    String id,
    ProductInput input,
    String userId,
  ) {
    return TaskEither.tryCatch(() async {
      final currentProduct = await _client
          .from('products')
          .select('quantity')
          .filter('id', 'eq', id)
          .single();
      final currentQty = currentProduct['quantity'] as int;

      final model = ProductModel(
        id: id,
        name: input.name,
        imageUrl: input.imageUrl,
        quantity: input.quantity,
        price: input.price,
        createdBy: '',
        expirationDate: input.expirationDate,
      );
      final response = await _client
          .from('products')
          .update(model.toUpdateJson())
          .filter('id', 'eq', id)
          .select()
          .single();

      final delta = input.quantity - currentQty;
      if (delta != 0) {
        await _client.from('inventory_logs').insert({
          'product_id': id,
          'type': delta > 0 ? 'in' : 'out',
          'quantity': delta.abs(),
          'created_by': userId,
        });
      }

      return ProductModel.fromJson(response);
    }, (error, stackTrace) => error.toString());
  }

  @override
  TaskEither<String, void> deleteProduct(String id) {
    return TaskEither.tryCatch(() async {
      await _client.from('products').delete().filter('id', 'eq', id);
    }, (error, stackTrace) => error.toString());
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
    }, (error, stackTrace) => error.toString());
  }

  @override
  TaskEither<String, Map<String, dynamic>> updateQuantityTransaction({
    required String productId,
    required int newQuantity,
    required String type,
    required int delta,
    String? note,
    required String userId,
  }) {
    return TaskEither.tryCatch(() async {
      final currentProduct = await _client
          .from('products')
          .select('quantity')
          .filter('id', 'eq', productId)
          .single();
      final currentQty = currentProduct['quantity'] as int;

      final finalQuantity = type == 'in'
          ? currentQty + delta
          : currentQty - delta;

      if (finalQuantity < 0) {
        throw Exception('لا يمكن أن تصبح الكمية أقل من صفر');
      }

      await _client
          .from('products')
          .update({'quantity': finalQuantity})
          .filter('id', 'eq', productId);

      await _client.from('inventory_logs').insert({
        'product_id': productId,
        'type': type,
        'quantity': delta,
        if (note != null) 'note': note,
        'created_by': userId,
      });

      return {'success': true, 'new_quantity': finalQuantity};
    }, (error, stackTrace) => error.toString());
  }

  @override
  TaskEither<String, List<InventoryMovementModel>> getMovements(
    String productId,
  ) {
    return TaskEither.tryCatch(() async {
      final data =
          await _client
                  .from('inventory_logs')
                  .select()
                  .filter('product_id', 'eq', productId)
                  .order('created_at', ascending: false)
                  .limit(20)
              as List<dynamic>;
      return data
          .map(
            (json) =>
                InventoryMovementModel.fromJson(json as Map<String, dynamic>),
          )
          .toList();
    }, (error, stackTrace) => error.toString());
  }
}
