import 'package:equatable/equatable.dart';
import 'package:makhzanflow/core/error/failures.dart';
import 'package:makhzanflow/features/customers/domain/entities/customer.dart';
import 'package:makhzanflow/features/invoice/domain/entities/invoice.dart';
import 'package:makhzanflow/features/invoice/domain/entities/invoice_status.dart';

enum InvoicesStatus { initial, loading, success, empty, error }

class InvoicesState extends Equatable {
  final InvoicesStatus status;
  final List<Invoice> invoices;
  final Failure? failure;
  final InvoiceStatus? statusFilter;
  final String? customerId;
  final List<Customer> customers;

  const InvoicesState({
    this.status = InvoicesStatus.initial,
    this.invoices = const [],
    this.failure,
    this.statusFilter,
    this.customerId,
    this.customers = const [],
  });

  InvoicesState copyWith({
    InvoicesStatus? status,
    List<Invoice>? invoices,
    Failure? failure,
    InvoiceStatus? statusFilter,
    String? customerId,
    List<Customer>? customers,
    bool clearFailure = false,
  }) {
    return InvoicesState(
      status: status ?? this.status,
      invoices: invoices ?? this.invoices,
      failure: clearFailure ? null : (failure ?? this.failure),
      statusFilter: statusFilter ?? this.statusFilter,
      customerId: customerId ?? this.customerId,
      customers: customers ?? this.customers,
    );
  }

  @override
  List<Object?> get props => [
    status,
    invoices,
    failure,
    statusFilter,
    customerId,
    customers,
  ];
}
