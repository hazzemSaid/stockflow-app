import 'package:flutter/material.dart';
import 'package:makhzanflow/core/constants/app_colors.dart';
import 'package:makhzanflow/core/constants/app_sizes.dart';
import 'package:makhzanflow/core/constants/app_strings.dart';
import 'package:makhzanflow/features/dashboard/domain/entities/dashboard_stats.dart';
import 'metric_card.dart';

class DashboardMetricsGrid extends StatelessWidget {
  const DashboardMetricsGrid({
    super.key,
    required this.metricWidth,
    required this.stats,
  });

  final double metricWidth;
  final DashboardStats stats;

  @override
  Widget build(BuildContext context) {
    final metrics = [
      MetricCardData(
        title: AppStrings.dashboardProductsCount,
        value: stats.productsCount.toDouble(),
        icon: Icons.inventory_2_outlined,
        iconBackground: AppColors.lightGreen,
        iconColor: AppColors.primary,
        valueColor: AppColors.secondary,
        isCount: true,
      ),
      MetricCardData(
        title: AppStrings.dashboardTotalDebts,
        value: stats.totalDebt,
        currency: AppStrings.currencyEg,
        icon: Icons.account_balance_wallet_outlined,
        iconBackground: AppColors.lightRed,
        iconColor: AppColors.trendDown,
        valueColor: AppColors.secondary,
      ),
      MetricCardData(
        title: AppStrings.dashboardCustomersCount,
        value: stats.customersCount.toDouble(),
        icon: Icons.people_outline,
        iconBackground: AppColors.lightOrange,
        iconColor: AppColors.accent,
        valueColor: AppColors.secondary,
        isCount: true,
      ),
      MetricCardData(
        title: AppStrings.dashboardMonthlyProfit,
        value: stats.monthlyPayments,
        currency: AppStrings.currencyEg,
        icon: Icons.trending_up,
        iconBackground: AppColors.lightGreen,
        iconColor: AppColors.primary,
        valueColor: AppColors.secondary,
      ),
    ];

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: AppSizes.spacingMedium),
      child: GridView.count(
        crossAxisCount: 2,
        mainAxisSpacing: AppSizes.spacingMedium,
        crossAxisSpacing: AppSizes.spacingMedium,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        childAspectRatio: metricWidth / (metricWidth * 0.85),
        children: metrics
            .map((metric) => SizedBox(child: MetricCard(data: metric)))
            .toList(),
      ),
    );
  }
}
