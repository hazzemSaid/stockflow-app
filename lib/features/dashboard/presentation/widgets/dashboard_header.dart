import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stockflow/core/widgets/app_network_image.dart';
import 'package:stockflow/features/companies/domain/entities/company.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_strings.dart';

class DashboardHeader extends StatelessWidget {
  final String userName;
  final String userInitial;
  Company? company;

  DashboardHeader({
    this.company,
    super.key,
    required this.userName,
    required this.userInitial,
  });

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
                        color: AppColors.white,
                      ),
                    ),
                  ],
                ),
                if (company != null) _CompanyInfoCard(company: company!),
              ],
            ),
            SizedBox(height: AppSizes.spacingMedium),
            Container(
              padding: EdgeInsets.all(AppSizes.spacingSmall),
              decoration: BoxDecoration(
                color: AppColors.white.withValues(alpha: 0.1),
                borderRadius: BorderRadius.all(
                  Radius.circular(AppSizes.radiusLarge),
                ),
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
                      color: AppColors.white,
                    ),
                  ),
                  SizedBox(height: AppSizes.spacingTiny),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const _TodaySalesAmount(),
                      const _TodaySalesTrend(),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Company Info Card
// ─────────────────────────────────────────────────────────────────────────────

class _CompanyInfoCard extends StatelessWidget {
  final Company company;

  const _CompanyInfoCard({required this.company});

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
          // ── Logo / Initials avatar ───────────────────────────
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
          // ── Name + address ───────────────────────────────────
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
                if (company.address != null && company.address!.isNotEmpty) ...[
                  SizedBox(height: 2.h),
                  Text(
                    company.address!,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontFamily: 'Cairo',
                      fontSize: AppSizes.fontSmall,
                      color: AppColors.white.withValues(alpha: 0.65),
                      height: 1.3,
                    ),
                  ),
                ],
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

/// Circular initials fallback shown when no logo URL is available.
class _Initials extends StatelessWidget {
  final String initial;
  const _Initials({required this.initial});

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

/// Small pill badge for the business type.
class _BusinessTypeBadge extends StatelessWidget {
  final String label;
  const _BusinessTypeBadge({required this.label});

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

// ─────────────────────────────────────────────────────────────────────────────
// Today's sales widgets (unchanged)
// ─────────────────────────────────────────────────────────────────────────────

class _TodaySalesAmount extends StatelessWidget {
  const _TodaySalesAmount();

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        children: [
          TextSpan(
            text: '24,500',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontFamily: 'Cairo',
              fontSize: AppSizes.fontXXLarge,
              color: AppColors.white,
            ),
          ),
          const TextSpan(text: ' '),
          TextSpan(
            text: AppStrings.currencyEg,
            style: TextStyle(
              fontFamily: 'Cairo',
              fontSize: AppSizes.fontSmall,
              color: AppColors.white,
            ),
          ),
        ],
      ),
    );
  }
}

class _TodaySalesTrend extends StatelessWidget {
  const _TodaySalesTrend();

  @override
  Widget build(BuildContext context) {
    const trendColor = Color(0xFFFDBA74);

    return Row(
      children: [
        Text(
          '+12.4%',
          style: TextStyle(
            fontFamily: 'Cairo',
            fontSize: AppSizes.fontSmall,
            color: trendColor,
          ),
        ),
        SizedBox(width: AppSizes.spacingTiny),
        Icon(Icons.trending_up, size: 14.w, color: trendColor),
      ],
    );
  }
}
