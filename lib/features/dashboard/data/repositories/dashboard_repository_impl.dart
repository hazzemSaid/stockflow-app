import 'package:fpdart/fpdart.dart';
import 'package:stockflow/core/error/exceptions.dart';
import 'package:stockflow/core/error/failures.dart';
import 'package:stockflow/features/dashboard/domain/entities/dashboard_stats.dart';
import 'package:stockflow/features/dashboard/domain/repositories/dashboard_repository.dart';
import '../datasources/dashboard_remote_data_source.dart';

class DashboardRepositoryImpl implements DashboardRepository {
  const DashboardRepositoryImpl(this._dataSource);

  final DashboardRemoteDataSource _dataSource;

  @override
  Future<Either<Failure, DashboardStats>> getDashboardStats(
      String companyId) async {
    try {
      final model = await _dataSource.getDashboardStats(companyId);
      return Right(model);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
