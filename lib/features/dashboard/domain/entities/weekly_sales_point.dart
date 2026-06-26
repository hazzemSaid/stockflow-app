import 'package:equatable/equatable.dart';

/// One bar of the weekly sales chart — represents a single day.
class WeeklySalesPoint extends Equatable {
  const WeeklySalesPoint({
    required this.label,
    required this.amount,
    required this.date,
  });

  /// Arabic day abbreviation shown below the bar (e.g. 'أحد', 'اثن').
  final String label;

  /// Total invoice amount (sum) for that day.
  final double amount;

  /// The calendar date this point represents.
  final DateTime date;

  @override
  List<Object?> get props => [label, amount, date];
}
