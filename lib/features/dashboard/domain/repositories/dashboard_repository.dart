import 'package:fpdart/fpdart.dart';
import 'package:stockflow/core/error/failures.dart';
import '../entities/dashboard_stats.dart';

/// Abstract contract for fetching aggregated dashboard data for a company.
abstract interface class DashboardRepository {
  /// Fetches all KPIs, weekly chart data, and recent activity for [companyId].
  Future<Either<Failure, DashboardStats>> getDashboardStats(String companyId);
}
