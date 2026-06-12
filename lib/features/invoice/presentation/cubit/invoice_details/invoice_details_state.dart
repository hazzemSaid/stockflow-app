import 'package:stockflow/core/error/failures.dart';
import 'package:stockflow/features/invoice/domain/entities/invoice.dart';

sealed class InvoiceDetailsState {}

class InvoiceDetailsInitial extends InvoiceDetailsState {}

class InvoiceDetailsLoading extends InvoiceDetailsState {}

class InvoiceDetailsLoaded extends InvoiceDetailsState {
  final Invoice invoice;
  InvoiceDetailsLoaded({required this.invoice});
}

class InvoiceDetailsError extends InvoiceDetailsState {
  final Failure failure;
  InvoiceDetailsError({required this.failure});
}
