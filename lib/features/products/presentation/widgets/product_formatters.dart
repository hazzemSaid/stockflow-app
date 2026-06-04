import 'package:intl/intl.dart';

class ProductFormatters {
  static final NumberFormat _currencyFormat = NumberFormat.currency(
    symbol: 'ج.م',
    decimalDigits: 2,
    locale: 'ar',
  );

  static final NumberFormat _numberFormat = NumberFormat.decimalPattern('ar');

  static final DateFormat _dateFormat = DateFormat('yyyy/MM/dd', 'ar');

  static String formatPrice(double price) {
    return _currencyFormat.format(price);
  }

  static String formatNumber(int number) {
    return _numberFormat.format(number);
  }

  static String formatDate(DateTime date) {
    return _dateFormat.format(date);
  }

}
