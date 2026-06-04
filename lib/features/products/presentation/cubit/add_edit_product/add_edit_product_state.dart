import 'package:equatable/equatable.dart';
import '../../../domain/entities/product_input.dart';

enum AddEditProductStatus { initial, loading, uploading, success, error }

class AddEditProductState extends Equatable {
  final AddEditProductStatus status;
  final ProductInput input;
  final String priceText;
  final String quantityText;
  final DateTime? expirationDate;
  final String? imageLocalPath;
  final String? imageUploadUrl;
  final bool isImageUploading;
  final String? errorMessage;
  final String? successMessage;
  final bool isEditMode;

  const AddEditProductState({
    this.status = AddEditProductStatus.initial,
    this.input = const ProductInput(
      name: '', price: 0, quantity: 0,
    ),
    this.priceText = '',
    this.quantityText = '',
    this.expirationDate,
    this.imageLocalPath,
    this.imageUploadUrl,
    this.isImageUploading = false,
    this.errorMessage,
    this.successMessage,
    this.isEditMode = false,
  });

  AddEditProductState copyWith({
    AddEditProductStatus? status,
    ProductInput? input,
    String? priceText,
    String? quantityText,
    DateTime? expirationDate,
    String? imageLocalPath,
    String? imageUploadUrl,
    bool? isImageUploading,
    String? errorMessage,
    String? successMessage,
    bool? isEditMode,
  }) {
    return AddEditProductState(
      status: status ?? this.status,
      input: input ?? this.input,
      priceText: priceText ?? this.priceText,
      quantityText: quantityText ?? this.quantityText,
      expirationDate: expirationDate ?? this.expirationDate,
      imageLocalPath: imageLocalPath ?? this.imageLocalPath,
      imageUploadUrl: imageUploadUrl ?? this.imageUploadUrl,
      isImageUploading: isImageUploading ?? this.isImageUploading,
      errorMessage: errorMessage ?? this.errorMessage,
      successMessage: successMessage ?? this.successMessage,
      isEditMode: isEditMode ?? this.isEditMode,
    );
  }

  @override
  List<Object?> get props => [
    status,
    input,
    priceText,
    quantityText,
    expirationDate,
    imageLocalPath,
    imageUploadUrl,
    isImageUploading,
    errorMessage,
    successMessage,
    isEditMode,
  ];
}
