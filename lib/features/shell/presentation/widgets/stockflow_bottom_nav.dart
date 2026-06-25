import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_routes.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_strings.dart';
import '../models/navigation_destination.dart';

class StockFlowBottomNav extends StatelessWidget {
  final StatefulNavigationShell navigationShell;

  const StockFlowBottomNav({super.key, required this.navigationShell});

  static const List<NavigationDestinationData> destinations = [
    NavigationDestinationData(
      route: '/dashboard',
      labelAr: AppStrings.navDashboard,
      semanticLabelAr: 'الرئيسية',
      icon: Icons.dashboard_outlined,
      sortOrderRtl: 0,
    ),
    NavigationDestinationData(
      route: '/products',
      labelAr: AppStrings.navProducts,
      semanticLabelAr: 'المنتجات',
      icon: Icons.inventory_2_outlined,
      sortOrderRtl: 1,
    ),
    NavigationDestinationData(
      route: '/invoices',
      labelAr: AppStrings.navInvoices,
      semanticLabelAr: 'فاتورة',
      icon: Icons.receipt_long_outlined,
      isCenterAction: true,
      sortOrderRtl: 2,
    ),
    NavigationDestinationData(
      route: '/customers',
      labelAr: AppStrings.navCustomers,
      semanticLabelAr: 'العملاء',
      icon: Icons.people_outline,
      sortOrderRtl: 3,
    ),

    NavigationDestinationData(
      route: '/settings',
      labelAr: AppStrings.navSettings,
      semanticLabelAr: 'الإعدادات',
      icon: Icons.settings_outlined,
      sortOrderRtl: 4,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final orderedDestinations = [...destinations]
      ..sort((a, b) => a.sortOrderRtl.compareTo(b.sortOrderRtl));

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.white,
          boxShadow: [
            BoxShadow(
              color: AppColors.textPrimary.withValues(alpha: 0.08),
              blurRadius: 8,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: SafeArea(
          top: false,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: AppSizes.spacingSmall),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: List.generate(orderedDestinations.length, (index) {
                final dest = orderedDestinations[index];
                final branchIndex = AppRoutes.shellRoutes.indexOf(dest.route);
                final isActive = branchIndex == navigationShell.currentIndex;
                return _NavItem(
                  destination: dest,
                  isActive: isActive,
                  onTap: () => navigationShell.goBranch(
                    branchIndex,
                    initialLocation:
                        branchIndex == navigationShell.currentIndex,
                  ),
                );
              }),
            ),
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final NavigationDestinationData destination;
  final bool isActive;
  final VoidCallback onTap;

  const _NavItem({
    required this.destination,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    if (destination.isCenterAction) {
      return Semantics(
        label: destination.semanticLabelAr,
        button: true,
        child: GestureDetector(
          onTap: onTap,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Transform.translate(
                offset: Offset(0, -9.h),
                child: Container(
                  width: 48.w,
                  height: 48.h,
                  decoration: BoxDecoration(
                    color: AppColors.accent,
                    borderRadius: BorderRadius.circular(16.r),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.accent.withValues(alpha: 0.45),
                        blurRadius: 20,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Icon(
                    destination.icon,
                    color: AppColors.white,
                    size: 22.w,
                  ),
                ),
              ),
              // SizedBox(height: AppSizes.spacingTiny),
              Transform.translate(
                offset: Offset(0, -5.h),
                child: Text(
                  destination.labelAr,
                  style: TextStyle(
                    fontFamily: 'Cairo',
                    fontSize: 9.sp,
                    color: AppColors.textSecondary,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Semantics(
      label: destination.semanticLabelAr,
      button: true,
      selected: isActive,
      child: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: AppSizes.spacingSmall),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                destination.icon,
                color: isActive ? AppColors.primary : AppColors.inactiveNav,
                size: 20.w,
              ),
              SizedBox(height: AppSizes.spacingTiny),
              Text(
                destination.labelAr,
                style: TextStyle(
                  fontFamily: 'Cairo',
                  fontSize: 10.sp,
                  color: isActive ? AppColors.primary : AppColors.inactiveNav,
                  fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

