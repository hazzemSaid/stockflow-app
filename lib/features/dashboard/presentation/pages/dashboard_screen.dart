import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../auth/presentation/cubit/auth_cubit.dart';
import '../../../auth/presentation/cubit/auth_state.dart';
import '../data/dashboard_data.dart';
import '../widgets/activity_list.dart';
import '../widgets/dashboard_header.dart';
import '../widgets/metric_card.dart';
import '../widgets/profit_summary_card.dart';
import '../widgets/quick_action_card.dart';
import '../widgets/section_header.dart';
import '../widgets/weekly_sales_chart.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authCubit = context.read<AuthCubit>();
    final userName = authCubit.state is Authenticated
        ? (authCubit.state as Authenticated).user.name
        : '';
    final userInitial = userName.isNotEmpty ? userName[0] : 'م';

    return Directionality(
      textDirection: TextDirection.rtl,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final metricWidth =
              (constraints.maxWidth - AppSizes.spacingMedium) / 2;
          final actionWidth =
              (constraints.maxWidth - (AppSizes.spacingSmall * 3)) / 4;

          return ListView(
            padding: EdgeInsets.only(bottom: AppSizes.spacingXXLarge + 80.h),
            children: [
              DashboardHeader(userName: userName, userInitial: userInitial),
              SizedBox(height: AppSizes.spacingMedium),
              _MetricsGrid(metricWidth: metricWidth),
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
                child: WeeklySalesChart(points: weeklyPoints),
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
                    color: AppColors.secondary,
                  ),
                ),
              ),
              SizedBox(height: AppSizes.spacingSmall),
              _QuickActionsGrid(actionWidth: actionWidth),
              SizedBox(height: AppSizes.spacingLarge),
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: AppSizes.spacingMedium,
                ),
                child: Text(
                  AppStrings.dashboardRecentActivity,
                  style: TextStyle(
                    fontFamily: 'Cairo',
                    fontSize: AppSizes.fontLarge,
                    color: AppColors.secondary,
                  ),
                ),
              ),
              SizedBox(height: AppSizes.spacingSmall),
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: AppSizes.spacingMedium,
                ),
                child: ActivityList(items: recentActivities),
              ),
              SizedBox(height: AppSizes.spacingLarge),
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: AppSizes.spacingMedium,
                ),
                child: const ProfitSummaryCard(),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _MetricsGrid extends StatelessWidget {
  final double metricWidth;

  const _MetricsGrid({required this.metricWidth});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: AppSizes.spacingMedium),
      child: GridView.count(
        crossAxisCount: 2,
        mainAxisSpacing: AppSizes.spacingMedium,
        crossAxisSpacing: AppSizes.spacingMedium,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        children: dashboardMetrics
            .map((metric) => SizedBox(child: MetricCard(metric: metric)))
            .toList(),
      ),
    );
  }
}

class _QuickActionsGrid extends StatelessWidget {
  final double actionWidth;

  const _QuickActionsGrid({required this.actionWidth});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: AppSizes.spacingMedium),
      child: Wrap(
        spacing: AppSizes.spacingSmall,
        runSpacing: AppSizes.spacingSmall,
        children: quickActions(context)
            .map(
              (action) => SizedBox(
                width: actionWidth,
                child: QuickActionCard(action: action),
              ),
            )
            .toList(),
      ),
    );
  }
}
