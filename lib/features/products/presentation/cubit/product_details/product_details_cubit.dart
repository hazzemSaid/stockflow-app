import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/usecases/get_product_usecase.dart';
import '../../../domain/usecases/delete_product_usecase.dart';
import '../../../domain/usecases/update_product_quantity_usecase.dart';
import '../../../domain/usecases/get_inventory_movements_usecase.dart';
import 'product_details_state.dart';

export 'product_details_state.dart';

class ProductDetailsCubit extends Cubit<ProductDetailsState> {
  final GetProductUseCase _getProductUseCase;
  final DeleteProductUseCase _deleteProductUseCase;
  final UpdateProductQuantityUseCase? _updateQuantityUseCase;
  final GetInventoryMovementsUseCase? _getMovementsUseCase;
  String _companyId = '';

  ProductDetailsCubit({
    required GetProductUseCase getProductUseCase,
    required DeleteProductUseCase deleteProductUseCase,
    UpdateProductQuantityUseCase? updateQuantityUseCase,
    GetInventoryMovementsUseCase? getMovementsUseCase,
  })  : _getProductUseCase = getProductUseCase,
        _deleteProductUseCase = deleteProductUseCase,
        _updateQuantityUseCase = updateQuantityUseCase,
        _getMovementsUseCase = getMovementsUseCase,
        super(const ProductDetailsState());

  Future<void> loadProduct(String id, String companyId) async {
    _companyId = companyId;
    emit(state.copyWith(status: ProductDetailsStatus.loading));

    final result = await _getProductUseCase(id, companyId).run();
    result.fold(
      (error) => emit(state.copyWith(
        status: ProductDetailsStatus.error,
        errorMessage: error,
      )),
      (product) {
        emit(state.copyWith(
          status: ProductDetailsStatus.success,
          product: product,
        ));
        _loadMovements(product.id);
      },
    );
  }

  Future<void> _loadMovements(String productId) async {
    if (_getMovementsUseCase == null) return;
    final result = await _getMovementsUseCase(productId, _companyId).run();
    result.fold(
      (_) {},
      (movements) => emit(state.copyWith(recentMovements: movements)),
    );
  }

  Future<bool> deleteProduct(String id, String companyId) async {
    _companyId = companyId;
    emit(state.copyWith(isDeleting: true));
    final result = await _deleteProductUseCase(id, companyId).run();
    return result.fold(
      (error) {
        emit(state.copyWith(
          isDeleting: false,
          errorMessage: error,
        ));
        return false;
      },
      (_) {
        emit(state.copyWith(isDeleting: false));
        return true;
      },
    );
  }

  Future<bool> updateQuantity({
    required String productId,
    required int delta,
    String? note,
    required String userId,
    required String companyId,
    QuantityAction action = QuantityAction.add,
  }) async {
    _companyId = companyId;
    if (_updateQuantityUseCase == null) return false;

    emit(state.copyWith(isUpdatingQuantity: true));
    final result = await _updateQuantityUseCase(
      productId: productId,
      delta: delta,
      note: note,
      userId: userId,
      companyId: companyId,
    ).run();

    return result.fold(
      (error) {
        emit(state.copyWith(
          isUpdatingQuantity: false,
          errorMessage: error,
        ));
        return false;
      },
      (product) {
        emit(state.copyWith(
          isUpdatingQuantity: false,
          product: product,
        ));
        _loadMovements(productId);
        return true;
      },
    );
  }
}
