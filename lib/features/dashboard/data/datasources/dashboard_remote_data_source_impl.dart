import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:stockflow/core/error/exceptions.dart';
import '../models/dashboard_stats_model.dart';
import 'dashboard_remote_data_source.dart';

class DashboardRemoteDataSourceImpl implements DashboardRemoteDataSource {
  DashboardRemoteDataSourceImpl(this._client);

  final SupabaseClient _client;

  @override
  Future<DashboardStatsModel> getDashboardStats(String companyId) async {
    try {
      final results = await Future.wait([
        _fetchProductsCount(companyId),
        _fetchCustomersCount(companyId),
        _fetchTotalDebt(companyId),
        _fetchTodaySales(companyId),
        _fetchMonthlyPayments(companyId),
        _fetchWeeklySales(companyId),
        _fetchRecentActivity(companyId),
      ]);

      return DashboardStatsModel.fromRawData(
        productsCount: results[0] as int,
        customersCount: results[1] as int,
        totalDebt: results[2] as double,
        todaySales: results[3] as double,
        monthlyPayments: results[4] as double,
        weeklySalesRaw: (results[5] as List).cast<Map<String, dynamic>>(),
        recentActivitiesRaw: (results[6] as List).cast<Map<String, dynamic>>(),
      );
    } on PostgrestException catch (e) {
      throw ServerException(e.message);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  // ── private helpers ────────────────────────────────────────────────────────

  Future<int> _fetchProductsCount(String companyId) async {
    final resp = await _client
        .from('products')
        .select()
        .eq('company_id', companyId)
        .count(CountOption.exact);
    return resp.count;
  }

  Future<int> _fetchCustomersCount(String companyId) async {
    final resp = await _client
        .from('customers')
        .select()
        .eq('company_id', companyId)
        .count(CountOption.exact);
    return resp.count;
  }

  Future<double> _fetchTotalDebt(String companyId) async {
    final data = await _client
        .from('invoices')
        .select('remaining_amount')
        .eq('company_id', companyId);
    final list = data as List;
    double sum = 0;
    for (final row in list) {
      sum += (row['remaining_amount'] as num?)?.toDouble() ?? 0.0;
    }
    return sum;
  }

  Future<double> _fetchTodaySales(String companyId) async {
    final today = DateTime.now();
    final startOfDay = DateTime(
      today.year,
      today.month,
      today.day,
    ).toIso8601String();
    final endOfDay = DateTime(
      today.year,
      today.month,
      today.day,
      23,
      59,
      59,
    ).toIso8601String();

    final data = await _client
        .from('payments')
        .select('amount')
        .eq('company_id', companyId)
        .eq('payment_type', 'payment')
        .gte('created_at', startOfDay)
        .lte('created_at', endOfDay);

    final list = data as List;
    double sum = 0;
    for (final row in list) {
      sum += (row['amount'] as num?)?.toDouble() ?? 0.0;
    }
    return sum;
  }

  Future<double> _fetchMonthlyPayments(String companyId) async {
    final now = DateTime.now();
    final startOfMonth = DateTime(now.year, now.month).toIso8601String();

    final data = await _client
        .from('payments')
        .select('amount')
        .eq('company_id', companyId)
        .eq('payment_type', 'payment')
        .gte('created_at', startOfMonth);

    final list = data as List;
    double sum = 0;
    for (final row in list) {
      sum += (row['amount'] as num?)?.toDouble() ?? 0.0;
    }
    return sum;
  }

  Future<List<Map<String, dynamic>>> _fetchWeeklySales(String companyId) async {
    // Build 7 days: today and the 6 preceding days (oldest → newest)
    final today = DateTime.now();
    final days = List.generate(
      7,
      (i) => DateTime(
        today.year,
        today.month,
        today.day,
      ).subtract(Duration(days: 6 - i)),
    );

    // Fetch all invoices in the 7-day window
    final startDate = days.first.toIso8601String();
    final endDate = DateTime(
      today.year,
      today.month,
      today.day,
      23,
      59,
      59,
    ).toIso8601String();

    final data = await _client
        .from('invoices')
        .select('total_amount, created_at')
        .eq('company_id', companyId)
        .gte('created_at', startDate)
        .lte('created_at', endDate);

    final list = data as List;

    // Group by date string (yyyy-MM-dd)
    final Map<String, double> totals = {for (final d in days) _dateKey(d): 0.0};
    for (final row in list) {
      final key = _dateKey(DateTime.parse(row['created_at'] as String));
      if (totals.containsKey(key)) {
        totals[key] =
            totals[key]! + ((row['total_amount'] as num?)?.toDouble() ?? 0.0);
      }
    }

    return days.map((d) {
      final key = _dateKey(d);
      return <String, dynamic>{'day': key, 'total': totals[key] ?? 0.0};
    }).toList();
  }

  Future<List<Map<String, dynamic>>> _fetchRecentActivity(
    String companyId,
  ) async {
    final data = await _client.rpc(
      'get_activity_log',
      params: {
        'p_company_id': companyId,
        'p_filter_days': 7,
        'p_page_limit': 5,
        'p_page_offset': 0,
      },
    );

    final list = data as List;
    return list.map((row) {
      final m = row as Map<String, dynamic>;
      return <String, dynamic>{
        'id': m['id'],
        'user_id': m['user_id'] ?? '',
        'user_name': m['user_name'] ?? '',
        'action': m['action'],
        'entity_type': m['entity_type'],
        'entity_id': m['entity_id'],
        'details': m['details'] ?? {},
        'created_at': m['created_at'],
      };
    }).toList();
  }

  static String _dateKey(DateTime d) =>
      '${d.year.toString().padLeft(4, '0')}-'
      '${d.month.toString().padLeft(2, '0')}-'
      '${d.day.toString().padLeft(2, '0')}';
}
