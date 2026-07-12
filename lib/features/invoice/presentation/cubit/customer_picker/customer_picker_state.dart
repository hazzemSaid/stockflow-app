import 'package:equatable/equatable.dart';
import 'package:makhzanflow/core/error/failures.dart';
import 'package:makhzanflow/features/customers/domain/entities/customer.dart';

enum CustomerPickerStatus { initial, loading, success, empty, error }

class CustomerPickerState extends Equatable {
  final CustomerPickerStatus status;
  final List<Customer> customers;
  final Failure? failure;
  final String query;

  const CustomerPickerState({
    this.status = CustomerPickerStatus.initial,
    this.customers = const [],
    this.failure,
    this.query = '',
  });

  CustomerPickerState copyWith({
    CustomerPickerStatus? status,
    List<Customer>? customers,
    Failure? failure,
    String? query,
    bool clearFailure = false,
  }) {
    return CustomerPickerState(
      status: status ?? this.status,
      customers: customers ?? this.customers,
      failure: clearFailure ? null : (failure ?? this.failure),
      query: query ?? this.query,
    );
  }

  @override
  List<Object?> get props => [
    status,
    customers,
    failure,
    query,
  ];
}
