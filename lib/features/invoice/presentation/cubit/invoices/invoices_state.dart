import 'package:equatable/equatable.dart';
import 'package:stockflow/core/error/failures.dart';
import 'package:stockflow/features/invoice/domain/entities/invoice.dart';
import 'package:stockflow/features/invoice/domain/entities/invoice_status.dart';

enum InvoicesStatus { initial, loading, success, empty, error }

class InvoicesState extends Equatable {
  final InvoicesStatus status;
  final List<Invoice> invoices;
  final Failure? failure;
  final InvoiceStatus? statusFilter;
  final String? customerId;

  const InvoicesState({
    this.status = InvoicesStatus.initial,
    this.invoices = const [],
    this.failure,
    this.statusFilter,
    this.customerId,
  });

  InvoicesState copyWith({
    InvoicesStatus? status,
    List<Invoice>? invoices,
    Failure? failure,
    InvoiceStatus? statusFilter,
    String? customerId,
    bool clearFailure = false,
  }) {
    return InvoicesState(
      status: status ?? this.status,
      invoices: invoices ?? this.invoices,
      failure: clearFailure ? null : (failure ?? this.failure),
      statusFilter: statusFilter ?? this.statusFilter,
      customerId: customerId ?? this.customerId,
    );
  }

  @override
  List<Object?> get props => [
    status,
    invoices,
    failure,
    statusFilter,
    customerId,
  ];
}
