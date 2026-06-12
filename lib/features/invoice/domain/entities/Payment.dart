import 'package:equatable/equatable.dart';

class Payment extends Equatable {
  final String id;
  final String invoiceId;
  final double amount;
  final DateTime createdAt;

  const Payment({
    required this.id,
    required this.invoiceId,
    required this.amount,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [id, invoiceId, amount, createdAt];
}
