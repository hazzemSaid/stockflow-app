import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:makhzanflow/core/constants/app_colors.dart';
import 'package:makhzanflow/core/constants/app_sizes.dart';
import 'package:makhzanflow/core/constants/app_strings.dart';
import 'package:makhzanflow/features/companies/domain/entities/company.dart';
import 'package:makhzanflow/features/dashboard/domain/entities/dashboard_stats.dart';
import 'dashboard_metrics_grid.dart';
import 'dashboard_quick_actions_grid.dart';
import 'dashboard_header.dart';
import 'profit_summary_card.dart';
import 'section_header.dart';
import 'weekly_sales_chart.dart';

class DashboardLoadedBody extends StatelessWidget {
  const DashboardLoadedBody({
    super.key,
    required this.userName,
    required this.company,
    required this.stats,
    required this.isRefreshing,
    required this.onRefresh,
  });

  final String userName;
  final Company? company;
  final DashboardStats stats;
  final bool isRefreshing;
  final VoidCallback onRefresh;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final screenWidth = constraints.maxWidth;
        final metricWidth =
            (screenWidth -
                AppSizes.spacingMedium * 2 -
                AppSizes.spacingMedium) /
            2;
        final actionWidth =
            (screenWidth -
                AppSizes.spacingMedium * 2 -
                AppSizes.spacingSmall * 3) /
            4;

        return RefreshIndicator(
          onRefresh: () async => onRefresh(),
          color: AppColors.primary,
          child: ListView(
            padding: EdgeInsets.only(bottom: AppSizes.spacingXXLarge + 80.h),
            children: [
              if (isRefreshing)
                const LinearProgressIndicator(
                  minHeight: 2,
                  backgroundColor: AppColors.lightGreen,
                  valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
                ),
              DashboardHeader(
                userName: userName,
                userInitial: userName.isNotEmpty
                    ? userName[0]
                    : AppStrings.defaultInitial,
                company: company,
                todaySales: stats.todaySales,
              ),
              SizedBox(height: AppSizes.spacingMedium),
              DashboardMetricsGrid(metricWidth: metricWidth, stats: stats),
              SizedBox(height: AppSizes.spacingLarge),
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: AppSizes.spacingMedium,
                ),
                child: const SectionHeader(
                  title: AppStrings.dashboardWeeklySales,
                  subtitle: AppStrings.dashboardWeeklySalesSubtitle,
                ),
              ),
              SizedBox(height: AppSizes.spacingSmall),
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: AppSizes.spacingMedium,
                ),
                child: WeeklySalesChart(points: stats.weeklySales),
              ),
              SizedBox(height: AppSizes.spacingLarge),
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: AppSizes.spacingMedium,
                ),
                child: Text(
                  AppStrings.dashboardQuickActions,
                  style: TextStyle(
                    fontFamily: 'Cairo',
                    fontSize: AppSizes.fontLarge,
                    fontWeight: FontWeight.w600,
                    color: AppColors.secondary,
                  ),
                ),
              ),
              SizedBox(height: AppSizes.spacingSmall),
              DashboardQuickActionsGrid(actionWidth: actionWidth),
              SizedBox(height: AppSizes.spacingLarge),
              // Padding(
              //   padding: EdgeInsets.symmetric(
              //     horizontal: AppSizes.spacingMedium,
              //   ),
              //   child: const SectionHeader(
              //     title: AppStrings.dashboardRecentActivity,
              //     subtitle: AppStrings.dashboardRecentActivitySubtitle,
              //   ),
              // ),
              // SizedBox(height: AppSizes.spacingSmall),
              // Padding(
              //   padding: EdgeInsets.symmetric(
              //     horizontal: AppSizes.spacingMedium,
              //   ),
              //   child: ActivityList(
              //     entries: stats.recentActivities,
              //     onItemTap: (entry) {
              //       final id = entry.entityId;
              //       if (id != null) {
              //         context.go(AppRoutes.invoiceDetailsPath(id));
              //       }
              //     },
              //   ),
              // ),
              SizedBox(height: AppSizes.spacingLarge),
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: AppSizes.spacingMedium,
                ),
                child: ProfitSummaryCard(
                  monthlyPayments: stats.monthlyPayments,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
