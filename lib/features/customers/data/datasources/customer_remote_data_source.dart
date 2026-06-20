import 'package:fpdart/fpdart.dart';
import 'package:stockflow/core/error/failures.dart';
import '../models/customer_model.dart';
import '../models/customer_filter_counts_model.dart';

abstract class CustomerRemoteDataSource {
  Future<Either<Failure, List<CustomerModel>>> listCustomers({
    String? query,
    String? filter,
    int? limit,
    int? offset,
  });

  Future<Either<Failure, CustomerFilterCountsModel>> getFilterCounts({
    String? query,
  });

  Future<Either<Failure, CustomerModel>> getCustomer(String id);

  Future<Either<Failure, CustomerModel>> createCustomer({
    required String name,
    String? nameOfficial,
    String? phone,
    String? address,
    double totalDebt = 0,
    String? imageUrl,
  });

  Future<Either<Failure, CustomerModel>> updateCustomer({
    required String id,
    required String name,
    String? nameOfficial,
    String? phone,
    String? address,
    String? imageUrl,
  });

  Future<Either<Failure, String>> uploadImage(String filePath);
}
