import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../domain/entities/weekly_sales_point.dart';

/// Premium weekly sales bar chart built with fl_chart.
class WeeklySalesChart extends StatefulWidget {
  const WeeklySalesChart({super.key, required this.points});

  final List<WeeklySalesPoint> points;

  @override
  State<WeeklySalesChart> createState() => _WeeklySalesChartState();
}

class _WeeklySalesChartState extends State<WeeklySalesChart>
    with SingleTickerProviderStateMixin {
  int _touchedIndex = -1;
  late final AnimationController _controller;
  late final Animation<double> _anim;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _anim = CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic);
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.points.isEmpty) return const SizedBox.shrink();

    final maxY = widget.points
        .map((p) => p.amount)
        .reduce((a, b) => a > b ? a : b);
    final effectiveMax = maxY <= 0 ? 1000.0 : maxY * 1.25;

    return Container(
      padding: EdgeInsets.fromLTRB(
        AppSizes.spacingSmall,
        AppSizes.spacingMedium,
        AppSizes.spacingSmall,
        AppSizes.spacingSmall,
      ),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(AppSizes.radiusLarge),
        boxShadow: [
          BoxShadow(
            color: AppColors.textPrimary.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: AnimatedBuilder(
        animation: _anim,
        builder: (_, __) => SizedBox(
          height: 160.h,
          child: BarChart(
            BarChartData(
              maxY: effectiveMax,
              minY: 0,
              barTouchData: BarTouchData(
                touchTooltipData: BarTouchTooltipData(
                  getTooltipColor: (_) =>
                      AppColors.secondary.withValues(alpha: 0.9),
                  tooltipBorderRadius: BorderRadius.circular(8),
                  getTooltipItem: (group, groupIndex, rod, rodIndex) {
                    final point = widget.points[group.x];
                    final formatted =
                        NumberFormat('#,##0', 'ar').format(point.amount);
                    return BarTooltipItem(
                      '$formatted ج.م',
                      TextStyle(
                        fontFamily: 'Cairo',
                        color: AppColors.white,
                        fontSize: AppSizes.fontSmall,
                        fontWeight: FontWeight.w700,
                      ),
                    );
                  },
                ),
                touchCallback: (event, response) {
                  setState(() {
                    _touchedIndex =
                        response?.spot?.touchedBarGroupIndex ?? -1;
                  });
                },
              ),
              titlesData: FlTitlesData(
                show: true,
                topTitles: const AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                rightTitles: const AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                leftTitles: const AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 28,
                    getTitlesWidget: (value, meta) {
                      final i = value.toInt();
                      if (i < 0 || i >= widget.points.length) {
                        return const SizedBox.shrink();
                      }
                      final isToday = i == widget.points.length - 1;
                      return Padding(
                        padding: EdgeInsets.only(top: 4.h),
                        child: Text(
                          widget.points[i].label,
                          style: TextStyle(
                            fontFamily: 'Cairo',
                            fontSize: AppSizes.fontSmall,
                            fontWeight: isToday
                                ? FontWeight.w700
                                : FontWeight.w400,
                            color: isToday
                                ? AppColors.accent
                                : AppColors.textSecondary,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
              borderData: FlBorderData(show: false),
              gridData: FlGridData(
                show: true,
                drawVerticalLine: false,
                horizontalInterval: effectiveMax / 4,
                getDrawingHorizontalLine: (_) => FlLine(
                  color: AppColors.inputBorder.withValues(alpha: 0.5),
                  strokeWidth: 0.8,
                  dashArray: [4, 4],
                ),
              ),
              barGroups: List.generate(widget.points.length, (i) {
                final point = widget.points[i];
                final isToday = i == widget.points.length - 1;
                final isTouched = i == _touchedIndex;

                return BarChartGroupData(
                  x: i,
                  barRods: [
                    BarChartRodData(
                      toY: (point.amount * _anim.value).clamp(0, effectiveMax),
                      width: 18.w,
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(6.r),
                      ),
                      gradient: LinearGradient(
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                        colors: isToday || isTouched
                            ? [
                                AppColors.accent.withValues(alpha: 0.7),
                                AppColors.accent,
                              ]
                            : [
                                AppColors.primary.withValues(alpha: 0.4),
                                AppColors.primary.withValues(alpha: 0.85),
                              ],
                      ),
                      backDrawRodData: BackgroundBarChartRodData(
                        show: true,
                        toY: effectiveMax,
                        color:
                            AppColors.appBackground.withValues(alpha: 0.6),
                      ),
                    ),
                  ],
                );
              }),
            ),
            duration: const Duration(milliseconds: 300),
          ),
        ),
      ),
    );
  }
}
