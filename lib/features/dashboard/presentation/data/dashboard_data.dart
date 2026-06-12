import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_routes.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/widgets/app_snackbar.dart';
import '../models/activity_item.dart';
import '../models/dashboard_metric.dart';
import '../models/quick_action.dart';
import '../models/weekly_point.dart';

const List<DashboardMetric> dashboardMetrics = [
  DashboardMetric(
    title: AppStrings.dashboardProductsCount,
    value: '1,250',
    icon: Icons.inventory_2_outlined,
    iconBackground: AppColors.lightGreen,
    iconColor: AppColors.primary,
    valueColor: AppColors.secondary,
  ),
  DashboardMetric(
    title: AppStrings.dashboardTotalDebts,
    value: '8,750',
    currency: AppStrings.currencyEg,
    icon: Icons.account_balance_wallet_outlined,
    iconBackground: AppColors.lightRed,
    iconColor: AppColors.trendDown,
    valueColor: AppColors.secondary,
  ),
  DashboardMetric(
    title: AppStrings.dashboardCustomersCount,
    value: '320',
    icon: Icons.people_outline,
    iconBackground: AppColors.lightOrange,
    iconColor: AppColors.accent,
    valueColor: AppColors.secondary,
  ),
  DashboardMetric(
    title: AppStrings.dashboardMonthlyProfit,
    value: '42,100',
    currency: AppStrings.currencyEg,
    icon: Icons.trending_up,
    iconBackground: AppColors.lightGreen,
    iconColor: AppColors.primary,
    valueColor: AppColors.secondary,
  ),
];

const List<WeeklyPoint> weeklyPoints = [
  WeeklyPoint(label: 'س', value: 5),
  WeeklyPoint(label: 'ح', value: 8),
  WeeklyPoint(label: 'ن', value: 6),
  WeeklyPoint(label: 'ث', value: 9, isHighlighted: true),
  WeeklyPoint(label: 'ر', value: 7),
  WeeklyPoint(label: 'خ', value: 6),
  WeeklyPoint(label: 'ج', value: 4),
];

List<QuickAction> quickActions(BuildContext context) => [
      QuickAction(
        label: AppStrings.dashboardQuickInvoice,
        icon: Icons.receipt_long_outlined,
        iconBackground: AppColors.lightOrange,
        iconColor: AppColors.accent,
        onTap: () => context.go(AppRoutes.invoices),
      ),
      QuickAction(
        label: AppStrings.dashboardQuickProduct,
        icon: Icons.inventory_2_outlined,
        iconBackground: AppColors.lightGreen,
        iconColor: AppColors.primary,
        onTap: () => context.go(AppRoutes.products),
      ),
      QuickAction(
        label: AppStrings.dashboardQuickReport,
        icon: Icons.bar_chart_outlined,
        iconBackground: AppColors.lightGreen,
        iconColor: AppColors.primary,
        onTap: () => _showComingSoon(context),
      ),
      QuickAction(
        label: AppStrings.dashboardQuickExcel,
        icon: Icons.table_chart_outlined,
        iconBackground: AppColors.lightGreen,
        iconColor: AppColors.primary,
        onTap: () => _showComingSoon(context),
      ),
    ];

const List<ActivityItem> recentActivities = [
  ActivityItem(
    title: 'دفعة مستلمة',
    subtitle: 'متجر الهدى',
    amount: '2,350',
    icon: Icons.payments_outlined,
    iconBackground: AppColors.lightGreen,
    iconColor: AppColors.primary,
    amountColor: AppColors.primary,
  ),
  ActivityItem(
    title: 'فاتورة جديدة',
    subtitle: 'سوبر ماركت النور',
    amount: '4,980',
    icon: Icons.receipt_long_outlined,
    iconBackground: AppColors.lightOrange,
    iconColor: AppColors.accent,
    amountColor: AppColors.accent,
  ),
  ActivityItem(
    title: 'دين مسدد جزئياً',
    subtitle: 'شركة الصفوة',
    amount: '1,100',
    icon: Icons.account_balance_wallet_outlined,
    iconBackground: AppColors.lightRed,
    iconColor: AppColors.trendDown,
    amountColor: AppColors.trendDown,
  ),
];

void _showComingSoon(BuildContext context) {
  AppSnackbar.info(context, AppStrings.actionComingSoon);
}
