import 'package:fpdart/fpdart.dart';
import 'package:stockflow/core/error/failures.dart';
import '../entities/customer.dart';
import '../entities/customer_filter_counts.dart';

abstract class CustomerRepository {
  Future<Either<Failure, List<Customer>>> listCustomers({
    String? query,
    String? filter,
    int? limit,
    int? offset,
    required String companyId,
  });

  Future<Either<Failure, CustomerFilterCounts>> getCustomerFilterCounts({
    String? query,
    required String companyId,
  });

  Future<Either<Failure, Customer>> getCustomer(
    String id,
    String companyId,
  );

  Future<Either<Failure, Customer>> createCustomer({
    required String name,
    String? nameOfficial,
    String? phone,
    String? address,
    double totalDebt = 0,
    String? imageUrl,
    required String companyId,
  });

  Future<Either<Failure, Customer>> updateCustomer({
    required String id,
    required String name,
    String? nameOfficial,
    String? phone,
    String? address,
    String? imageUrl,
    required String companyId,
  });

  Future<Either<Failure, String>> uploadCustomerImage(String filePath);
}
