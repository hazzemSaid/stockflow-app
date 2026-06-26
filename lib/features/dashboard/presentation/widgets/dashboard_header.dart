import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/widgets/app_network_image.dart';
import '../../../companies/domain/entities/company.dart';

/// Dashboard top header — shows greeting, company card, and today's sales.
class DashboardHeader extends StatelessWidget {
  const DashboardHeader({
    super.key,
    required this.userName,
    required this.userInitial,
    this.company,
    required this.todaySales,
  });

  final String userName;
  final String userInitial;
  final Company? company;

  /// Live today's total sales (sum of invoices.total_amount for today).
  final double todaySales;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        padding: EdgeInsets.fromLTRB(
          AppSizes.spacingMedium,
          AppSizes.spacingSmall,
          AppSizes.spacingMedium,
          AppSizes.spacingMedium,
        ),
        decoration: BoxDecoration(
          color: AppColors.primary,
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(AppSizes.radiusXLarge),
          ),
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppStrings.dashboardGreeting,
                      style: TextStyle(
                        fontFamily: 'Cairo',
                        fontSize: AppSizes.fontSmall,
                        color: AppColors.white.withValues(alpha: 0.7),
                      ),
                    ),
                    Text(
                      userName.isEmpty ? AppStrings.appNameArabic : userName,
                      style: TextStyle(
                        fontFamily: 'Cairo',
                        fontSize: AppSizes.fontXLarge,
                        fontWeight: FontWeight.w700,
                        color: AppColors.white,
                      ),
                    ),
                  ],
                ),
                if (company != null) _CompanyInfoCard(company: company!),
              ],
            ),
            SizedBox(height: AppSizes.spacingMedium),
            _TodaySalesCard(todaySales: todaySales),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Today's Sales Card (real data)
// ─────────────────────────────────────────────────────────────────────────────

class _TodaySalesCard extends StatelessWidget {
  const _TodaySalesCard({required this.todaySales});

  final double todaySales;

  @override
  Widget build(BuildContext context) {
    final formatted = NumberFormat('#,##0', 'ar').format(todaySales);

    return Container(
      padding: EdgeInsets.all(AppSizes.spacingSmall),
      decoration: BoxDecoration(
        color: AppColors.white.withValues(alpha: 0.1),
        borderRadius: BorderRadius.all(Radius.circular(AppSizes.radiusLarge)),
        border: Border.all(
          color: AppColors.white.withValues(alpha: 0.15),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppStrings.dashboardTodaySales,
            style: TextStyle(
              fontFamily: 'Cairo',
              fontSize: AppSizes.fontSmall,
              color: AppColors.white.withValues(alpha: 0.8),
            ),
          ),
          SizedBox(height: AppSizes.spacingTiny),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              // Amount display
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: formatted,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Cairo',
                        fontSize: AppSizes.fontXXLarge,
                        color: AppColors.white,
                      ),
                    ),
                    TextSpan(
                      text: ' ${AppStrings.currencyEg}',
                      style: TextStyle(
                        fontFamily: 'Cairo',
                        fontSize: AppSizes.fontSmall,
                        color: AppColors.white.withValues(alpha: 0.8),
                      ),
                    ),
                  ],
                ),
              ),
              // "Today" badge
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: AppSizes.spacingSmall,
                  vertical: 4.h,
                ),
                decoration: BoxDecoration(
                  color: AppColors.white.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
                ),
                child: Text(
                  AppStrings.dashboardTodayBadge,
                  style: TextStyle(
                    fontFamily: 'Cairo',
                    fontSize: AppSizes.fontSmall,
                    color: AppColors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Company Info Card
// ─────────────────────────────────────────────────────────────────────────────

class _CompanyInfoCard extends StatelessWidget {
  const _CompanyInfoCard({required this.company});

  final Company company;

  @override
  Widget build(BuildContext context) {
    final hasLogo = company.logoUrl != null && company.logoUrl!.isNotEmpty;
    final initial = company.name.isNotEmpty
        ? company.name[0].toUpperCase()
        : '?';

    return Container(
      constraints: BoxConstraints(maxWidth: 160.w),
      padding: EdgeInsets.symmetric(
        horizontal: AppSizes.spacingSmall,
        vertical: AppSizes.spacingTiny + 2,
      ),
      decoration: BoxDecoration(
        color: AppColors.white.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(AppSizes.radiusLarge),
        border: Border.all(
          color: AppColors.white.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 38.w,
            height: 38.w,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.white.withValues(alpha: 0.15),
              border: Border.all(
                color: AppColors.white.withValues(alpha: 0.3),
                width: 1.5,
              ),
            ),
            clipBehavior: Clip.antiAlias,
            child: hasLogo
                ? AppNetworkImage(
                    imageUrl: company.logoUrl!,
                    width: 38.w,
                    height: 38.w,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => _Initials(initial: initial),
                  )
                : _Initials(initial: initial),
          ),
          SizedBox(width: AppSizes.spacingSmall),
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  company.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontFamily: 'Cairo',
                    fontSize: AppSizes.fontSmall,
                    fontWeight: FontWeight.bold,
                    color: AppColors.white,
                    height: 1.3,
                  ),
                ),
                if (company.businessType != null &&
                    company.businessType!.isNotEmpty) ...[
                  SizedBox(height: 4.h),
                  _BusinessTypeBadge(label: company.businessType!),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Initials extends StatelessWidget {
  const _Initials({required this.initial});

  final String initial;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        initial,
        style: TextStyle(
          fontFamily: 'Cairo',
          fontSize: AppSizes.fontMedium,
          fontWeight: FontWeight.bold,
          color: AppColors.white,
        ),
      ),
    );
  }
}

class _BusinessTypeBadge extends StatelessWidget {
  const _BusinessTypeBadge({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
      decoration: BoxDecoration(
        color: AppColors.white.withValues(alpha: 0.18),
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Text(
        label,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          fontFamily: 'Cairo',
          fontSize: AppSizes.fontSmall,
          color: AppColors.white.withValues(alpha: 0.9),
          height: 1.2,
        ),
      ),
    );
  }
}
