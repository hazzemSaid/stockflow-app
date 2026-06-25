import 'package:equatable/equatable.dart';
import 'package:stockflow/core/error/failures.dart';
import 'package:stockflow/features/invoice/domain/entities/invoice.dart';

enum CustomerInvoicesStatus { initial, loading, loadingMore, success, empty, error }

class CustomerInvoicesState extends Equatable {
  final CustomerInvoicesStatus status;
  final List<Invoice> invoices;
  final String customerName;
  final Failure? failure;
  final bool hasMore;

  const CustomerInvoicesState({
    this.status = CustomerInvoicesStatus.initial,
    this.invoices = const [],
    this.customerName = '',
    this.failure,
    this.hasMore = true,
  });

  CustomerInvoicesState copyWith({
    CustomerInvoicesStatus? status,
    List<Invoice>? invoices,
    String? customerName,
    Failure? failure,
    bool? hasMore,
  }) {
    return CustomerInvoicesState(
      status: status ?? this.status,
      invoices: invoices ?? this.invoices,
      customerName: customerName ?? this.customerName,
      failure: failure ?? this.failure,
      hasMore: hasMore ?? this.hasMore,
    );
  }

  @override
  List<Object?> get props => [
    status,
    invoices,
    customerName,
    failure,
    hasMore,
  ];
}
