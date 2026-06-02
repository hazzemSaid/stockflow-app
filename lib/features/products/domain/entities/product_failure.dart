import 'package:equatable/equatable.dart';

class ProductFailure extends Equatable {
  final String message;
  final String? userMessage;

  const ProductFailure({
    required this.message,
    this.userMessage,
  });

  @override
  List<Object?> get props => [message, userMessage];

  static String mapToArabic(String errorKey) {
    switch (errorKey) {
      case 'load_error':
        return 'حدث خطأ أثناء تحميل المنتجات';
      case 'save_error':
        return 'حدث خطأ أثناء حفظ المنتج';
      case 'delete_error':
        return 'حدث خطأ أثناء حذف المنتج';
      case 'image_error':
        return 'حدث خطأ أثناء رفع الصورة';
      case 'quantity_error':
        return 'حدث خطأ أثناء تحديث الكمية';
      case 'negative_quantity':
        return 'لا يمكن أن تصبح الكمية أقل من صفر';
      case 'not_found':
        return 'المنتج غير موجود';
      case 'validation_error':
        return 'يرجى التحقق من البيانات المدخلة';
      default:
        return 'حدث خطأ غير متوقع';
    }
  }
}
