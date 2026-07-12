import 'package:equatable/equatable.dart';
import 'package:makhzanflow/core/error/failures.dart';
import '../../../domain/entities/customer.dart';

enum CustomerDetailsStatus { initial, loading, success, error }

class CustomerDetailsState extends Equatable {
  final CustomerDetailsStatus status;
  final Customer? customer;
  final Failure? failure;

  const CustomerDetailsState({
    this.status = CustomerDetailsStatus.initial,
    this.customer,
    this.failure,
  });

  CustomerDetailsState copyWith({
    CustomerDetailsStatus? status,
    Customer? customer,
    Failure? failure,
  }) {
    return CustomerDetailsState(
      status: status ?? this.status,
      customer: customer ?? this.customer,
      failure: failure ?? this.failure,
    );
  }

  @override
  List<Object?> get props => [
    status,
    customer,
    failure,
  ];
}
