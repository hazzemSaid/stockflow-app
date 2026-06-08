import 'package:equatable/equatable.dart';
import 'package:stockflow/core/error/failures.dart';
import '../../../domain/entities/customer.dart';

enum CustomersStatus { initial, loading, success, empty, error }

class CustomersState extends Equatable {
  final CustomersStatus status;
  final List<Customer> customers;
  final String query;
  final Failure? failure;
  final int totalCount;
  final bool hasMore;
  final bool isLoadingMore;

  const CustomersState({
    this.status = CustomersStatus.initial,
    this.customers = const [],
    this.query = '',
    this.failure,
    this.totalCount = 0,
    this.hasMore = true,
    this.isLoadingMore = false,
  });

  CustomersState copyWith({
    CustomersStatus? status,
    List<Customer>? customers,
    String? query,
    Failure? failure,
    int? totalCount,
    bool? hasMore,
    bool? isLoadingMore,
  }) {
    return CustomersState(
      status: status ?? this.status,
      customers: customers ?? this.customers,
      query: query ?? this.query,
      failure: failure ?? this.failure,
      totalCount: totalCount ?? this.totalCount,
      hasMore: hasMore ?? this.hasMore,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
    );
  }

  @override
  List<Object?> get props => [
    status,
    customers,
    query,
    failure,
    totalCount,
    hasMore,
    isLoadingMore,
  ];
}
