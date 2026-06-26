import 'package:stockflow/features/dashboard/domain/entities/dashboard_stats.dart';
import 'package:stockflow/features/dashboard/domain/entities/weekly_sales_point.dart';
import 'package:stockflow/features/dashboard/domain/entities/activity_entry.dart';
import 'weekly_sales_point_model.dart';
import 'activity_entry_model.dart';

/// JSON-deserializable version of [DashboardStats].
class DashboardStatsModel extends DashboardStats {
  const DashboardStatsModel({
    required super.productsCount,
    required super.customersCount,
    required super.totalDebt,
    required super.todaySales,
    required super.monthlyPayments,
    required super.weeklySales,
    required super.recentActivities,
    required super.fetchedAt,
  });

  factory DashboardStatsModel.fromRawData({
    required int productsCount,
    required int customersCount,
    required double totalDebt,
    required double todaySales,
    required double monthlyPayments,
    required List<Map<String, dynamic>> weeklySalesRaw,
    required List<Map<String, dynamic>> recentActivitiesRaw,
  }) {
    final List<WeeklySalesPoint> weeklySales = weeklySalesRaw
        .map(WeeklySalesPointModel.fromJson)
        .toList();
    final List<ActivityEntry> recentActivities = recentActivitiesRaw
        .map(ActivityEntryModel.fromJson)
        .toList();

    return DashboardStatsModel(
      productsCount: productsCount,
      customersCount: customersCount,
      totalDebt: totalDebt,
      todaySales: todaySales,
      monthlyPayments: monthlyPayments,
      weeklySales: weeklySales,
      recentActivities: recentActivities,
      fetchedAt: DateTime.now(),
    );
  }
}
