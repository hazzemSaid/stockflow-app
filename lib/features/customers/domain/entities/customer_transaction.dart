import 'package:equatable/equatable.dart';

class CustomerTransaction extends Equatable {
  final String id;
  final String type;
  final double amount;
  final DateTime createdAt;
  final String title;
  final String subtitle;
  final String statusLabel;

  const CustomerTransaction({
    required this.id,
    required this.type,
    required this.amount,
    required this.createdAt,
    required this.title,
    required this.subtitle,
    required this.statusLabel,
  });

  @override
  List<Object?> get props =>
      [id, type, amount, createdAt, title, subtitle, statusLabel];
}
