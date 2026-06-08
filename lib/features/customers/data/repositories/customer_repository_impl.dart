import 'package:fpdart/fpdart.dart';
import 'package:stockflow/core/error/failures.dart';
import '../../domain/entities/customer.dart';
import '../../domain/repositories/customer_repository.dart';
import '../datasources/customer_remote_data_source.dart';

class CustomerRepositoryImpl implements CustomerRepository {
  final CustomerRemoteDataSource dataSource;

  CustomerRepositoryImpl(this.dataSource);

  @override
  Future<Either<Failure, List<Customer>>> listCustomers({
    String? query,
    int? limit,
    int? offset,
  }) async {
    final result = await dataSource.listCustomers(
      query: query,
      limit: limit,
      offset: offset,
    );
    return result.map((models) => models.map((m) => m.toEntity()).toList());
  }

  @override
  Future<Either<Failure, Customer>> getCustomer(String id) async {
    final result = await dataSource.getCustomer(id);
    return result.map((model) => model.toEntity());
  }

  @override
  Future<Either<Failure, Customer>> createCustomer({
    required String name,
    String? nameOfficial,
    String? phone,
    String? address,
    double totalDebt = 0,
    String? imageUrl,
  }) async {
    if (name.trim().isEmpty) {
      return Left(ServerFailure('يرجى إدخال اسم العميل'));
    }
    final result = await dataSource.createCustomer(
      name: name,
      nameOfficial: nameOfficial,
      phone: phone,
      address: address,
      totalDebt: totalDebt,
      imageUrl: imageUrl,
    );
    return result.map((model) => model.toEntity());
  }

  @override
  Future<Either<Failure, Customer>> updateCustomer({
    required String id,
    required String name,
    String? nameOfficial,
    String? phone,
    String? address,
    String? imageUrl,
  }) async {
    if (name.trim().isEmpty) {
      return Left(ServerFailure('يرجى إدخال اسم العميل'));
    }
    final result = await dataSource.updateCustomer(
      id: id,
      name: name,
      nameOfficial: nameOfficial,
      phone: phone,
      address: address,
      imageUrl: imageUrl,
    );
    return result.map((model) => model.toEntity());
  }

  @override
  Future<Either<Failure, String>> uploadCustomerImage(String filePath) async {
    return dataSource.uploadImage(filePath);
  }
}
