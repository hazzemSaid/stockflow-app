import 'package:makhzanflow/features/dashboard/domain/entities/weekly_sales_point.dart';

/// Arabic short day names indexed by [DateTime.weekday] (1=Mon … 7=Sun).
const _kArabicDayLabels = <int, String>{
  1: 'اثن',
  2: 'ثلا',
  3: 'أرب',
  4: 'خمس',
  5: 'جمع',
  6: 'سبت',
  7: 'أحد',
};

class WeeklySalesPointModel extends WeeklySalesPoint {
  const WeeklySalesPointModel({
    required super.label,
    required super.amount,
    required super.date,
  });

  /// Expects a map with keys: [day] (ISO date string) and [total] (numeric).
  factory WeeklySalesPointModel.fromJson(Map<String, dynamic> json) {
    final date = DateTime.parse(json['day'] as String);
    final amount = (json['total'] as num?)?.toDouble() ?? 0.0;
    final label = _kArabicDayLabels[date.weekday] ?? '؟';
    return WeeklySalesPointModel(label: label, amount: amount, date: date);
  }
}
