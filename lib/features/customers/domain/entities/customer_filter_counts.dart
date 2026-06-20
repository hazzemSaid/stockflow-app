import 'package:equatable/equatable.dart';

class CustomerFilterCounts extends Equatable {
  final int totalCount;
  final int paidCount;
  final int partialCount;
  final int deferredCount;
  final double totalDebtSum;

  const CustomerFilterCounts({
    required this.totalCount,
    required this.paidCount,
    required this.partialCount,
    required this.deferredCount,
    required this.totalDebtSum,
  });

  const CustomerFilterCounts.zero()
      : totalCount = 0,
        paidCount = 0,
        partialCount = 0,
        deferredCount = 0,
        totalDebtSum = 0;

  @override
  List<Object?> get props => [
        totalCount,
        paidCount,
        partialCount,
        deferredCount,
        totalDebtSum,
      ];
}
