import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stockflow/core/constants/app_strings.dart';
import 'package:stockflow/core/error/failures.dart';
import '../../../domain/usecases/create_customer_usecase.dart';
import '../../../domain/usecases/upload_customer_image_usecase.dart';
import '../../../domain/usecases/get_customer_usecase.dart';
import '../../../domain/usecases/update_customer_usecase.dart';
import 'add_edit_customer_state.dart';

export 'add_edit_customer_state.dart';

class AddEditCustomerCubit extends Cubit<AddEditCustomerState> {
  final CreateCustomerUseCase _createCustomerUseCase;
  final UploadCustomerImageUseCase _uploadImageUseCase;
  final GetCustomerUseCase? _getCustomerUseCase;
  final UpdateCustomerUseCase? _updateCustomerUseCase;
  String? _customerId;

  AddEditCustomerCubit({
    required CreateCustomerUseCase createCustomerUseCase,
    required UploadCustomerImageUseCase uploadImageUseCase,
    GetCustomerUseCase? getCustomerUseCase,
    UpdateCustomerUseCase? updateCustomerUseCase,
  }) : _createCustomerUseCase = createCustomerUseCase,
       _uploadImageUseCase = uploadImageUseCase,
       _getCustomerUseCase = getCustomerUseCase,
       _updateCustomerUseCase = updateCustomerUseCase,
       super(const AddEditCustomerState());

  Future<void> loadForEdit(String customerId) async {
    _customerId = customerId;
    emit(state.copyWith(status: AddEditCustomerStatus.loading));
    final result = await _getCustomerUseCase!(customerId);
    result.fold(
      (failure) => emit(
        state.copyWith(status: AddEditCustomerStatus.error, failure: failure),
      ),
      (customer) => emit(
        state.copyWith(
          status: AddEditCustomerStatus.initial,
          isEditMode: true,
          name: customer.name,
          nameOfficial: customer.nameOfficial ?? '',
          phone: customer.phone ?? '',
          address: customer.address ?? '',
          debtText: customer.totalDebt.toStringAsFixed(2),
          imageUploadUrl: customer.imageUrl,
        ),
      ),
    );
  }

  void updateName(String value) => emit(state.copyWith(name: value));
  void updateNameOfficial(String value) =>
      emit(state.copyWith(nameOfficial: value));
  void updatePhone(String value) => emit(state.copyWith(phone: value));
  void updateAddress(String value) => emit(state.copyWith(address: value));
  void updateDebt(String value) => emit(state.copyWith(debtText: value));

  void setImagePath(String path) {
    emit(state.copyWith(imageLocalPath: path, isImageUploading: false));
  }

  void removeImage() {
    emit(state.copyWith(imageLocalPath: null, imageUploadUrl: null));
  }

  Future<bool> save() async {
    if (state.name.trim().isEmpty) {
      emit(
        state.copyWith(
          status: AddEditCustomerStatus.error,
          failure: const ServerFailure(AppStrings.customerNameRequired),
        ),
      );
      return false;
    }

    emit(state.copyWith(status: AddEditCustomerStatus.loading));

    String? imageUrl;

    final localPath = state.imageLocalPath;
    if (localPath != null) {
      emit(state.copyWith(isImageUploading: true));
      final uploadResult = await _uploadImageUseCase(localPath);
      final uploadError = uploadResult.fold(
        (failure) {
          emit(
            state.copyWith(
              status: AddEditCustomerStatus.error,
              failure: failure,
              isImageUploading: false,
            ),
          );
          return failure;
        },
        (url) {
          imageUrl = url;
          return null;
        },
      );
      if (uploadError != null) return false;
    } else {
      imageUrl = state.imageUploadUrl;
    }

    final debt = double.tryParse(state.debtText) ?? 0;

    if (state.isEditMode && _updateCustomerUseCase != null) {
      final result = await _updateCustomerUseCase(
        id: _customerId!,
        name: state.name,
        nameOfficial: state.nameOfficial.isNotEmpty ? state.nameOfficial : null,
        phone: state.phone.isNotEmpty ? state.phone : null,
        address: state.address.isNotEmpty ? state.address : null,
        imageUrl: imageUrl,
      );
      return result.fold(
        (failure) {
          emit(
            state.copyWith(
              status: AddEditCustomerStatus.error,
              failure: failure,
            ),
          );
          return false;
        },
        (_) {
          emit(
            state.copyWith(
              status: AddEditCustomerStatus.success,
              successMessage: AppStrings.customerSaveSuccess,
            ),
          );
          return true;
        },
      );
    } else {
      final result = await _createCustomerUseCase(
        name: state.name,
        nameOfficial: state.nameOfficial.isNotEmpty ? state.nameOfficial : null,
        phone: state.phone.isNotEmpty ? state.phone : null,
        address: state.address.isNotEmpty ? state.address : null,
        totalDebt: debt,
        imageUrl: imageUrl,
      );
      return result.fold(
        (failure) {
          emit(
            state.copyWith(
              status: AddEditCustomerStatus.error,
              failure: failure,
            ),
          );
          return false;
        },
        (_) {
          emit(
            state.copyWith(
              status: AddEditCustomerStatus.success,
              successMessage: AppStrings.customerAddSuccess,
            ),
          );
          return true;
        },
      );
    }
  }

  void resetStatus() {
    emit(
      state.copyWith(
        status: AddEditCustomerStatus.initial,
        failure: null,
        successMessage: null,
      ),
    );
  }
}
