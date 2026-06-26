import '../models/dashboard_stats_model.dart';

/// Contract for raw Supabase calls related to the dashboard.
abstract interface class DashboardRemoteDataSource {
  Future<DashboardStatsModel> getDashboardStats(String companyId);
}
