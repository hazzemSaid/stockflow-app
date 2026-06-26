import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';

/// Animated shimmer skeleton for the full dashboard loading state.
class DashboardLoadingShimmer extends StatefulWidget {
  const DashboardLoadingShimmer({super.key});

  @override
  State<DashboardLoadingShimmer> createState() =>
      _DashboardLoadingShimmerState();
}

class _DashboardLoadingShimmerState extends State<DashboardLoadingShimmer>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _shimmer;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);
    _shimmer = CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut);
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _shimmer,
      builder: (_, __) {
        final base = Color.lerp(
          const Color(0xFFE8EEEB),
          const Color(0xFFC8DDD2),
          _shimmer.value,
        )!;
        final highlight = Color.lerp(
          AppColors.white.withValues(alpha: 0.6),
          AppColors.white.withValues(alpha: 0.9),
          _shimmer.value,
        )!;

        return ListView(
          padding: EdgeInsets.only(bottom: 80.h),
          children: [
            // Header skeleton
            _HeaderSkeleton(base: base, highlight: highlight),
            SizedBox(height: AppSizes.spacingMedium),
            // Metrics grid skeleton
            Padding(
              padding: EdgeInsets.symmetric(horizontal: AppSizes.spacingMedium),
              child: GridView.count(
                crossAxisCount: 2,
                mainAxisSpacing: AppSizes.spacingMedium,
                crossAxisSpacing: AppSizes.spacingMedium,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                childAspectRatio: 1.5,
                children: List.generate(
                  4,
                  (_) => _ShimmerBox(
                    base: base,
                    highlight: highlight,
                    radius: AppSizes.radiusLarge,
                  ),
                ),
              ),
            ),
            SizedBox(height: AppSizes.spacingLarge),
            // Chart skeleton
            Padding(
              padding: EdgeInsets.symmetric(horizontal: AppSizes.spacingMedium),
              child: _ShimmerBox(
                base: base,
                highlight: highlight,
                height: 190.h,
                radius: AppSizes.radiusLarge,
              ),
            ),
            SizedBox(height: AppSizes.spacingLarge),
            // Activity skeleton rows
            Padding(
              padding: EdgeInsets.symmetric(horizontal: AppSizes.spacingMedium),
              child: Column(
                children: List.generate(
                  4,
                  (_) => Padding(
                    padding: EdgeInsets.only(bottom: AppSizes.spacingSmall),
                    child: _ShimmerBox(
                      base: base,
                      highlight: highlight,
                      height: 56.h,
                      radius: AppSizes.radiusLarge,
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

// ─── Header skeleton ──────────────────────────────────────────────────────────

class _HeaderSkeleton extends StatelessWidget {
  const _HeaderSkeleton({required this.base, required this.highlight});

  final Color base;
  final Color highlight;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(
        AppSizes.spacingMedium,
        AppSizes.spacingMedium + MediaQuery.of(context).padding.top,
        AppSizes.spacingMedium,
        AppSizes.spacingLarge,
      ),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.85),
        borderRadius: BorderRadius.vertical(
          bottom: Radius.circular(AppSizes.radiusXLarge),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _ShimmerBox(
                    base: AppColors.white.withValues(alpha: 0.2),
                    highlight: AppColors.white.withValues(alpha: 0.35),
                    width: 60.w,
                    height: 12.h,
                    radius: 6,
                  ),
                  SizedBox(height: 6.h),
                  _ShimmerBox(
                    base: AppColors.white.withValues(alpha: 0.2),
                    highlight: AppColors.white.withValues(alpha: 0.35),
                    width: 120.w,
                    height: 18.h,
                    radius: 6,
                  ),
                ],
              ),
              _ShimmerBox(
                base: AppColors.white.withValues(alpha: 0.15),
                highlight: AppColors.white.withValues(alpha: 0.25),
                width: 120.w,
                height: 52.h,
                radius: AppSizes.radiusLarge,
              ),
            ],
          ),
          SizedBox(height: AppSizes.spacingMedium),
          _ShimmerBox(
            base: AppColors.white.withValues(alpha: 0.15),
            highlight: AppColors.white.withValues(alpha: 0.25),
            height: 70.h,
            radius: AppSizes.radiusLarge,
          ),
        ],
      ),
    );
  }
}

// ─── Generic shimmer box ──────────────────────────────────────────────────────

class _ShimmerBox extends StatelessWidget {
  const _ShimmerBox({
    required this.base,
    required this.highlight,
    this.width,
    this.height,
    required this.radius,
  });

  final Color base;
  final Color highlight;
  final double? width;
  final double? height;
  final double radius;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width ?? double.infinity,
      height: height ?? 110.h,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [base, highlight, base],
          stops: const [0, 0.5, 1],
        ),
        borderRadius: BorderRadius.circular(radius),
      ),
    );
  }
}
