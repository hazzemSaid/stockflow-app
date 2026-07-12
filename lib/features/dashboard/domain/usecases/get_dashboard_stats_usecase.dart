import 'package:fpdart/fpdart.dart';
import 'package:makhzanflow/core/error/failures.dart';
import '../entities/dashboard_stats.dart';
import '../repositories/dashboard_repository.dart';

/// Single usecase that fetches all dashboard stats.
class GetDashboardStatsUseCase {
  const GetDashboardStatsUseCase(this._repository);

  final DashboardRepository _repository;

  Future<Either<Failure, DashboardStats>> call(String companyId) =>
      _repository.getDashboardStats(companyId);
}
